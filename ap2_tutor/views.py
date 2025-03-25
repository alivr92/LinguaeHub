from django.shortcuts import render, redirect, get_object_or_404
from django.views.generic import View, TemplateView
from django.contrib.auth.mixins import LoginRequiredMixin
from ap2_tutor.models import Tutor, SkillLevel, Skill
from django.views.generic import ListView, DetailView, DeleteView
from ap2_meeting.models import Review, Session
from app_accounts.models import UserProfile
from django.db.models import Q
from .forms import CombinedProfileForm, SocialURLForm
from django.urls import reverse_lazy
from django.contrib import messages
from decimal import Decimal
from django.utils.timezone import now

s_gender = UserProfile.objects.values_list('gender', flat=True).distinct()
s_country = UserProfile.objects.values_list('country', flat=True).distinct()
s_lang_native = UserProfile.objects.values_list('lang_native', flat=True).distinct()
s_lang_speak = UserProfile.objects.values_list('lang_speak', flat=True).distinct()
s_rating = UserProfile.objects.values_list('rating', flat=True).distinct()
s_reviews_count = UserProfile.objects.values_list('reviews_count', flat=True).distinct()

s_skills = Skill.objects.distinct()
s_language_levels = SkillLevel.objects.distinct()
s_cost_trial = Tutor.objects.values_list('cost_trial', flat=True).distinct()
s_cost_hourly = Tutor.objects.values_list('cost_hourly', flat=True).distinct()
s_session_count = Tutor.objects.values_list('session_count', flat=True).distinct()
s_student_count = Tutor.objects.values_list('student_count', flat=True).distinct()


class TutorListView(ListView):
    model = Tutor
    template_name = 'ap2_tutor/tutor_list.html'
    # context_object_name = 'tutors'  # Name of the variable in the template
    ordering = ['-profile__create_date']
    paginate_by = 10  # Number of items per page

    def get_queryset(self):
        queryset = super().get_queryset()

        # Apply filters based on request parameters
        gender = self.request.GET.get('gender')
        if gender:
            queryset = queryset.filter(Q(profile__gender__iexact=gender))

        keySearch = self.request.GET.get('keySearch')
        if keySearch:
            queryset = queryset.filter(
                Q(profile__user__first_name__icontains=keySearch) |
                Q(profile__user__last_name__icontains=keySearch)
            )
        sRate = self.request.GET.get('sRate')
        if sRate:
            queryset = queryset.filter(profile__rating__gte=sRate).order_by('-profile__rating')

        skills = self.request.GET.get('skills')
        if skills:
            # Assuming skills is a comma-separated list of skill names
            skills_list = skills.split(',')
            queryset = queryset.filter(skills__name__in=skills_list).distinct()

        sSkillLevel = self.request.GET.get('sSkillLevel')
        if sSkillLevel:
            sSkillLevel = sSkillLevel.split(',')
            queryset = queryset.filter(skill_level__name__in=sSkillLevel).distinct()

        # Return the filtered queryset
        return queryset

    def get_context_data(self, **kwargs):
        # Add additional context data (use for generating select options)
        context = super().get_context_data(**kwargs)
        context['s_gender'] = s_gender
        context['s_country'] = s_country
        context['s_lang_native'] = s_lang_native
        context['s_lang_speak'] = s_lang_speak
        context['s_rating'] = s_rating
        context['s_reviews_count'] = s_reviews_count

        context['s_skills'] = s_skills
        context['s_language_levels'] = s_language_levels
        context['s_cost_trial'] = s_cost_trial
        context['s_cost_hourly'] = s_cost_hourly
        context['s_session_count'] = s_session_count
        context['s_student_count'] = s_student_count

        context['search_gender'] = self.request.GET.get('gender', '')
        return context


class TutorDetailView(DetailView):
    model = Tutor
    template_name = 'ap2_tutor/tutor_detail.html'
    context_object_name = 'tutor_single'

    def get_context_data(self, **kwargs):
        # Get the tutor ID from self.object or self.kwargs
        tutor = self.object  # or self.kwargs['pk']
        context = super().get_context_data(**kwargs)
        context['reviews'] = Review.objects.filter(tutor_id=tutor.id, is_published=True).order_by('-create_date')
        context['discounted_price'] = calculate_discounted_price(tutor.cost_hourly, tutor.discount)

        if tutor.discount != 0:  # Check if discount is available
            context['is_deadline_set'] = bool(tutor.discount_deadline)
            if not tutor.discount_deadline:  # No deadline set
                context['discount_valid'] = True
                context['remaining_time'] = None
            elif now() <= tutor.discount_deadline:  # Deadline is valid
                context['discount_valid'] = True
                remaining_time = tutor.discount_deadline - now()
                days_left = remaining_time.days
                hours_left = remaining_time.seconds // 3600
                context['remaining_time'] = f"{days_left} days, {hours_left} hours"
            else:  # Deadline has expired
                context['discount_valid'] = False
                context['remaining_time'] = None
        else:
            context['discount_valid'] = False
            context['remaining_time'] = None

        skill_ids = self.object.skills.values_list('id', flat=True)
        if skill_ids:
            context['related_tutors'] = Tutor.objects.filter(skills__in=skill_ids).exclude(id=tutor.id).distinct()
        else:
            context['related_tutors'] = Tutor.objects.none()  # No related tutors

        return context


def calculate_discounted_price(original_price, discount):
    return original_price * (1 - Decimal(discount) / 100)


class TutorReserveView(DetailView):
    model = Tutor
    template_name = 'ap2_tutor/tutor_reserve.html'
    context_object_name = 'tutor_single'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['range'] = range(1, 6)  # we use this for rating stars
        # context['minutes'] = ['00', '30']
        return context


# DASHBOARD TUTOR   ---------------------------------------------------------------------------------------------
class DTHome(LoginRequiredMixin, TemplateView):
    template_name = 'ap2_tutor/dashboard/dt_home.html'
    # model = Session
    # paginate_by = 6

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['tutor'] = self.request.user.profile.tutor_profile
        # context['session_list'] = Session.objects.all()

        return context


class DTEditView(LoginRequiredMixin, TemplateView):
    template_name = 'ap2_tutor/dashboard/dt_edit.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context


class DTManageCourse(LoginRequiredMixin, ListView):
    template_name = 'ap2_tutor/dashboard/dt_manage_course.html'
    model = Tutor  # Must change to Course !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # ordering = ['-profile__create_date']
    paginate_by = 6

    # def get_queryset(self):
    #     # Assuming the logged-in user is a Tutor and you have a relationship between Tutor and UserProfile
    #     return Session.objects.filter(tutor__profile__user=self.request.user).order_by('-start_session_utc')


class DTQuiz(LoginRequiredMixin, TemplateView):
    template_name = 'ap2_tutor/dashboard/dt_quiz.html'


class DTEarning(LoginRequiredMixin, ListView):
    template_name = 'ap2_tutor/dashboard/dt_earning.html'
    model = Tutor  # Must change to Payment !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    paginate_by = 6


class DTOrder(LoginRequiredMixin, ListView):
    template_name = 'ap2_tutor/dashboard/dt_order.html'
    model = Tutor  # Must change to Order Payments !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    paginate_by = 6


class DTPayout(LoginRequiredMixin, ListView):
    template_name = 'ap2_tutor/dashboard/dt_payout.html'
    model = Tutor  # Must change to Order Payments !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    paginate_by = 6


class DTStudentList(LoginRequiredMixin, ListView):
    model = Session
    template_name = 'ap2_tutor/dashboard/dt_student_list.html'
    # ordering = ['-profile__create_date']
    paginate_by = 6

    def get_queryset(self):
        # Assuming the logged-in user is a Tutor and you have a relationship between Tutor and UserProfile
        return Session.objects.filter(tutor__profile__user=self.request.user).order_by('-start_session_utc')


class DTReviews(LoginRequiredMixin, ListView):
    model = Review
    template_name = 'ap2_tutor/dashboard/dt_review.html'
    # ordering = ['-last_modified']
    paginate_by = 6  # Number of items per page

    def get_queryset(self):
        # Assuming the logged-in user is a Tutor and you have a relationship between Tutor and UserProfile
        return Review.objects.filter(tutor__profile__user=self.request.user).order_by('-create_date')


class DTEditProfile(LoginRequiredMixin, View):
    template_name = 'ap2_tutor/dashboard/dt_edit.html'
    success_url = reverse_lazy('tutor:dt_home')

    def get(self, request, *args, **kwargs):
        user = request.user
        user_profile = UserProfile.objects.get(user=user)
        tutor = Tutor.objects.get(profile=user_profile)
        form = CombinedProfileForm(
            user_instance=user,
            user_profile_instance=user_profile,
            tutor_instance=tutor
        )
        context = {'form': form, 'tutor': tutor}
        return render(request, self.template_name, context)

    def post(self, request, *args, **kwargs):
        user = request.user
        user_profile = UserProfile.objects.get(user=user)
        tutor = Tutor.objects.get(profile=user_profile)
        form = CombinedProfileForm(
            request.POST, request.FILES,
            user_instance=user,
            user_profile_instance=user_profile,
            tutor_instance=tutor
        )
        if form.is_valid():
            form.save(user)
            messages.success(request, 'Your changes saved successfully.')
            return redirect(self.success_url)
        else:
            form = CombinedProfileForm(user_instance=user, user_profile_instance=user_profile, tutor_instance=tutor)
        return render(request, self.template_name, {'form': form})


class DTEditProfileView_notWorking(LoginRequiredMixin, View):
    template_name = 'app_accounts/dashboard/tutor/dt_edit.html'
    success_url = reverse_lazy('tutor:dt_home')

    def get(self, request, *args, **kwargs):
        user = request.user
        user_profile = UserProfile.objects.get(user=user)
        tutor = Tutor.objects.get(profile=user_profile)

        # Initialize both forms
        form_profile = CombinedProfileForm(
            user_instance=user,
            user_profile_instance=user_profile,
            tutor_instance=tutor
        )
        form_social_url = SocialURLForm(user_profile_instance=user_profile)

        context = {
            'form_profile': form_profile,
            'form_social_url': form_social_url,
            'tutor': tutor,
        }
        return render(request, self.template_name, context)

    def post(self, request, *args, **kwargs):
        user = request.user
        user_profile = UserProfile.objects.get(user=user)
        tutor = Tutor.objects.get(profile=user_profile)

        # Determine which form was submitted
        if 'profile_form' in request.POST:
            # Handle CombinedProfileForm submission
            form_profile = CombinedProfileForm(
                request.POST, request.FILES,
                user_instance=user,
                user_profile_instance=user_profile,
                tutor_instance=tutor
            )
            form_social_url = SocialURLForm(user_profile_instance=user_profile)  # Initialize empty social URL form

            if form_profile.is_valid():
                form_profile.save(user)
                messages.success(request, 'Your profile changes were saved successfully.')
                return redirect(self.success_url)
            else:
                messages.error(request, 'Please correct the errors in the profile form.')

        elif 'social_url_form' in request.POST:
            # Handle SocialURLForm submission
            form_social_url = SocialURLForm(
                request.POST,
                user_profile_instance=user_profile
            )
            form_profile = CombinedProfileForm(  # Initialize empty profile form
                user_instance=user,
                user_profile_instance=user_profile,
                tutor_instance=tutor
            )

            if form_social_url.is_valid():
                form_social_url.save(user)
                messages.success(request, 'Your social URLs were saved successfully.')
                return redirect(self.success_url)
            else:
                messages.error(request, 'Please correct the errors in the social URLs form.')

        else:
            # If no form was submitted, initialize empty forms
            form_profile = CombinedProfileForm(
                user_instance=user,
                user_profile_instance=user_profile,
                tutor_instance=tutor
            )
            form_social_url = SocialURLForm(user_profile_instance=user_profile)

        # Render the template with the forms
        context = {
            'form_profile': form_profile,
            'form_social_url': form_social_url,
            'tutor': tutor,
        }
        return render(request, self.template_name, context)


# @login_required
# def edit_profile(request, pk):
#     user = request.user
#     user_profile = get_object_or_404(UserProfile, user=user)
#     tutor = get_object_or_404(Tutor, profile=user_profile)
#
#     if request.method == 'POST':
#         form = CombinedEditProfileForm(request.POST, request.FILES, user_profile_instance=user_profile, tutor_instance=tutor)
#         if form.is_valid():
#             form.save(user)  # Pass the user argument here
#             return redirect('accounts:dt_home')  # Redirect to the success URL
#     else:
#         form = CombinedEditProfileForm(user_profile_instance=user_profile, tutor_instance=tutor)
#
#     return render(request, 'app_accounts/dashboard/tutor/dt_edit.html', {'form': form})


class DTSetting(LoginRequiredMixin, TemplateView):
    template_name = 'ap2_tutor/dashboard/dt_setting.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # context['tutor'] = self.get_object()  # Get the current tutor object
        return context


class DTDeleteAccount(LoginRequiredMixin, DeleteView):
    template_name = 'ap2_tutor/dashboard/dt_delete_account.html'
    model = Tutor  # Must CHECK !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
