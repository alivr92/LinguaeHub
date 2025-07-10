from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse
from django.db.models import Exists, OuterRef
from django.urls import reverse_lazy
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from django.contrib.auth.mixins import LoginRequiredMixin
from django.views.generic import View, TemplateView, ListView, DeleteView
from ap2_tutor.models import Tutor
from ap2_student.models import Student, WishList
from app_accounts.models import UserProfile
from ap2_meeting.models import Session, Review
from .forms import CombinedProfileForm
from django.http import JsonResponse
from django.utils import timezone
from utils.mixins import RoleRequiredMixin, ActivationRequiredMixin, VIPRequiredMixin
from utils.pages import error_page
from utils.email import send_activation_email
from datetime import timedelta
from django.utils.crypto import get_random_string
import logging
from django.conf import settings
from django.core.cache import cache
from django.utils.decorators import method_decorator
from django.views.decorators.cache import never_cache
from django.views.decorators.http import require_POST

logger = logging.getLogger(__name__)


# DASHBOARD STUDENT ---------------------------------------------------------------------------------------------


class ActivationRequiredView(LoginRequiredMixin, RoleRequiredMixin, TemplateView):
    allowed_roles = ['student']
    template_name = 'ap2_student/dashboard/activation_required2.html'

    @method_decorator(never_cache)
    def dispatch(self, request, *args, **kwargs):
        if request.user.profile.is_active:
            return redirect('student:ds_home')
        return super().dispatch(request, *args, **kwargs)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        cache_key = f'activation_attempts_{user.id}'
        attempts = cache.get(cache_key, 0)
        context.update({
            'resend_url': reverse('student:resend_activation'),
            'next_resend': self.get_next_resend_time(user),
            'max_attempts': settings.ACTIVATION_MAX_ATTEMPTS,
            'attempts_remaining': settings.ACTIVATION_MAX_ATTEMPTS - attempts,
        })
        return context

    def get_next_resend_time(self, user):
        cache_key = f'activation_cooldown_{user.id}'
        cooldown_until = cache.get(cache_key)
        if cooldown_until:
            return cooldown_until - timezone.now()
        return None


class ActivationRequiredView111(LoginRequiredMixin, TemplateView):
    template_name = 'ap2_student/dashboard/activation_required.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['resend_url'] = reverse('student:activation_required')
        return context


@method_decorator(require_POST, name='dispatch')
class ResendActivationView(LoginRequiredMixin, View):
    def post(self, request, *args, **kwargs):
        user = request.user
        profile = user.profile

        # Security checks
        if profile.is_active:
            return JsonResponse({'error': 'Account is already active'}, status=400)

        attempt_cache_key = f'activation_attempts_{user.id}'
        cooldown_cache_key = f'activation_cooldown_{user.id}'

        attempts = cache.get(attempt_cache_key, 0) + 1
        cache.set(attempt_cache_key, attempts, timeout=3600)  # 1 hour window

        if attempts > settings.ACTIVATION_MAX_ATTEMPTS:
            return JsonResponse({
                'error': 'Too many attempts. Please try again later.',
                'next_resend': cache.get(cooldown_cache_key) - timezone.now()
            }, status=429)

        # Implement cooldown
        cooldown = settings.ACTIVATION_COOLDOWN * (2 ** (attempts - 1))  # Exponential backoff
        cooldown_until = timezone.now() + timedelta(seconds=cooldown)
        cache.set(cooldown_cache_key, cooldown_until, timeout=cooldown)

        # Generate and send new token
        profile.activation_token = get_random_string(64)
        profile.token_expiry = timezone.now() + timedelta(days=1)
        profile.save()

        activation_url = request.build_absolute_uri(
            reverse('student:ds_home') + f'?token={profile.activation_token}'
        )
        send_activation_email(request, user, activation_url)

        return JsonResponse({
            'success': True,
            'message': 'Activation email sent',
            'next_resend': cooldown,
            'attempts_remaining': settings.ACTIVATION_MAX_ATTEMPTS - attempts
        })


class DSHome(LoginRequiredMixin, RoleRequiredMixin, TemplateView):
    allowed_roles = ['student']
    template_name = 'ap2_student/dashboard/ds_home.html'

    @method_decorator(never_cache)
    def dispatch(self, request, *args, **kwargs):
        if not request.user.profile.is_active:
            token = request.GET.get('token')

            if not token:
                return redirect('student:activation_required')

            try:
                profile = request.user.profile
                if profile.activation_token != token:
                    raise UserProfile.DoesNotExist

                if profile.token_expiry and profile.token_expiry < timezone.now():
                    messages.error(request, "Activation link expired")
                    return redirect('student:activation_required')

                # Successful activation
                profile.is_active = True
                profile.activation_token = None
                profile.token_expiry = None
                profile.save()

                # Clear any attempt counters
                cache.delete(f'activation_attempts_{request.user.id}')
                cache.delete(f'activation_cooldown_{request.user.id}')

                messages.success(request, "Account activated successfully!")
                return redirect('student:ds_home')

            except UserProfile.DoesNotExist:
                messages.error(request, "Invalid activation link")
                return redirect('student:activation_required')

        return super().dispatch(request, *args, **kwargs)


class DSHome111(LoginRequiredMixin, RoleRequiredMixin, TemplateView):
    allowed_roles = ['student']
    template_name = 'ap2_student/dashboard/ds_home.html'
    success_url = reverse_lazy('student:ds_home')

    def get_require_valid_token(self):
        """Determine if token validation is needed based on user's activation status"""
        return not self.request.user.profile.is_active

    def dispatch(self, request, *args, **kwargs):
        if self.get_require_valid_token():
            token = request.GET.get('token')

            if not token:
                messages.error(request, "Activation required: You need a valid activation link to access this page.")
                return redirect('student:activation_required')

            try:
                profile = request.user.profile
                if profile.activation_token != token:
                    raise UserProfile.DoesNotExist

                if profile.token_expiry and profile.token_expiry < timezone.now():
                    messages.error(request, "This activation link has expired. Please request a new one.")
                    return redirect('student:ds_home')

                # Activate the profile
                profile.is_active = True
                profile.activation_token = None
                profile.token_expiry = None
                profile.save()

                messages.success(request, "Your account has been successfully activated!")
                return redirect('student:ds_home')

            except UserProfile.DoesNotExist:
                messages.error(request, "Invalid activation link. Please request a new one.")
                return redirect('student:ds_home')

        return super().dispatch(request, *args, **kwargs)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['require_valid_token'] = self.get_require_valid_token()
        return context


@login_required
def resend_verification(request):
    if request.method == "POST":
        try:
            profile = request.user.profile
            if profile.is_active:
                return JsonResponse({
                    "success": False,
                    "error": "Your account is already active"
                })

            # Generate new token
            profile.activation_token = get_random_string(64)
            profile.token_expiry = timezone.now() + timedelta(days=1)
            profile.save()

            # Build activation URL
            activation_url = request.build_absolute_uri(
                reverse('student:ds_home') + f'?token={profile.activation_token}'
            )

            # Send email
            send_activation_email(request, request.user, activation_url)

            return JsonResponse({
                "success": True,
                "message": "Activation email sent. Please check your inbox."
            })

        except Exception as e:
            logger.error(f"Error resending verification: {str(e)}")
            return JsonResponse({
                "success": False,
                "error": "An error occurred. Please try again later."
            }, status=500)

    return JsonResponse({
        "success": False,
        "error": "Invalid request method"
    }, status=400)


class DSSubscription(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, TemplateView):
    allowed_roles = ['student']
    template_name = 'ap2_student/dashboard/ds_subscription.html'


class DSClassList(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, ListView):
    allowed_roles = ['student']
    model = Session
    template_name = 'ap2_student/dashboard/ds_class_list.html'
    paginate_by = 6
    max_days = 10  # Your maximum scale for time_left to start a class

    def get_queryset(self):
        # Assuming the logged-in user is a student and you have a relationship between student and UserProfile
        sessions = Session.objects.filter(students__profile__user=self.request.user).order_by('-start_session_utc')

        for session in sessions:
            time_left = session.start_session_utc - timezone.now()
            session.time_left_days = max(0, time_left.days)
            session.time_left_hours = max(0, time_left.seconds // 3600)
            # Calculate percentage for progress bar (adjust max_days as needed)
            session.progress_percent = min(100, max(0, 100 - (session.time_left_days * 100 // self.max_days)))
            session.is_upcoming = (time_left.total_seconds() > 0)  # True if session hasn't started

        return sessions

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        student_id = self.request.user.profile.student_profile.pk

        # Annotate each session with a flag indicating if the current student has reviewed it
        sessions = Session.objects.annotate(
            has_reviewed=Exists(
                Review.objects.filter(
                    session_id=OuterRef('pk'),
                    student_id=student_id
                )
            )
        )

        context['sessions'] = sessions
        context['max_days'] = self.max_days
        return context

    def post(self, request, *args, **kwargs):
        if request.method == 'POST':
            tutor_id = request.POST.get('tutorId')
            student_id = int(request.POST.get('studentId'))
            if request.user.profile.student_profile.pk != student_id:
                messages.error(self.request, f'you just allow to send feedback on your classes not more!')
                return redirect('accounts:sign_out')
            # print(f'studenId: {type(student_id)}, request: {type(request.user.profile.student_profile.pk)}')
            session_id = request.POST.get('sessionId')
            rate_tutor = request.POST.get('rate_tutor')
            rate_session = request.POST.get('rate_session')
            msg = request.POST.get('msg')

            if Review.objects.filter(session_id=session_id, student_id=student_id):
                messages.error(self.request, 'You have posted your review for this session before! You are allow to '
                                             'send your feedback just one time!')
                return redirect(reverse('student:ds_class_list'))

            # Create and save the review
            Review.objects.create(
                tutor_id=tutor_id,
                student_id=student_id,
                session_id=session_id,
                rate_tutor=rate_tutor,
                rate_session=rate_session,
                message=msg
            )

            # Redirect to the same page after submission
            return redirect(reverse('student:ds_class_list'))

        return super().get(request, *args, **kwargs)


# def ds_review_save(request):
#     if request.method == 'POST':
#
#         tutorId = request.POST['tutorId']
#         studentId = request.POST['studentId']
#         sessionId = request.POST['sessionId']
#         rate_tutor = request.POST['rate_tutor']
#         rate_session = request.POST['rate_session']
#         msg = request.POST['msg']
#         # print(f'message: {msg}')
#         # return
#         review = Review.objects.create(tutor_id=tutorId, student_id=studentId, message=msg, session_id=sessionId,
#                                        rate_tutor=rate_tutor, rate_session=rate_session,
#                                        )
#         review.save()


class DSCourseResume(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, TemplateView):
    allowed_roles = ['student']
    template_name = 'ap2_student/dashboard/ds_course_resume.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context


class DSQuiz(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, TemplateView):
    allowed_roles = ['student']
    template_name = 'ap2_student/dashboard/ds_quiz.html'


class DSPaymentInfo(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, ListView):
    allowed_roles = ['student']
    template_name = 'ap2_student/dashboard/ds_payment_info.html'
    model = Tutor  # Must change to Order Payments !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    paginate_by = 5


class DSBookmark(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, ListView):
    allowed_roles = ['student']
    template_name = 'ap2_student/dashboard/ds_bookmark.html'
    model = Tutor  # Must change to Order Payments !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    paginate_by = 5


# def toggle_wishlist(request):
#     if request.method == 'POST':
#         student = request.user.student  # Assuming `request.user` is linked to the Student model
#         tutor_id = request.POST.get('tutor_id')
#         tutor = get_object_or_404(Tutor, id=tutor_id)
#
#         wishlist_entry, created = Wishlist.objects.get_or_create(student=student, tutor=tutor)
#
#         if not created:  # If it already exists, remove it
#             wishlist_entry.delete()
#             return JsonResponse({'status': 'removed'})
#         return JsonResponse({'status': 'added'})


# Tutor must change to student! ???????????????????????????????????????????
class DSEdit(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, View):
    allowed_roles = ['student']
    template_name = 'ap2_student/dashboard/ds_edit.html'
    success_url = reverse_lazy('student:ds_home')

    def get(self, request, *args, **kwargs):
        pk = kwargs.get('pk')  # Retrieve the pk from the URL
        user = request.user
        user_profile = UserProfile.objects.get(user=user)
        student = Student.objects.get(profile=user_profile)
        form = CombinedProfileForm(
            user_instance=user,
            user_profile_instance=user_profile,
            student_instance=student
        )
        context = {'form': form, 'student': student}
        return render(request, self.template_name, context)

    def post(self, request, *args, **kwargs):
        pk = kwargs.get('pk')  # Retrieve the pk from the URL
        user = request.user
        user_profile = UserProfile.objects.get(user=user)
        student = Student.objects.get(profile=user_profile)
        form = CombinedProfileForm(
            request.POST, request.FILES,
            user_instance=user,
            user_profile_instance=user_profile,
            student_instance=student
        )
        if form.is_valid():
            form.save(user)
            messages.success(request, 'Your changes saved successfully.')
            return redirect(self.success_url)
        else:
            form = CombinedProfileForm(user_instance=user, user_profile_instance=user_profile, student_instance=student)
        return render(request, self.template_name, {'form': form})


class DSSetting(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, TemplateView):
    allowed_roles = ['student']
    template_name = 'ap2_student/dashboard/ds_setting.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # context['tutor'] = self.get_object()  # Get the current tutor object
        return context


class DSDeleteAccount(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, DeleteView):
    allowed_roles = ['student']
    template_name = 'ap2_student/dashboard/ds_delete_account.html'
    model = Student  # Must CHECK !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
