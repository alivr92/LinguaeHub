from django.db.models import Q
from django.shortcuts import render, redirect, get_object_or_404
from django.views.generic import View, TemplateView, ListView, DetailView, FormView
from django.contrib.auth.mixins import LoginRequiredMixin
from django.urls import reverse_lazy, reverse
from django.contrib import messages
from django.contrib.auth.models import User
from django.http import JsonResponse
from django.views.decorators.http import require_POST
from django.contrib.auth.decorators import login_required
from django.views.decorators.csrf import csrf_exempt
from django.core.mail import send_mail, EmailMessage, EmailMultiAlternatives
from django.template.loader import render_to_string
from django.conf import settings
from django.utils import timezone
from django.utils.crypto import get_random_string
from datetime import datetime, timedelta
import pytz
from app_accounts.models import UserProfile
from ap2_meeting.models import Review, AppointmentSetting, Session
from ap2_tutor.models import Tutor, ProviderApplication, STATUS_WIZARD
from ap2_student.models import Student
from app_pages.models import ContactUs
from app_accounts.models import Level, UserSkill, Skill, LEVEL_CHOICES, SKILL_STATUS_CHOICES
from app_accounts.views import error_page
# from payments.models import Bill
from .forms import CombinedProfileForm, InterviewAcceptForm
from utils.email import send_dual_email
from utils.mixins import RoleRequiredMixin
from django.db import transaction


# DASHBOARD ADMIN (SUPERUSER)   --------------------------------------------------------------------------------
class DAHome(LoginRequiredMixin, RoleRequiredMixin, TemplateView):
    template_name = 'app_admin/dashboard/da_home.html'
    allowed_roles = ['admin']

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context


# class DASettings(LoginRequiredMixin, FormView):
#     template_name = 'app_admin/dashboard/da_setting.html'
#     form_class = SiteSettingsForm
#     success_url = reverse_lazy('my_admin:da_settings')
#
#     def get_context_data(self, **kwargs):
#         context = super().get_context_data(**kwargs)
#         return context
#
#     def form_valid(self, form):
#         form.save()
#         messages.success(self.request, 'Your settings saved successfully.')
#         return super().form_valid(form)
#
#     def form_invalid(self, form):
#         messages.error(self.request, "Your setting changes didn't apply. Please check the error messages!")
#         return self.render_to_response(self.get_context_data(form=form))

class DAInterview(LoginRequiredMixin, RoleRequiredMixin, TemplateView):
    allowed_roles = ['admin']
    template_name = 'app_admin/dashboard/interview/da_interview.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)

        try:
            # Get the appointment settings for the current user
            appointment_settings = AppointmentSetting.objects.get(user=self.request.user)
            timezone = appointment_settings.timezone
        except AppointmentSetting.DoesNotExist:
            timezone = None  # Default to None if not found

        # Handle timezone for date objects
        tz = pytz.timezone(timezone) if timezone else pytz.UTC
        context['today'] = datetime.now(tz).date()
        context['providerUId'] = self.request.user.id

        # Validate tutor profile existence to avoid errors
        if hasattr(self.request.user.profile, 'tutor_profile'):
            context['provider_id'] = self.request.user.profile.tutor_profile.id

        return context


class DASettings(LoginRequiredMixin, RoleRequiredMixin, TemplateView):
    allowed_roles = ['admin']
    template_name = 'app_admin/dashboard/da_setting.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context


class DAReview(LoginRequiredMixin, RoleRequiredMixin, ListView):
    allowed_roles = ['admin']
    template_name = 'app_admin/dashboard/da_review.html'
    model = Review
    paginate_by = 4

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # context['range'] = range(1, 6)  # we use this for rating stars
        return context


@csrf_exempt  # Delete Before Release!!!!!!
def toggle_publish_status(request):
    if request.method == "POST":
        review_id = request.POST.get("id")
        is_published = request.POST.get("is_published") == "true"
        review = get_object_or_404(Review, id=review_id)
        review.is_published = is_published
        review.save()
        return JsonResponse({"success": True, "is_published": review.is_published})
    return JsonResponse({"success": False, "error": "Invalid request"})


class DAContactUs(LoginRequiredMixin, RoleRequiredMixin, ListView):
    allowed_roles = ['admin']
    template_name = 'app_admin/dashboard/da_contact_us.html'
    model = ContactUs
    paginate_by = 5
    ordering = '-create_date'


class DACourseList(LoginRequiredMixin, RoleRequiredMixin, ListView):
    allowed_roles = ['admin']
    template_name = 'app_admin/dashboard/da_course_list.html'
    model = Tutor  # Must change to Course


class DACourseCategory(LoginRequiredMixin, RoleRequiredMixin, ListView):
    allowed_roles = ['admin']
    template_name = 'app_admin/dashboard/da_course_category.html'
    model = Tutor  # Must change to Course


class DACourseDetail(LoginRequiredMixin, RoleRequiredMixin, DetailView):
    allowed_roles = ['admin']
    template_name = 'app_admin/dashboard/da_course_list.html'
    model = Tutor  # Must change to Course


class DAStudentList(LoginRequiredMixin, RoleRequiredMixin, ListView):
    allowed_roles = ['admin']
    template_name = 'app_admin/dashboard/da_student_list.html'
    model = Student
    paginate_by = 6
    ordering = ['-profile__create_date']


class DATutorList(LoginRequiredMixin, RoleRequiredMixin, ListView):
    allowed_roles = ['admin']
    template_name = 'app_admin/dashboard/da_tutor_list.html'
    model = Tutor
    paginate_by = 9
    ordering = ['-create_date']

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['range'] = range(1, 6)  # we use this for rating stars
        return context


class DATutorDetail(LoginRequiredMixin, RoleRequiredMixin, DetailView):
    allowed_roles = ['admin']
    template_name = 'app_admin/dashboard/da_tutor_detail.html'
    model = Tutor

    def get_context_data(self, **kwargs):
        # Get the tutor ID from self.object or self.kwargs
        tutorId = self.object.pk  # or self.kwargs['pk']
        context = super().get_context_data(**kwargs)
        context['range'] = range(1, 6)  # we use this for rating stars
        # context['reviews'] = Review.objects.filter(tutor_id=tutorId)
        return context


class DAProviderRequest(LoginRequiredMixin, RoleRequiredMixin, ListView):
    allowed_roles = ['admin', 'tutor']  # BEFORE_RELEASE :  IT MUST CHANGE TO admin !!!!!!!!!!!!!!!!!!
    template_name = 'app_admin/dashboard/da_tutor_request.html'
    model = ProviderApplication
    context_object_name = 'applicants'
    ordering = '-date_submitted'
    paginate_by = 5

    def get_queryset(self):
        queryset = super().get_queryset()

        # Get filter parameters from request
        self.order_filter = self.request.GET.get('order')
        self.status_filter = self.request.GET.get('status')
        self.search_query = self.request.GET.get('search')

        # Apply status filter if provided
        if self.status_filter and self.status_filter != 'all':
            queryset = queryset.filter(status=self.status_filter)

        # Apply ordering filter if provided
        if self.order_filter:
            queryset = queryset.order_by('date_submitted')
        else:
            queryset = queryset.order_by('-date_submitted')

        # Apply search filter if provided
        if self.search_query:
            queryset = queryset.filter(
                Q(first_name__icontains=self.search_query) |
                Q(last_name__icontains=self.search_query) |
                Q(email__icontains=self.search_query) |
                Q(bio__icontains=self.search_query)
            )

        return queryset

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)

        # Add current filter values to context
        context['current_order'] = self.order_filter
        context['current_status'] = self.status_filter
        context['current_search'] = self.search_query

        # Add all status choices for the filter dropdown
        # context['status_choices'] = ProviderApplication.STATUS_CHOICES
        context['status_choices'] = STATUS_WIZARD
        context['all_skills'] = Skill.objects.all()
        context['LEVEL_CHOICES'] = LEVEL_CHOICES
        context['SKILL_STATUS_CHOICES'] = SKILL_STATUS_CHOICES

        # Attach the interview session to each applicant
        for applicant in context['applicants']:
            applicant.accept_form = InterviewAcceptForm(prefix=f'accept_{applicant.id}')

            session = Session.objects.filter(
                clients=applicant.user,
                session_type='interview'
            ).first()
            applicant.interview_session = session  # Attach session object

            # check status and change from scheduled to decision if the meeting time was passed!
            if applicant.status == 'scheduled' and session:
                if timezone.now() > applicant.interview_session.end_session_utc:
                    applicant.status = 'decision'
                    applicant.save()

                # Create skill mapping
                skill_map = {s.id: s for s in Skill.objects.all()}
                context['skill_map'] = skill_map

            for applicant in context['applicants']:
                initial_skills = []
                for skill in applicant.skills.all():
                    try:
                        user_skill = UserSkill.objects.get(user=applicant.user, skill=skill)
                        initial_skills.append({
                            'skill': skill,  # Pass the actual skill object
                            'level': user_skill.level,
                            'enabled': True
                        })
                    except UserSkill.DoesNotExist:
                        initial_skills.append({
                            'skill': skill,
                            'max_level': 'A1',
                            'enabled': False
                        })
                applicant.initial_skills = initial_skills

        return context


@login_required
@require_POST
def update_applicant_status(request, applicant_id):
    if not request.headers.get('x-requested-with') == 'XMLHttpRequest' or not request.method == 'POST':
    # if request.method == 'POST' and request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        return JsonResponse({'error': 'Invalid request'}, status=400)

    try:
        applicant = ProviderApplication.objects.get(pk=applicant_id)
        status = request.POST.get('status')
        print(f'state: {status}')

        if status not in dict(STATUS_WIZARD).keys():
            return JsonResponse({'error': 'Invalid status'}, status=400)

        # Handle special cases
        if status == 'invited':
            # Generate invitation token (valid for 7 days)
            applicant.invitation_token = get_random_string(64)
            applicant.token_expiry = timezone.now() + timedelta(days=7)

            # Build the registration URL
            registration_url = request.build_absolute_uri(
                reverse('accounts:sign_up_tutor') + f'?token={applicant.invitation_token}')
            # Send acceptance email with registration link
            send_invitation_email(applicant, registration_url)
            # Update status
            applicant.status = status

        elif status == 'rejected':
            # set rejection comment
            reviewer_comment = request.POST.get('reviewer_comment', '')
            applicant.reviewer_comment = reviewer_comment
            # DEACTIVATE Provider profile (OR remove related tutor profile!)
            applicant.user.profile.is_active = False
            # send REJECT decision email
            send_rejection_email(applicant, reviewer_comment)
            # Update status
            applicant.status = status

        elif status == 'accepted':

            # Process approved skills
            # Update each user skill
            for uSkill in applicant.user.user_skill.all():
                skill_status = request.POST.get(f'skill_status_{uSkill.id}')
                skill_level = request.POST.get(f'skill_level_{uSkill.id}')
                skill_badge = request.POST.get(f'skill_badge_{uSkill.id}') == 'true'

                if skill_status in dict(SKILL_STATUS_CHOICES).keys():
                    uSkill.status = skill_status

                if skill_level:
                    level = Level.objects.get(name=skill_level)
                    uSkill.level = level

                uSkill.is_certified = skill_badge

                # If approving, set verified info
                if skill_status == 'approved':
                    uSkill.verified_by = request.user
                    uSkill.verified_at = timezone.now()

                uSkill.save()

            for edu in applicant.user.educations.all():
                edu_badge = request.POST.get(f'edu_badge_{edu.id}') == 'true'
                edu.is_certified = edu_badge
                edu.verified_by = request.user
                edu.verified_at = timezone.now()
                edu.save()

            for cert in applicant.user.certificates.all():
                cert_badge = request.POST.get(f'cert_badge_{cert.id}') == 'true'
                cert.is_certified = cert_badge
                cert.verified_by = request.user
                cert.verified_at = timezone.now()
                cert.save()

            # Save interviewer comments
            # set acceptance comment
            reviewer_comment = request.POST.get('reviewer_comment', '')
            applicant.reviewer_comment = reviewer_comment

            uSkills = UserSkill.objects.filter(user=applicant.user)

            # Update applicant status based on skill statuses
            if any(skill.status in ['pending', 'need_interview'] for skill in uSkills):
                applicant.status = 'decision'
            elif all(skill.status in ['rejected'] for skill in uSkills):
                applicant.status = 'rejected'
                send_rejection_email(applicant, reviewer_comment)  # check later !!!!!!!!!!!!!i
                applicant.user.profile.is_active = False
                applicant.user.profile.save()
            else:
                applicant.status = status  # here is 'accepted'

            if any(skill.status in ['approved'] for skill in uSkills):
                user_profile = applicant.user.profile
                approved_uSkills = uSkills.filter(status__exact='approved', is_notified=False)

                if not user_profile.is_active:
                    send_acceptance_email(request, applicant, approved_uSkills, reviewer_comment)
                    for uSkill in approved_uSkills:
                        uSkill.is_notified = True
                        uSkill.save()

                    user_profile.is_active = True
                    user_profile.save()

                else:
                    send_update_skills_email(request, applicant, approved_uSkills)
                    for uSkill in approved_uSkills:
                        uSkill.is_notified = True
                        uSkill.save()

        applicant.save()

        return JsonResponse({
            'success': True,
            'message': 'Applicant status updated successfully'
        })

    except ProviderApplication.DoesNotExist:
        return JsonResponse({
            'success': False,
            'message': 'Applicant not found'
        }, status=404)

    except Exception as e:
        return JsonResponse({
            'success': False,
            'message': str(e)
        }, status=500)


# def update_provider_request_status_2(request, provider_id):
#     """Handle provider application status updates via AJAX"""
#     # Enhanced header check (works with all Django versions)
#     is_ajax = request.headers.get('X-Requested-With') == 'XMLHttpRequest' or request.META.get(
#         'HTTP_X_REQUESTED_WITH') == 'XMLHttpRequest'
#
#     if not is_ajax or not request.method == 'POST':
#         return JsonResponse(
#             {'error': 'Invalid request', 'detail': 'Only AJAX POST requests allowed'},
#             status=400
#         )
#
#     try:
#         # 1. Validate and get applicant
#         applicant = ProviderApplication.objects.select_related('user', 'user__profile').get(pk=provider_id)
#         status = request.POST.get('status')
#
#         if status not in dict(ProviderApplication.STATUS_CHOICES):
#             return JsonResponse(
#                 {'error': 'Invalid status', 'valid_statuses': list(dict(ProviderApplication.STATUS_CHOICES).keys())},
#                 status=400
#             )
#
#         # 2. Process common fields
#         applicant.status = status
#         applicant.verified_by = request.user if request.user.is_authenticated else None
#         applicant.verified_at = timezone.now()
#
#         # 3. Status-specific processing
#         if status == 'invited':
#             applicant.invitation_token = get_random_string(64)
#             applicant.token_expiry = timezone.now() + timedelta(days=7)
#             send_invitation_email(applicant, request)
#
#         elif status == 'rejected':
#             applicant.reviewer_comment = request.POST.get('reviewer_comment', '')
#             applicant.user.profile.is_active = False
#             send_rejection_email(applicant)
#
#         elif status == 'accepted':
#             if not process_skills(applicant, request.POST):
#                 return JsonResponse(
#                     {'error': 'Invalid skills data', 'detail': 'Skills and levels mismatch'},
#                     status=400
#                 )
#             applicant.user.profile.is_active = True
#             applicant.user.profile.save()
#
#             # 4. Final save and response
#             applicant.save()
#             return JsonResponse({
#                 'success': True,
#                 'new_status': applicant.get_status_display(),
#                 'status_class': status,
#             })
#
#     except ProviderApplication.DoesNotExist:
#         return JsonResponse({'error': 'Application not found'}, status=404)
#     except Exception as e:
#         # logger.error(f"Error updating provider status: {str(e)}", exc_info=True)
#         return JsonResponse({'error': 'Server error'}, status=500)


# Helper functions
def process_skills(applicant, post_data):
    """Process and validate skills data"""
    approved_skills = post_data.getlist('approved_skills')
    skill_levels = post_data.getlist('skill_levels')
    give_badge = post_data.get('give_badge') == 'true'

    if len(approved_skills) != len(skill_levels):
        return False

    # Atomic transaction for skills update
    with transaction.atomic():
        UserSkill.objects.filter(user=applicant.user).delete()

        for skill_id, level in zip(approved_skills, skill_levels):
            if skill_id and level:
                UserSkill.objects.create(
                    user=applicant.user,
                    skill_id=skill_id,
                    level_id=level,
                    is_certified=give_badge,
                    status='approved',
                    verified_by=applicant.verified_by,
                    verified_at=applicant.verified_at
                )
    return True


def send_invitation_email(applicant, registration_url):
    """Send invitation email with registration link"""
    context = {
        'full_name': f"{applicant.first_name} {applicant.last_name}",
        'registration_url': registration_url,
        'site_name': settings.SITE_NAME,
        'support_email': settings.EMAIL_SUPPORT,
    }
    send_dual_email(
        subject=f"🎉 Welcome {context['full_name']}, Your Primitive Application Has Been Accepted",
        template_name='emails/interview/primitive_invitation',
        context=context,
        to_email=[applicant.email]
    )


def send_rejection_email(applicant, reviewer_comment):
    """Send rejection email with comments"""
    context = {
        'full_name': f"{applicant.first_name} {applicant.last_name}",
        'site_name': settings.SITE_NAME,
        'reviewer_comment': reviewer_comment,
    }
    send_dual_email(
        subject=f"Interview Decision from {settings.SITE_NAME}",
        template_name='emails/interview/decision/final_reject',
        context=context,
        to_email=[applicant.email]
    )


def send_acceptance_email(request, applicant, approved_uSkills, reviewer_comment):
    """Send acceptance email with comments"""
    # Build the registration URL
    dashboard_uri = request.build_absolute_uri(reverse('tutor:dt_home'))
    context = {
        'full_name': f"{applicant.first_name} {applicant.last_name}",
        'site_name': settings.SITE_NAME,
        'reviewer_comment': reviewer_comment,
        'dashboard_uri': dashboard_uri,
        'approved_uSkills': approved_uSkills,
    }
    send_dual_email(
        subject=f"✅ Congratulations, {applicant.first_name} {applicant.last_name}!, Your Tutor Application Has Been Accepted",
        template_name='emails/interview/decision/final_accept',
        context=context,
        to_email=[applicant.email]
    )


def send_update_skills_email(request, applicant, approved_uSkills):
    """Send update skills email """
    # Build the registration URL
    dashboard_uri = request.build_absolute_uri(reverse('tutor:dt_home'))
    context = {
        'full_name': f"{applicant.first_name} {applicant.last_name}",
        'site_name': settings.SITE_NAME,
        'reviewer_comment': applicant.reviewer_comment,
        'dashboard_uri': dashboard_uri,
        'approved_uSkills': approved_uSkills,
    }
    send_dual_email(
        subject=f"✅ Congratulations, {applicant.first_name} {applicant.last_name}!, Your New Skill(s) Approved",
        template_name='emails/interview/decision/update_skills',
        context=context,
        to_email=[applicant.email]
    )


def set_video_call_link(request, session_id):
    if not request.headers.get('x-requested-with') == 'XMLHttpRequest' or not request.method == 'POST':
        return JsonResponse({'error': 'Invalid request'}, status=400)

    try:
        session = Session.objects.get(pk=session_id)
        session.video_call_link = request.POST.get('session_link')
        session.is_sent_link = True

        session.save()
        return JsonResponse({'success': 'your video call link saved successfully', }, status=200)

    except Session.DoesNotExist:
        return JsonResponse({'error': 'Session not found'}, status=404)

    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


def tutor_registration(request):
    token = request.GET.get('token')
    if not token:
        return redirect('app_pages:home')

    application = get_object_or_404(
        ProviderApplication,
        invitation_token=token,
        status='invited',
        token_expiry__gte=timezone.now()
    )

    if request.method == 'POST':
        # Handle registration form
        return redirect('accounts:sign_up_tutor')

    # Show registration form
    return render(request, 'app_accounts/sign_up_tutor.html', {'application': application})


class DAEarning(LoginRequiredMixin, RoleRequiredMixin, ListView):
    allowed_roles = ['admin']
    template_name = 'app_admin/dashboard/da_earning.html'
    # model = Bill


class DAEdit(LoginRequiredMixin, RoleRequiredMixin, View):
    allowed_roles = ['admin']
    template_name = 'app_admin/dashboard/da_edit.html'
    success_url = reverse_lazy('my_admin:da_home')

    def get(self, request, *args, **kwargs):
        user = request.user
        user_profile = UserProfile.objects.get(user=user)
        form = CombinedProfileForm(
            user_instance=user,
            user_profile_instance=user_profile,
        )
        context = {'form': form}
        return render(request, self.template_name, context)

    def post(self, request, *args, **kwargs):
        user = request.user
        user_profile = UserProfile.objects.get(user=user)
        form = CombinedProfileForm(
            request.POST, request.FILES,
            user_instance=user,
            user_profile_instance=user_profile,
        )
        if form.is_valid():
            form.save(user)
            messages.success(request, 'Your changes saved successfully.')
            return redirect(self.success_url)
        else:
            form = CombinedProfileForm(user_instance=user, user_profile_instance=user_profile)
        return render(request, self.template_name, {'form': form})
