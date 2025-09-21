from django.shortcuts import render, redirect
from django.views.generic import View, TemplateView, DetailView, ListView
from django.contrib.auth.mixins import LoginRequiredMixin
from utils.mixins import EmailVerificationRequiredMixin, RoleRequiredMixin
from app_accounts.models import UserProfile
from ap2_meeting.models import Review
from ap2_tutor.models import Tutor
from ap2_student.models import Student
from .forms import CombinedProfileForm
from django.urls import reverse_lazy
from django.contrib import messages


# DASHBOARD STAFF   ---------------------------------------------------------------------------------------------
class DSTFHome(LoginRequiredMixin, EmailVerificationRequiredMixin, RoleRequiredMixin, TemplateView):
    allowed_roles = ['staff']
    template_name = 'app_staff/dashboard/dstf_home.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context


class DSTFReview(LoginRequiredMixin, EmailVerificationRequiredMixin, RoleRequiredMixin, ListView):
    allowed_roles = ['staff']
    template_name = 'app_staff/dashboard/dstf_review.html'
    model = Review


class DSTFCourseList(LoginRequiredMixin, EmailVerificationRequiredMixin, RoleRequiredMixin, ListView):
    allowed_roles = ['staff']
    template_name = 'app_staff/dashboard/dstf_course_list.html'
    model = Tutor  # Must change to Course


class DSTFCourseCategory(LoginRequiredMixin, EmailVerificationRequiredMixin, RoleRequiredMixin, ListView):
    allowed_roles = ['staff']
    template_name = 'app_staff/dashboard/dstf_course_category.html'
    model = Tutor  # Must change to Course


class DSTFCourseDetail(LoginRequiredMixin, EmailVerificationRequiredMixin, RoleRequiredMixin, DetailView):
    allowed_roles = ['staff']
    template_name = 'app_staff/dashboard/dstf_course_list.html'
    model = Tutor  # Must change to Course


class DSTFStudentList(LoginRequiredMixin, EmailVerificationRequiredMixin, RoleRequiredMixin, ListView):
    allowed_roles = ['staff']
    template_name = 'app_staff/dashboard/dstf_student_list.html'
    model = Student


class DSTFTutorList(LoginRequiredMixin, EmailVerificationRequiredMixin, RoleRequiredMixin, ListView):
    allowed_roles = ['staff']
    template_name = 'app_staff/dashboard/dstf_tutor_list.html'
    model = Tutor


class DSTFTutorDetail(LoginRequiredMixin, EmailVerificationRequiredMixin, RoleRequiredMixin, DetailView):
    allowed_roles = ['staff']
    template_name = 'app_staff/dashboard/dstf__tutor_detail.html'
    model = Tutor

    def get_context_data(self, **kwargs):
        # Get the tutor ID from self.object or self.kwargs
        tutorId = self.object.pk  # or self.kwargs['pk']
        context = super().get_context_data(**kwargs)
        context['range'] = range(1, 6)  # we use this for rating stars
        # context['reviews'] = Review.objects.filter(tutor_id=tutorId)
        return context


class DSTFTutorRequest(LoginRequiredMixin, EmailVerificationRequiredMixin, RoleRequiredMixin, ListView):
    allowed_roles = ['staff']
    template_name = 'app_staff/dashboard/dstf_tutor_request.html'
    model = Tutor


class DSTFEdit(LoginRequiredMixin, EmailVerificationRequiredMixin, RoleRequiredMixin, View):
    allowed_roles = ['staff']
    template_name = 'app_staff/dashboard/dstf_edit.html'
    success_url = reverse_lazy('staff:dstf_home')

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
