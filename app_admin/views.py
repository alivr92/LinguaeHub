from django.shortcuts import render, redirect
from django.views.generic import View, TemplateView, ListView, DetailView, FormView
from django.contrib.auth.mixins import LoginRequiredMixin
from app_accounts.models import UserProfile
from ap2_meeting.models import Review
from ap2_tutor.models import Tutor
from ap2_student.models import Student
from app_pages.models import ContactUs
from payments.models import Bill
from app_content_filler.models import (CFChar, CFText, CFURL, CFBoolean, CFImage, CFFloat, CFDecimal, CFFile,
                                       CFDateTime, CFInteger, CFEmail)
from .forms import CombinedProfileForm
from django.urls import reverse_lazy
from django.contrib import messages
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import get_object_or_404


# DASHBOARD ADMIN (SUPERUSER)   --------------------------------------------------------------------------------
class DAHome(LoginRequiredMixin, TemplateView):
    template_name = 'app_admin/dashboard/da_home.html'

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


class DASettings(LoginRequiredMixin, TemplateView):
    template_name = 'app_admin/dashboard/da_setting.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context


class DAReview(LoginRequiredMixin, ListView):
    template_name = 'app_admin/dashboard/da_review.html'
    model = Review
    paginate_by = 4

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # context['range'] = range(1, 6)  # we use this for rating stars
        return context


@csrf_exempt
def toggle_publish_status(request):
    if request.method == "POST":
        review_id = request.POST.get("id")
        is_published = request.POST.get("is_published") == "true"
        review = get_object_or_404(Review, id=review_id)
        review.is_published = is_published
        review.save()
        return JsonResponse({"success": True, "is_published": review.is_published})
    return JsonResponse({"success": False, "error": "Invalid request"})


class DAContactUs(LoginRequiredMixin, ListView):
    template_name = 'app_admin/dashboard/da_contact_us.html'
    model = ContactUs
    paginate_by = 5
    ordering = '-create_date'


class DACourseList(LoginRequiredMixin, ListView):
    template_name = 'app_admin/dashboard/da_course_list.html'
    model = Tutor  # Must change to Course


class DACourseCategory(LoginRequiredMixin, ListView):
    template_name = 'app_admin/dashboard/da_course_category.html'
    model = Tutor  # Must change to Course


class DACourseDetail(LoginRequiredMixin, DetailView):
    template_name = 'app_admin/dashboard/da_course_list.html'
    model = Tutor  # Must change to Course


class DAStudentList(LoginRequiredMixin, ListView):
    template_name = 'app_admin/dashboard/da_student_list.html'
    model = Student
    paginate_by = 6
    ordering = ['-profile__create_date']


class DATutorList(LoginRequiredMixin, ListView):
    template_name = 'app_admin/dashboard/da_tutor_list.html'
    model = Tutor
    paginate_by = 9
    ordering = ['-create_date']

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['range'] = range(1, 6)  # we use this for rating stars
        return context


class DATutorDetail(LoginRequiredMixin, DetailView):
    template_name = 'app_admin/dashboard/da_tutor_detail.html'
    model = Tutor

    def get_context_data(self, **kwargs):
        # Get the tutor ID from self.object or self.kwargs
        tutorId = self.object.pk  # or self.kwargs['pk']
        context = super().get_context_data(**kwargs)
        context['range'] = range(1, 6)  # we use this for rating stars
        # context['reviews'] = Review.objects.filter(tutor_id=tutorId)
        return context


class DATutorRequest(LoginRequiredMixin, ListView):
    template_name = 'app_admin/dashboard/da_tutor_request.html'
    model = Tutor


class DAEarning(LoginRequiredMixin, ListView):
    template_name = 'app_admin/dashboard/da_earning.html'
    model = Bill


class DAEdit(LoginRequiredMixin, View):
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
