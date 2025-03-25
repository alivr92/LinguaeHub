from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse
from django.db.models import Exists, OuterRef
from django.urls import reverse_lazy
from django.contrib import messages
from django.views.generic import View, TemplateView, ListView, DeleteView
from django.contrib.auth.mixins import LoginRequiredMixin
from ap2_tutor.models import Tutor
from ap2_student.models import Student, WishList
from app_accounts.models import UserProfile
from ap2_meeting.models import Session, Review
from .forms import CombinedProfileForm
from django.http import JsonResponse
from django.utils import timezone
from datetime import timedelta


# DASHBOARD STUDENT ---------------------------------------------------------------------------------------------
class DSHome(LoginRequiredMixin, TemplateView):
    template_name = 'ap2_student/dashboard/ds_home.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context


class DSSubscription(LoginRequiredMixin, TemplateView):
    template_name = 'ap2_student/dashboard/ds_subscription.html'


class DSClassList(LoginRequiredMixin, ListView):
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


class DSCourseResume(LoginRequiredMixin, TemplateView):
    template_name = 'ap2_student/dashboard/ds_course_resume.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context


class DSQuiz(LoginRequiredMixin, TemplateView):
    template_name = 'ap2_student/dashboard/ds_quiz.html'


class DSPaymentInfo(LoginRequiredMixin, ListView):
    template_name = 'ap2_student/dashboard/ds_payment_info.html'
    model = Tutor  # Must change to Order Payments !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    paginate_by = 5


class DSBookmark(LoginRequiredMixin, ListView):
    template_name = 'ap2_student/dashboard/ds_bookmark.html'
    model = Tutor  # Must change to Order Payments !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    paginate_by = 5


def toggle_wishlist(request):
    if request.method == 'POST':
        student = request.user.student  # Assuming `request.user` is linked to the Student model
        tutor_id = request.POST.get('tutor_id')
        tutor = get_object_or_404(Tutor, id=tutor_id)

        wishlist_entry, created = Wishlist.objects.get_or_create(student=student, tutor=tutor)

        if not created:  # If it already exists, remove it
            wishlist_entry.delete()
            return JsonResponse({'status': 'removed'})
        return JsonResponse({'status': 'added'})


# Tutor must change to student! ???????????????????????????????????????????
class DSEdit(LoginRequiredMixin, View):
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


class DSSetting(LoginRequiredMixin, TemplateView):
    template_name = 'ap2_student/dashboard/ds_setting.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # context['tutor'] = self.get_object()  # Get the current tutor object
        return context


class DSDeleteAccount(LoginRequiredMixin, DeleteView):
    template_name = 'ap2_student/dashboard/ds_delete_account.html'
    model = Student  # Must CHECK !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
