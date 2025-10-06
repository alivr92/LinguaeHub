import traceback
from django.shortcuts import render, redirect, get_object_or_404
from django.http import JsonResponse, HttpResponseForbidden, HttpResponseRedirect
import json
from django.views.decorators.http import require_POST
from django.contrib.auth.decorators import login_required
from django.views.decorators.csrf import csrf_exempt
from django.views.generic import View, TemplateView, ListView, DetailView, DeleteView, FormView, RedirectView
from django.urls import reverse_lazy
from django.utils.timezone import now
from django.utils import timezone
from datetime import timedelta, datetime
from django.conf import settings
from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from utils.mixins import RoleRequiredMixin, EmailVerificationRequiredMixin, ActivationRequiredMixin, VIPRequiredMixin
from django.contrib.auth.models import User
from django.core.mail import send_mail, EmailMessage, EmailMultiAlternatives
from django.db.models import Count, Q, Min, Max, Avg
from decimal import Decimal

# -----------------------custom utils ---------------------------
from utils.email import send_dual_email, notification_email_to_admin, notification_formatted_email
from utils.converters import utc_to_local
from utils.decorators import ownership_required

from ap2_meeting.models import Review, Session, AvailableRule, AppointmentSetting
from ap2_tutor.models import ProviderApplication, Tutor, TeachingCategory, TeachingCertificate, TEACHING_CERTIFICATES
from app_accounts.models import UserProfile, Level, Skill, UserSkill, UserEducation, DegreeLevel, DEGREE_LEVELS
from utils.pages import error_page
from .forms import (ProviderApplicationForm, CombinedProfileForm, ProfileBasicForm, CombinedSkillForm,
                    EducationalExtraForm, COUNTRY_CODE_CHOICES, PricingForm)
from app_accounts.forms import UserEducationForm, AgreementForm, LocationForm
from ap2_meeting.forms import AppointmentSettingForm

from django.core.files.storage import default_storage
from django.core.exceptions import ObjectDoesNotExist
from django.db import transaction

s_gender = UserProfile.objects.values_list('gender', flat=True).distinct()
s_country = UserProfile.objects.values_list('country', flat=True).distinct()
s_lang_native = UserProfile.objects.values_list('lang_native', flat=True).distinct()
s_lang_speak = UserProfile.objects.values_list('lang_speak', flat=True).distinct()
s_rating = UserProfile.objects.values_list('rating', flat=True).distinct()
s_reviews_count = UserProfile.objects.values_list('reviews_count', flat=True).distinct()

s_skills = Skill.objects.distinct()
s_language_levels = Level.objects.distinct()
s_cost_trial = Tutor.objects.values_list('cost_trial', flat=True).distinct()
s_cost_hourly = Tutor.objects.values_list('cost_hourly', flat=True).distinct()
s_session_count = Tutor.objects.values_list('session_count', flat=True).distinct()
s_student_count = Tutor.objects.values_list('student_count', flat=True).distinct()


class BecomeTutor(FormView):
    template_name = 'ap2_tutor/become-tutor.html'
    form_class = ProviderApplicationForm
    success_url = reverse_lazy('provider:become_tutor')

    def form_valid(self, form):
        first_name = self.request.POST.get('first_name')
        last_name = self.request.POST.get('last_name')
        full_name = f"{first_name} {last_name}"
        email = self.request.POST.get('email')
        phone = self.request.POST.get('phone')
        bio = self.request.POST.get('bio')
        photo = self.request.FILES.get('photo')
        resume_file = self.request.FILES.get('resume')

        # admin_email = User.objects.get(is_superuser=True).email
        # send_formatted_email(full_name, email, phone, bio, photo, resume_file, admin_email)

        # Send acceptance email with registration link
        subject = f"🙌 Dear {full_name}, Thanks for Applying! Our Team Will Reach Out Soon."
        to_email = [email]
        template_name = 'emails/interview/tutor_request_pending'
        context = {
            'full_name': full_name,
            'email': email,
            'phone': phone,
            'bio': bio,
            'photo': photo,
            'resume_file': resume_file,
            'site_name': settings.SITE_NAME,
        }
        # this email sends to the applicant to know they should follow up.
        send_dual_email(subject, template_name, context, to_email)

        notify_subject = f"New Tutor Request from {full_name}"
        notification_email_to_admin(notify_subject, 'emails/admin/notify_admin', context)

        # notify_subject2 = f"{full_name} has sent his/her application."
        # notification_formatted_email(notify_subject2, 'emails/notification/notif_with_attachment', context, photo,
        #                              resume_file)
        form.save()
        messages.success(self.request, "We received your application, please check your email (inbox, spam) "
                                       "in next 24 hours for invitation link")
        return super().form_valid(form)

    def form_invalid(self, form):
        messages.error(self.request, 'There is an error in sending message! please check the form fields')
        return self.render_to_response(self.get_context_data(form=form))


class TutorListView1(ListView):
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
            queryset = UserSkill.objects.filter(skill__name__in=skills_list).distinct()
            # queryset = queryset.filter(skills__name__in=skills_list).distinct()

        sLevel = self.request.GET.get('sLevel')
        if sLevel:
            sLevel = sLevel.split(',')
            queryset = UserSkill.objects.filter(level__name__in=sLevel).distinct()

        # PRICE RANGE FILTER - Add this
        min_price = self.request.GET.get('min_price')
        max_price = self.request.GET.get('max_price')
        if min_price and max_price:
            queryset = Tutor.objects.filter(
                cost_hourly__gte=min_price,
                cost_hourly__lte=max_price
            )

        # Return the filtered queryset
        return queryset

    def get_context_data(self, **kwargs):
        # Add additional context data (use for generating select options)
        context = super().get_context_data(**kwargs)
        context['tutors_accepted'] = Tutor.objects.filter(status='accepted')
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

        # Get min/max prices from database
        price_stats = Tutor.objects.aggregate(
            min_price=Min('cost_hourly'),
            max_price=Max('cost_hourly')
        )

        min_price = price_stats['min_price'] or 0
        max_price = price_stats['max_price'] or 100

        # Handle all filters
        tutors = Tutor.objects.all()

        # Price range filter
        min_price_filter = self.request.GET.get('min_price')
        max_price_filter = self.request.GET.get('max_price')

        if min_price_filter and max_price_filter:
            tutors = tutors.filter(
                cost_hourly__gte=min_price_filter,
                cost_hourly__lte=max_price_filter
            )

        # Other filters
        skills_filter = self.request.GET.get('skills')
        if skills_filter:
            tutors = tutors.filter(teaching_tags__name=skills_filter)

        # skill_level_filter = self.request.GET.get('sSkillLevel')
        # if skill_level_filter:
        #     tutors = tutors.filter(profile__lang_speak__level=skill_level_filter)

        gender_filter = self.request.GET.get('gender')
        if gender_filter:
            tutors = tutors.filter(profile__gender=gender_filter)

        rating_filter = self.request.GET.get('sRate')
        if rating_filter:
            tutors = tutors.filter(profile__rating__gte=rating_filter)

        context['min_price'] = min_price
        context['max_price'] = max_price
        context['tutors'] = tutors

        # ---------------------

        return context


class TutorListView(ListView):
    model = Tutor
    template_name = 'ap2_tutor/tutor_list.html'
    ordering = ['-profile__create_date']
    paginate_by = 10

    def get_queryset(self):
        # Start with only accepted tutors
        queryset = Tutor.objects.filter(status='accepted').select_related('profile').prefetch_related(
            'teaching_tags', 'profile__user__skills'
        )

        # Apply ordering
        queryset = queryset.order_by('-profile__create_date')

        # Apply filters based on request parameters
        gender = self.request.GET.get('gender')
        if gender:
            queryset = queryset.filter(profile__gender__iexact=gender)

        keySearch = self.request.GET.get('keySearch')
        if keySearch:
            queryset = queryset.filter(
                Q(profile__user__first_name__icontains=keySearch) |
                Q(profile__user__last_name__icontains=keySearch)
            )

        sRate = self.request.GET.get('sRate')
        if sRate:
            queryset = queryset.filter(profile__rating__gte=sRate)

        skills = self.request.GET.get('skills')
        if skills:
            queryset = queryset.filter(
                profile__user__skills__skill__name=skills
            )

        sSkillLevel = self.request.GET.get('sSkillLevel')
        if sSkillLevel:
            queryset = queryset.filter(
                profile__user__skills__level__name=sSkillLevel
            )

        min_price = self.request.GET.get('min_price')
        max_price = self.request.GET.get('max_price')
        if min_price and max_price:
            queryset = queryset.filter(
                cost_hourly__gte=min_price,
                cost_hourly__lte=max_price
            )

        return queryset.distinct()

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)

        # Get ALL tutors (unfiltered) for filter options
        all_tutors = Tutor.objects.all()

        # Get min/max prices from ALL tutors
        price_stats = all_tutors.aggregate(
            min_price=Min('cost_hourly'),
            max_price=Max('cost_hourly')
        )

        context.update({
            'min_price': price_stats['min_price'] or 0,
            'max_price': price_stats['max_price'] or 100,
            'tutors_accepted': all_tutors.filter(status='accepted'),
            's_gender': s_gender,
            's_country': s_country,
            's_lang_native': s_lang_native,
            's_lang_speak': s_lang_speak,
            's_rating': s_rating,
            's_reviews_count': s_reviews_count,
            's_skills': s_skills,
            's_language_levels': s_language_levels,
            's_cost_trial': s_cost_trial,
            's_cost_hourly': s_cost_hourly,
            's_session_count': s_session_count,
            's_student_count': s_student_count,
            'search_gender': self.request.GET.get('gender', ''),
            'current_skills': self.request.GET.get('skills', ''),
            'current_skill_level': self.request.GET.get('sSkillLevel', ''),
            'current_rating': self.request.GET.get('sRate', ''),
            'current_min_price': self.request.GET.get('min_price', ''),
            'current_max_price': self.request.GET.get('max_price', ''),
        })

        return context


class ProviderDetailView(DetailView):
    model = Tutor
    template_name = 'ap2_tutor/provider_detail.html'
    context_object_name = 'tutor_single'
    slug_field = 'slug'  # Database field to search
    slug_url_kwarg = 'slug'  # URL parameter name

    # Get object by slug instead of pk
    # we must show the tutors who are completely accepted
    # def get_object(self, queryset=None):
    #     slug = self.kwargs.get('slug')
    #     return get_object_or_404(Tutor, slug=slug, status='accepted')
    def get_queryset(self):
        return Tutor.objects.filter(status='accepted')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        tutor = self.object  # This now gets the tutor from slug lookup

        # Get published reviews for this tutor
        reviews = Review.objects.filter(provider=tutor.profile.user, is_published=True)
        context['reviews'] = reviews.order_by('-create_date')
        context['week_schedule'] = get_week_schedule(user=tutor.profile.user)

        # Calculate rating distribution
        rating_distribution = self._calculate_rating_distribution(reviews)
        context['rating_distribution'] = rating_distribution
        context['total_reviews'] = reviews.count()

        context['discounted_price'] = self._calculate_discounted_price(tutor.cost_hourly, tutor.discount)
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

        context['approved_skills'] = UserSkill.objects.filter(user=tutor.profile.user, status='approved')
        context['approved_educations'] = UserEducation.objects.filter(user=tutor.profile.user, status='approved')
        # Get current tutor's approved skill IDs
        approved_skill_ids = UserSkill.objects.filter(user=tutor.profile.user, status='approved').values_list(
            'skill_id', flat=True)

        if approved_skill_ids:
            limit = 10
            # Get related tutors with most shared approved skills
            context['related_tutors'] = Tutor.objects.filter(profile__user__skills__skill_id__in=approved_skill_ids,
                                                             profile__user__skills__status='approved').exclude(
                id=tutor.id).order_by('-profile__rating').distinct()[:limit]  # Top 10 by shared skills then rating
        else:
            context['related_tutors'] = Tutor.objects.none()  # No related tutors

        # Pass approved skill IDs to template for comparison
        context['approved_skill_ids'] = list(approved_skill_ids)

        return context

    def _calculate_discounted_price(self, original_price, discount):
        return original_price * (1 - Decimal(discount) / 100)

    def _calculate_rating_distribution(self, reviews):
        """Calculate the distribution of ratings (1-5 stars)"""
        # Initialize distribution dictionary
        distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0}

        # Count each rating
        for review in reviews:
            rating = review.rate_provider
            if 1 <= rating <= 5:
                distribution[rating] += 1

        # Calculate percentages
        total_reviews = reviews.count()
        if total_reviews > 0:
            for rating in distribution:
                distribution[rating] = {
                    'count': distribution[rating],
                    'percentage': (distribution[rating] / total_reviews) * 100
                }
        else:
            # If no reviews, set all to 0
            for rating in distribution:
                distribution[rating] = {'count': 0, 'percentage': 0}

        return distribution


class ProviderShortRedirectView(RedirectView):
    permanent = True  # HTTP 301 (good for SEO)

    def get_redirect_url(self, *args, **kwargs):
        public_id = kwargs['public_id']  # 1. Extract public_id from URL parameters
        tutor = get_object_or_404(Tutor, public_id=public_id)  # 2. Find tutor by public_id (or return 404)
        return tutor.get_seo_url()  # 3. Return the destination URL for redirect "/tutor/slug-here/"


class ProviderLegacyRedirectView(RedirectView):
    permanent = True

    def get_redirect_url(self, *args, **kwargs):
        pk = kwargs['pk']  # 1. Extract pk (primary key) from URL
        tutor = get_object_or_404(Tutor, pk=pk)
        return tutor.get_seo_url()  # Returns "/tutor/slug-here/"


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
class DPHome(LoginRequiredMixin, RoleRequiredMixin, EmailVerificationRequiredMixin, ActivationRequiredMixin,
             TemplateView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dp_home.html'

    # model = Session
    # paginate_by = 6

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['tutor'] = self.request.user.profile.tutor_profile
        # context['session_list'] = Session.objects.all()

        return context


class DPManageCourse(LoginRequiredMixin, RoleRequiredMixin, EmailVerificationRequiredMixin, ActivationRequiredMixin,
                     ListView):
    allowed_roles = ['tutor']
    # template_name = 'ap2_tutor/dashboard/dp_manage_course.html'
    template_name = 'app_in_person/provider/inp_provider_appointments.html'
    model = Tutor  # Must change to Course !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # ordering = ['-profile__create_date']
    paginate_by = 6

    # def get_queryset(self):
    #     # Assuming the logged-in user is a Tutor and you have a relationship between Tutor and UserProfile
    #     return Session.objects.filter(tutor__profile__user=self.request.user).order_by('-start_session_utc')


class DPQuiz(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, TemplateView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dp_quiz.html'


class DPEarning(LoginRequiredMixin, RoleRequiredMixin, EmailVerificationRequiredMixin, ActivationRequiredMixin,
                ListView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dp_earning.html'
    model = Tutor  # Must change to Payment !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    paginate_by = 6


class DPPricing(LoginRequiredMixin, RoleRequiredMixin, EmailVerificationRequiredMixin, ActivationRequiredMixin,
                TemplateView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dp_pricing.html'


class DPOrder(LoginRequiredMixin, RoleRequiredMixin, EmailVerificationRequiredMixin, ActivationRequiredMixin, ListView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dp_order.html'
    model = Tutor  # Must change to Order Payments !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    paginate_by = 6


class DPPayout(LoginRequiredMixin, RoleRequiredMixin, EmailVerificationRequiredMixin, ActivationRequiredMixin,
               ListView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dp_payout.html'
    model = Tutor  # Must change to Order Payments !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    paginate_by = 6


class DPStudentList(LoginRequiredMixin, RoleRequiredMixin, EmailVerificationRequiredMixin, ActivationRequiredMixin,
                    ListView):
    allowed_roles = ['tutor']
    model = Session
    template_name = 'ap2_tutor/dashboard/dp_client_list.html'
    # ordering = ['-profile__create_date']
    paginate_by = 6

    def get_queryset(self):
        # Assuming the logged-in user is a Tutor and you have a relationship between Tutor and UserProfile
        return Session.objects.filter(provider=self.request.user).order_by('-start_session_utc')


class DPReviews(LoginRequiredMixin, RoleRequiredMixin, EmailVerificationRequiredMixin, ActivationRequiredMixin,
                ListView):
    allowed_roles = ['tutor']
    model = Review
    template_name = 'ap2_tutor/dashboard/dp_review.html'
    # ordering = ['-last_modified']
    paginate_by = 6  # Number of items per page

    def get_queryset(self):
        # Assuming the logged-in user is a Tutor and you have a relationship between Tutor and UserProfile
        return Review.objects.filter(tutor__profile__user=self.request.user).order_by('-create_date')


class DPEditProfile(LoginRequiredMixin, RoleRequiredMixin, EmailVerificationRequiredMixin, ActivationRequiredMixin,
                    View):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dp_edit.html'
    success_url = reverse_lazy('provider:dp_home')

    def get_context_data(self, **kwargs):
        user = self.request.user
        user_profile = UserProfile.objects.get(user=user)
        tutor = Tutor.objects.get(profile=user_profile)

        context = {
            'profile_form': CombinedProfileForm(
                user_instance=user,
                profile_instance=user_profile,
                tutor_instance=tutor
            ),
            'tutor': tutor,
        }
        context.update(kwargs)  # Add any additional kwargs to context
        return context

    def get(self, request, *args, **kwargs):
        context = self.get_context_data()
        return render(request, self.template_name, context)

    def post(self, request, *args, **kwargs):
        user = request.user
        user_profile = UserProfile.objects.get(user=user)
        tutor = Tutor.objects.get(profile=user_profile)

        form = CombinedProfileForm(
            request.POST, request.FILES,
            user_instance=user,
            profile_instance=user_profile,
            tutor_instance=tutor
        )

        if form.is_valid():
            form.save(user)
            messages.success(request, 'Your changes saved successfully.')
            return redirect(self.success_url)

        context = self.get_context_data(form=form)
        return render(request, self.template_name, context)


# ==================================== WIZARD start ====================================
# ====================================
class BasicProfile(LoginRequiredMixin, RoleRequiredMixin, EmailVerificationRequiredMixin, ActivationRequiredMixin,
                   View):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dp_edit.html'
    success_url = reverse_lazy('provider:dp_home')

    def get_context_data(self, **kwargs):
        user = self.request.user
        user_profile = UserProfile.objects.get(user=user)
        tutor = Tutor.objects.get(profile=user_profile)

        context = {
            'profile_basic_form': ProfileBasicForm(
                user_instance=user,
                profile_instance=user_profile,
                tutor_instance=tutor
            ),
            'tutor': tutor,
        }
        context.update(kwargs)  # Add any additional kwargs to context
        return context

    def get(self, request, *args, **kwargs):
        context = self.get_context_data()
        return render(request, self.template_name, context)

    def post(self, request, *args, **kwargs):
        user = request.user
        user_profile = UserProfile.objects.get(user=user)
        tutor = Tutor.objects.get(profile=user_profile)

        form = ProfileBasicForm(
            request.POST, request.FILES,
            user_instance=user,
            profile_instance=user_profile,
            tutor_instance=tutor
        )

        # Extra security check - compare submitted email with current email
        submitted_email = request.POST.get('email')
        if submitted_email and submitted_email != user.email:
            messages.error(request, 'Security violation: Email modification detected')
            return redirect(self.success_url)

        if form.is_valid():
            form.save(user)
            messages.success(request, 'Your changes saved successfully.')
            return redirect(self.success_url)

        context = self.get_context_data(form=form)
        return render(request, self.template_name, context)


class DPWizard(BasicProfile, LoginRequiredMixin, RoleRequiredMixin, EmailVerificationRequiredMixin, TemplateView):
    allowed_roles = ['tutor']
    need_activation = False
    template_name = 'ap2_tutor/wizard/dp_wizard.html'

    # success_url = reverse_lazy('provider:dp_wizard')
    def dispatch(self, request, *args, **kwargs):
        user = getattr(request, 'user', None)

        # Check if user has a profile
        profile = getattr(user, 'profile', None)
        if not profile:
            return error_page(request, 'Error', 'User profile not found', 500)

        # Check if profile has a tutor_profile
        tutor_profile = getattr(profile, 'tutor_profile', None)
        if not tutor_profile:
            return error_page(request, 'Error', 'Tutor profile not found', 500)

        # Check tutor_profile status
        if tutor_profile.status in ['decision', 'accepted', 'rejected']:
            return redirect('provider:dp_wizard_result')

        # Proceed with normal dispatch if no redirect condition met
        return super().dispatch(request, *args, **kwargs)

    def get_success_url(self, current_step):
        """Determine next URL based on current step"""
        # Map steps to their corresponding URLs
        step_urls = {
            2: reverse_lazy('provider:dp_wizard_step3'),
            3: reverse_lazy('provider:dp_wizard_step4'),
            4: reverse_lazy('provider:dp_wizard_step5'),
            5: reverse_lazy('provider:dp_wizard_step6'),
            6: reverse_lazy('provider:dp_home')
        }
        return step_urls.get(current_step, reverse_lazy('provider:dp_wizard'))

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user

        current_step = self._get_step(user)
        context['current_step'] = current_step
        context['COUNTRY_CODE_CHOICES'] = COUNTRY_CODE_CHOICES

        # Decision(6), Accepted(7), Rejected(8)
        if current_step > 5 and user.profile.tutor_profile.reviewer_comment:
            context['reviewer_comment'] = user.profile.tutor_profile.reviewer_comment
        else:
            context['reviewer_comment'] = ''

        # Add forms and data based on current step
        try:
            user_profile = UserProfile.objects.get(user=user)
            tutor = Tutor.objects.get(profile=user_profile)
            # Educaiton cards context
            context['edu_extra_form'] = EducationalExtraForm(
                user_instance=user,
                tutor_instance=tutor
            )
            context['degree_levels'] = DegreeLevel.objects.all()
            # context['degree_levels'] = DEGREE_LEVELS
            context['teaching_certificates'] = TEACHING_CERTIFICATES
            # Basic profile form is needed in multiple steps
            context['profile_basic_form'] = ProfileBasicForm(
                user_instance=user,
                profile_instance=user_profile,
                tutor_instance=tutor
            )
            context['applicantUId'] = user.id
            context['isVIP'] = user.profile.is_vip
            context['maxEntries'] = 5 if user.profile.is_vip else 3
            context['skills'] = Skill.objects.all()
            context['levels'] = Level.objects.all()
            context['skillForm'] = CombinedSkillForm(user=user)  # Pass user to the form
            # Get existing skills for display in step 3
            context['existing_skills'] = UserSkill.objects.filter(user=user)
            context['location_form'] = LocationForm(user_instance=user, profile_instance=user.profile)
            context['education_form'] = UserEducationForm(user=user)
            context['user_education'] = user.education.all() if hasattr(user, 'education') else None
            context['tutor'] = Tutor.objects.get(profile__user=user)
            context['AgreementForm'] = AgreementForm()
            context['AppointmentSettingForm'] = AppointmentSettingForm()
            context['PricingForm'] = PricingForm()
            try:
                if hasattr(user, 'appointment_settings') and user.appointment_settings:
                    context['user_timezone'] = user.appointment_settings.timezone
                else:
                    # Try to get timezone from browser or use UTC as fallback
                    u_settings = AppointmentSetting.objects.create(user=user)
                    u_settings.timezone = self.request.session.get('user_timezone', 'UTC')
                    u_settings.save()
                    context['user_timezone'] = u_settings.timezone
            except Exception as e:
                print(f"Error getting timezone: {e}")
                context['user_timezone'] = 'UTC'

            # REVIEW AND SUBMIT CONTEXT -----------------
            # Get pricing information
            # try:
            #     appointment_settings = AppointmentSetting.objects.get(user=request.user)
            #     lesson_price = appointment_settings.lesson_price
            #     follows_recommendation = (lesson_price == 24)  # Assuming $24 is the recommendation
            #     commission_rate = 25  # Starting commission rate
            #
            #     # Calculate earnings at different tiers
            #     tier1_earnings = lesson_price * (1 - 0.25)
            #     tier2_earnings = lesson_price * (1 - 0.22)
            #     tier3_earnings = lesson_price * (1 - 0.20)
            #     tier4_earnings = lesson_price * (1 - 0.18)
            #     tier5_earnings = lesson_price * (1 - 0.15)
            #
            # except AppointmentSetting.DoesNotExist:
            #     # Default values if not set
            #     lesson_price = 24
            #     follows_recommendation = True
            #     commission_rate = 25
            #     tier1_earnings = 18.00
            #     tier2_earnings = 18.72
            #     tier3_earnings = 19.20
            #     tier4_earnings = 19.68
            #     tier5_earnings = 20.40

            # Get availability information
            available_rules = AvailableRule.objects.filter(user=user, is_available=True)
            user_timezone = user.appointment_settings.timezone if user.appointment_settings else 'UTC'
            session_length = user.appointment_settings.session_length if user.appointment_settings else 2

            # Create week schedule data
            days_of_week = [
                {'id': '0', 'name': 'Sunday'},
                {'id': '1', 'name': 'Monday'},
                {'id': '2', 'name': 'Tuesday'},
                {'id': '3', 'name': 'Wednesday'},
                {'id': '4', 'name': 'Thursday'},
                {'id': '5', 'name': 'Friday'},
                {'id': '6', 'name': 'Saturday'},
            ]

            week_schedule = []
            total_available_days = 0
            total_time_slots = 0

            for day in days_of_week:
                day_rules = available_rules.filter(weekday=day['id'])
                time_slots = []

                for rule in day_rules:
                    time_slots.append({
                        'start_time': rule.start_time_utc,
                        'end_time': rule.end_time_utc
                    })
                    total_time_slots += 1

                week_schedule.append({
                    'id': day['id'],
                    'name': day['name'],
                    'available': len(time_slots) > 0,
                    'time_slots': time_slots
                })

                if len(time_slots) > 0:
                    total_available_days += 1

            # context = {
            # 'lesson_price': lesson_price,
            # 'follows_recommendation': follows_recommendation,
            # 'commission_rate': commission_rate,
            # 'tier1_earnings': tier1_earnings,
            # 'tier2_earnings': tier2_earnings,
            # 'tier3_earnings': tier3_earnings,
            # 'tier4_earnings': tier4_earnings,
            # 'tier5_earnings': tier5_earnings,
            #     'user_timezone': user_timezone,
            #     'session_length': session_length,
            #     'week_schedule': week_schedule,
            #     'total_available_days': total_available_days,
            #     'total_time_slots': total_time_slots,
            # }
            context['user_timezone'] = user_timezone
            context['lesson_price'] = user.profile.tutor_profile.cost_hourly
            commission_rate = user.profile.tutor_profile.get_commission_rate()
            context['commission_rate'] = commission_rate * 100
            context['session_length'] = int(session_length) * 30
            # context['week_schedule'] = week_schedule
            context['week_schedule'] = get_week_schedule(user=user)
            context['total_available_days'] = total_available_days
            context['total_time_slots'] = total_time_slots


        except (UserProfile.DoesNotExist, Tutor.DoesNotExist):
            # Handle case where profile doesn't exist
            messages.error(self.request, 'Profile not found. Please contact support.')

        return context

    def post(self, request, *args, **kwargs):
        action = request.POST.get('action')
        submitted_step = int(request.POST.get('step', 2))
        db_step = self._get_step(request.user)

        # Map steps to their handlers
        handlers = {
            1: self.handle_profile_form,
            2: self.handle_skills_form,
            3: self.handle_education_form,
            4: self.handle_review_step,
            5: self.handle_result_step
        }

        handler = handlers.get(submitted_step)
        if handler:
            return handler(request, action)

        # return redirect(self.get_success_url(step))

        return JsonResponse({
            'success': False,
            'errors': {'__all__': 'Invalid step'}
        }, status=400)

    def handle_profile_form(self, request, action):
        user = request.user
        try:
            user_profile = UserProfile.objects.get(user=user)
            tutor = Tutor.objects.get(profile=user_profile)

            form = ProfileBasicForm(
                request.POST,
                request.FILES,
                user_instance=user,
                profile_instance=user_profile,
                tutor_instance=tutor
            )

            if form.is_valid():
                form.save(user)
                messages.success(request, 'Profile information saved successfully!')
                if action == 'next':
                    # Update application status
                    # application = ProviderApplication.objects.get(user=user)
                    applicant = Tutor.objects.get(profile__user=user)
                    applicant.status = 'completed_profile'
                    applicant.save()
                    # return redirect(self.get_success_url(step))

                # For save action, stay on same page
                # return redirect(request.path)
                # return redirect('provider:dp_wizard')
                return JsonResponse({
                    'success': True,
                    'message': 'Profile saved successfully!',
                    'next_step': self._get_step(user) if action == 'next' else None
                })

            # context = self.get_context_data(form=form)
            # return render(request, self.template_name, context)
            return JsonResponse({
                'success': False,
                'errors': form.errors
            })

        except Exception as e:
            return JsonResponse({
                'success': False,
                'errors': {'__all__': str(e)}
            }, status=500)

    def handle_skills_form(self, request, action):
        user = request.user
        try:
            # Handle video intro
            video_intro = request.FILES.get('video_intro')
            if video_intro:
                tutor = user.profile.tutor_profile
                tutor.video_intro = video_intro
                tutor.save()

            # Handle skills
            skills = request.POST.getlist('skills[]')
            levels = request.POST.getlist('levels[]')
            videos = request.FILES.getlist('videos[]')
            certificates = request.FILES.getlist('certificates[]')

            # Validate maximum skills
            max_skills = 5 if user.profile.is_vip else 3
            if len(skills) > max_skills:
                return JsonResponse({
                    'success': False,
                    'errors': {'__all__': f'Maximum {max_skills} skills allowed'}
                }, status=400)

            # Save skills
            for i, (skill_id, level_id) in enumerate(zip(skills, levels)):
                skill = Skill.objects.get(id=skill_id)
                level = Level.objects.get(id=level_id)

                # Update existing or create new
                user_skill, created = UserSkill.objects.update_or_create(
                    user=user,
                    skill=skill,
                    defaults={
                        'level': level,
                        'video': videos[i] if i < len(videos) else None,
                        'certificate': certificates[i] if i < len(certificates) else None,
                        'status': 'pending'
                    }
                )

            if action == 'next':
                # Update application status
                # application = ProviderApplication.objects.get(user=user)
                applicant = Tutor.objects.get(profile__user=user)
                applicant.status = 'added_skills'
                applicant.save()

            return JsonResponse({
                'success': True,
                'message': 'Skills saved successfully!',
                'next_step': self._get_step(user) if action == 'next' else None
            })

        except Exception as e:
            return JsonResponse({
                'success': False,
                'errors': {'__all__': str(e)}
            }, status=500)

    def handle_education_form(self, request, action):
        user = request.user
        try:
            form = UserEducationForm(request.POST, request.FILES, user=user)

            if form.is_valid():
                education = form.save(commit=False)
                education.user = user
                education.save()

                if action == 'next':
                    # Update application status
                    # application = ProviderApplication.objects.get(user=user)
                    applicant = Tutor.objects.get(profile__user=user)
                    applicant.status = 'added_edu'
                    applicant.save()

                return JsonResponse({
                    'success': True,
                    'message': 'Education saved successfully!',
                    'next_step': self._get_step(user) if action == 'next' else None
                })

            return JsonResponse({
                'success': False,
                'errors': form.errors
            })

        except Exception as e:
            return JsonResponse({
                'success': False,
                'errors': {'__all__': str(e)}
            }, status=500)

    def handle_review_step(self, request, action):
        user = request.user
        try:
            if action == 'next':
                # Update application status to decision
                # application = ProviderApplication.objects.get(user=user)
                applicant = Tutor.objects.get(profile__user=user)
                applicant.status = 'decision'
                applicant.save()

                # Send notification emails
                self.send_submission_notifications(user)

                return JsonResponse({
                    'success': True,
                    'message': 'Application submitted successfully! We will review it shortly.',
                    'next_step': self._get_step(user)
                })

            return JsonResponse({
                'success': True,
                'message': 'Review saved'
            })

        except Exception as e:
            return JsonResponse({
                'success': False,
                'errors': {'__all__': str(e)}
            }, status=500)

    def handle_result_step(self, request, action):
        return

    def send_submission_notifications(self, user):
        """Send notification emails to applicant and admin"""
        try:
            # application = ProviderApplication.objects.get(user=user)
            applicant = Tutor.objects.get(profile__user=user)

            # Email to applicant
            subject = f"🎉 Application Submitted Successfully - {settings.SITE_NAME}"
            template_name = 'emails/tutor/application_submitted'
            context = {
                'full_name': f"{user.first_name} {user.last_name}",
                'site_name': settings.SITE_NAME
            }
            send_dual_email(subject, template_name, context, [user.email])

            # Notification to admin
            notify_subject = f"New Tutor Application Submitted - {user.get_full_name()}"
            notification_email_to_admin(notify_subject, 'emails/admin/new_tutor_application', context)

        except Exception as e:
            # Log error but don't stop the process
            print(f"Error sending notification emails: {str(e)}")

    def _get_step(self, user):
        """Helper method to determine current step based on application status"""
        try:
            # applicant_status = ProviderApplication.objects.get(user=user).status
            applicant_status = Tutor.objects.get(profile__user=user).status

            status_step_mapping = {
                'pending': 0,
                'invited': 0,
                'registered': 0,
                'email_verified': 1,  # -- Go to: Basic Profile
                'completed_profile': 2,  # -- Go to: Teaching Skills
                'added_skills': 3,  # -- Go to: Teaching method Step
                'added_method': 4,  # -- Go to: Education Step
                'added_edu': 5,  # -- Go to: Availability Step
                'added_availability': 6,  # -- Go to: Pricing Step
                'added_pricing': 7,  # -- Go to: Review Step
                'review': 8,  # -- Go to: decision Step
                'decision': 9,  # Waiting for decision
                'accepted': 10,  # Approved  -- Action Button: go to dashboard
                'rejected': 11,  # Declined  -- Block user access to panel or just show ERROR PAGE!

            }

            return status_step_mapping.get(applicant_status, 0)
        # except ProviderApplication.DoesNotExist:
        except Tutor.DoesNotExist:
            return 0  # Default to start


@login_required
def get_pricing(request):
    """Get current pricing for the logged-in tutor"""
    try:
        tutor = request.user.profile.tutor_profile
        return JsonResponse({
            'status': 'success',
            'cost_hourly': float(tutor.cost_hourly),  # Convert Decimal to float for JSON
            'cost_trial': float(tutor.cost_trial),
        })
    except Exception as e:
        return JsonResponse({'status': 'error', 'message': str(e)}, status=500)


@csrf_exempt  # For simplicity, but better to use proper CSRF handling
@require_POST
@login_required
def update_pricing(request):
    """Update pricing for the logged-in tutor"""
    try:
        # Parse JSON data from request body
        data = json.loads(request.body)
        cost_hourly = data.get('cost_hourly')

        # Validate the input
        if cost_hourly is None:
            return JsonResponse({'status': 'error', 'message': 'cost_hourly is required'}, status=400)

        try:
            cost_hourly = float(cost_hourly)
        except (ValueError, TypeError):
            return JsonResponse({'status': 'error', 'message': 'Invalid price value'}, status=400)

        # Update the tutor's pricing
        tutor = request.user.profile.tutor_profile
        tutor.cost_hourly = cost_hourly
        tutor.status = 'added_pricing'
        tutor.save()

        return JsonResponse({
            'status': 'success',
            'message': 'Pricing updated successfully',
            'cost_hourly': float(tutor.cost_hourly)
        })

    except Exception as e:
        return JsonResponse({'status': 'error', 'message': str(e)}, status=500)


# ------------------------ WIZARD Functions
# Similarly implement steps 5 and 6
@login_required
def get_existed_skills_BACKUP_KEEP_IT(request):
    # Get and validate user ID parameter
    applicantUId = request.GET.get('applicantUId')
    if not applicantUId or not applicantUId.isdigit():
        return JsonResponse({'status': 'error', 'message': 'Invalid user ID format'}, status=400)

    try:
        # Check if user exists
        try:
            applicantUser = User.objects.get(id=int(applicantUId))
        except User.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': 'User does not exist'}, status=404)

        # applicant user MUST be same as logged in user
        # Verify authorization (user can only access their own data)
        if applicantUser != request.user:
            return JsonResponse({'status': 'error', 'message': 'Forbidden Access: You can only access your own data'},
                                status=403)

        # Check if user has a profile
        if not hasattr(applicantUser, 'profile'):
            return JsonResponse({'status': 'error', 'message': 'User profile not found'}, status=404)

        # Get user skills
        existed_uSkills = UserSkill.objects.filter(user=applicantUser).values(
            'id', 'skill', 'skill__name', 'level', 'level__name',
            'certificate', 'video', 'status'
        )
        # Get tutor data safely
        tutor = Tutor.objects.filter(profile=applicantUser.profile).first()
        video_intro = tutor.video_intro.url if (tutor and tutor.video_intro) else None

        existed_uSkill_list = [
            {
                'uSkillId': uSkill['id'],
                'skill': uSkill['skill'],  # ID
                'skillName': uSkill['skill__name'],  # Name for display
                'level': uSkill['level'],  # ID
                'levelName': uSkill['level__name'],  # Name for display
                'certificate': uSkill['certificate'],
                'video': uSkill['video'],
                'status': uSkill['status'],
            }
            for uSkill in existed_uSkills
        ]

        return JsonResponse({
            'status': 'success',
            'existed_uSkill_list': existed_uSkill_list,
            'video_intro': video_intro,
        })

    except Exception as e:
        return JsonResponse({'status': 'error', 'message': str(e)}, status=500)


@login_required
@ownership_required(lookup_field='id', lookup_url_kwarg='applicantUId', id_param='applicantUId')
def get_existed_skills(request):
    # Your existing logic (simplified since ownership is checked by decorator)
    user_profile = request.user.profile

    # Get user skills
    existed_uSkills = UserSkill.objects.filter(user=request.user).values(
        'id', 'skill', 'skill__name', 'level', 'level__name',
        'certificate', 'thumbnail', 'video', 'status'
    )
    # Get tutor data safely
    tutor = Tutor.objects.filter(profile=user_profile).first()
    # video_intro = tutor.video_intro.url if (tutor and tutor.video_intro) else None

    existed_uSkill_list = [
        {
            'uSkillId': uSkill['id'],
            'skill': uSkill['skill'],  # ID
            'skillName': uSkill['skill__name'],  # Name for display
            'level': uSkill['level'],  # ID
            'levelName': uSkill['level__name'],  # Name for display
            'certificate': uSkill['certificate'],
            'thumbnail': uSkill['thumbnail'],
            'video': uSkill['video'],
            'status': uSkill['status'],
        }
        for uSkill in existed_uSkills
    ]

    tutor = Tutor.objects.filter(profile=user_profile).first()
    # video_intro = tutor.video_intro.url if (tutor and tutor.video_intro) else None

    return JsonResponse({
        'status': 'success',
        # 'existed_uSkill_list': existed_uSkill_list,
        # 'existed_uSkill_list': list(existed_uSkills),
        'existed_uSkill_list': existed_uSkill_list,
        # 'video_intro': video_intro,
    })


def save_skills_main(request):
    video_allowed_extensions = ['mp4', 'ts']
    certificate_allowed_extensions = ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg']
    if request.method == 'POST' and request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        try:
            # Get current user and tutor profile
            user = request.user
            tutor = user.profile.tutor_profile
            existed_video = tutor.video_intro  # Initialize existed_video

            # Process video intro
            video_intro = request.FILES.get('video_intro')

            # Validate video intro
            if not video_intro and not existed_video:
                return JsonResponse({'error': 'Introduction video is required'}, status=400)

            # Only validate extension if new file was uploaded
            if video_intro:
                if not validate_file_extension(video_intro.name, video_allowed_extensions):
                    return JsonResponse(
                        {'error': f'Invalid video format. Only {video_allowed_extensions} allowed.'},
                        status=400
                    )
                tutor.video_intro = video_intro
                tutor.save()

            # Process removed skills first
            removed_skills = request.POST.getlist('removed_skills')
            if removed_skills:
                UserSkill.objects.filter(
                    id__in=removed_skills,
                    user=user
                ).delete()
                print(f"Deleted {len(removed_skills)} skills")

            # Process skills data
            skills = request.POST.getlist('skills')
            levels = request.POST.getlist('levels')
            skill_videos = request.FILES.getlist('skill_videos')
            certificates = request.FILES.getlist('certificates')

            saved_skills = []

            # Validate max skills
            if request.user.profile.is_vip:
                MAX_SKILLS = 5
            else:
                MAX_SKILLS = 3

            if len(skills) > MAX_SKILLS or len(levels) > MAX_SKILLS or len(skill_videos) > MAX_SKILLS:
                return JsonResponse({'error': f'Maximum {MAX_SKILLS} skills allowed'}, status=400)

            # if not validate_file_extension(video_intro.name, video_allowed_extensions):
            #     return JsonResponse({'error': f'Invalid video format. Only {video_allowed_extensions} allowed.'},
            #                         status=400)

            # Validate each skill
            for i, (skill_id, level_id) in enumerate(zip(skills, levels)):
                try:
                    # Validate skill video
                    # if i >= len(skill_videos):
                    #     return JsonResponse({'error': f'Video is required for skill {i+1}'}, status=400)

                    video_file = skill_videos[i] if i < len(skill_videos) else None
                    if video_file:
                        if not validate_file_extension(skill_videos[i].name, video_allowed_extensions):
                            return JsonResponse(
                                {
                                    'error': f'Invalid video format for skill {i + 1}. Only {video_allowed_extensions} are allowed.'},
                                status=400)

                    # Validate certificate if exists
                    if i < len(certificates):
                        if not validate_file_extension(certificates[i].name, certificate_allowed_extensions):
                            return JsonResponse({'error': f'Invalid certificate format for skill {i + 1}'}, status=400)

                    # Validate skill and level exist
                    # Get related objects
                    skill = Skill.objects.get(id=skill_id)
                    level = Level.objects.get(id=level_id)

                    # Create UserSkill instance
                    # Inside your for loop, after getting `skill` and `level`
                    # Check if skill already exists for user
                    existing_skill = UserSkill.objects.filter(user=user, skill=skill).first()
                    if existing_skill:
                        # Optional: update it instead of skipping
                        existing_skill.level = level
                        existing_skill.certificate = certificates[i] if i < len(certificates) else None
                        existing_skill.video = video_file
                        existing_skill.status = 'pending'
                        existing_skill.save()
                        saved_skills.append(existing_skill.id)
                        continue  # skip creating a new one

                    # Create new UserSkill only if not exists
                    user_skill = UserSkill(
                        user=user,
                        skill=skill,
                        level=level,
                        certificate=certificates[i] if i < len(certificates) else None,
                        video=video_file,
                        status='pending'
                    )
                    user_skill.save()
                    saved_skills.append(user_skill.id)
                    print(f'userSkill saved! {user_skill}')

                    # Additional processing if needed
                    # applicant = ProviderApplication.objects.get(user=user)
                    applicant = Tutor.objects.get(profile__user=user)
                    applicant.status = 'added_skills'  # after added skills we need to add Edu!
                    applicant.save()
                    print(f'applicant status updated! {applicant.status}')


                except (Skill.DoesNotExist, Level.DoesNotExist):
                    return JsonResponse({'error': f'Invalid skill or level for row {i + 1}'}, status=400)

            # ... your save logic ...

            return JsonResponse({
                'success': True,
                'message': f'Successfully saved {len(saved_skills)} skills',
                'saved_skills': saved_skills,
                'video_intro_url': tutor.video_intro.url if tutor.video_intro else None
            })


        except Exception as e:
            print(f'Ah... error500')
            return JsonResponse({'success': False, 'error': str(e)}, status=500)

    print(f'Ah... error400')
    return JsonResponse({'success': False, 'error': 'Invalid request'}, status=400)


# @csrf_exempt
# @ownership_required(lookup_field='id', lookup_url_kwarg='applicantUId', id_param='applicantUId')
def save_skills(request):
    if request.method == 'POST' and request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        try:
            user = request.user
            tutor = user.profile.tutor_profile
            video_extensions = ['mp4', 'ts']
            cert_extensions = ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg']
            thumbnail_extensions = ['png', 'jpg', 'jpeg']

            # Debug logging
            print("Received FILES:", list(request.FILES.keys()))
            print("Received POST data:", {
                k: v for k, v in request.POST.items()
                if not k.startswith('csrf') and not k.endswith('[]')
            })

            # Parse tracking data - convert all IDs to integers
            videos_new = [int(id) for id in json.loads(request.POST.get('videos_new', '[]'))]
            videos_changed = [int(id) for id in json.loads(request.POST.get('videos_changed', '[]'))]
            videos_removed = [int(id) for id in json.loads(request.POST.get('videos_removed', '[]'))]

            certs_new = [int(id) for id in json.loads(request.POST.get('certs_new', '[]'))]
            certs_changed = [int(id) for id in json.loads(request.POST.get('certs_changed', '[]'))]
            certs_removed = [int(id) for id in json.loads(request.POST.get('certs_removed', '[]'))]

            thumbs_new = [int(id) for id in json.loads(request.POST.get('thumbs_new', '[]'))]
            thumbs_changed = [int(id) for id in json.loads(request.POST.get('thumbs_changed', '[]'))]
            thumbs_removed = [int(id) for id in json.loads(request.POST.get('thumbs_removed', '[]'))]

            skills_removed = [int(id) for id in json.loads(request.POST.get('skills_removed', '[]'))]
            skills_new = [int(id) for id in json.loads(request.POST.get('skills_new', '[]'))]

            # Get all skill data
            skills = request.POST.getlist('skills[]')
            levels = request.POST.getlist('levels[]')
            skill_ids = [int(id) if id else None for id in request.POST.getlist('skill_ids[]')]

            # ===== 1. PROCESS REMOVALS FIRST =====
            # Remove complete skills and their files
            if skills_removed:
                skills_to_delete = UserSkill.objects.filter(id__in=skills_removed, user=user)
                for skill in skills_to_delete:
                    if skill.video:
                        skill.video.delete(save=False)
                    if skill.certificate:
                        skill.certificate.delete(save=False)
                    if skill.thumbnail:
                        skill.thumbnail.delete(save=False)
                skills_to_delete.delete()

            # Remove specific videos
            for uSkillId in videos_removed:
                try:
                    skill = UserSkill.objects.get(id=uSkillId, user=user)
                    if skill.video:
                        skill.video.delete(save=False)
                        skill.video = None
                        skill.save()
                except UserSkill.DoesNotExist:
                    continue

            # Remove specific certificates
            for uSkillId in certs_removed:
                try:
                    skill = UserSkill.objects.get(id=uSkillId, user=user)
                    if skill.certificate:
                        skill.certificate.delete(save=False)
                        skill.certificate = None
                        skill.save()
                except UserSkill.DoesNotExist:
                    continue

            # Remove specific thumbnail
            for uSkillId in thumbs_removed:
                try:
                    skill = UserSkill.objects.get(id=uSkillId, user=user)
                    if skill.thumbnail:
                        skill.thumbnail.delete(save=False)
                        skill.thumbnail = None
                        skill.save()
                except UserSkill.DoesNotExist:
                    continue

            # ===== 2. PROCESS ALL SKILLS (NEW AND EXISTING) =====
            saved_skills = []
            existing_skills = {
                us.skill_id: us for us in
                UserSkill.objects.filter(user=user).select_related('skill')
            }

            for i in range(len(skills)):
                skill_id = skill_ids[i] if i < len(skill_ids) else None
                skill_pk = int(skills[i])
                level_pk = int(levels[i])

                try:
                    # Check if this skill already exists for user
                    if skill_pk in existing_skills:
                        user_skill = existing_skills[skill_pk]
                        is_new = False
                    else:
                        # Create new skill only if it doesn't exist
                        user_skill, created = UserSkill.objects.get_or_create(
                            user=user,
                            skill_id=skill_pk,
                            defaults={
                                'level_id': level_pk,
                                'status': 'pending'
                            }
                        )
                        is_new = created

                    # Update level if changed
                    if user_skill.level_id != level_pk:
                        user_skill.level_id = level_pk
                        user_skill.status = 'pending'

                    # Handle file uploads
                    def handle_upload(file_type, field_name, extensions):
                        # Try both possible key formats
                        for key in [f'{file_type}_{skill_id}', f'{file_type}_{user_skill.id}']:
                            if key in request.FILES:
                                file = request.FILES[key]
                                if validate_file_extension(file.name, extensions):
                                    current_file = getattr(user_skill, field_name)
                                    if current_file:
                                        current_file.delete(save=False)
                                    setattr(user_skill, field_name, file)
                                    return True
                        return False

                    video_updated = handle_upload('skill_video', 'video', video_extensions)
                    cert_updated = handle_upload('certificate', 'certificate', cert_extensions)
                    thumb_updated = handle_upload('thumbnail', 'thumbnail', thumbnail_extensions)

                    # Only save if something changed
                    if is_new or video_updated or cert_updated or thumb_updated or user_skill.level_id != level_pk:
                        user_skill.save()

                    saved_skills.append(user_skill.id)

                except Exception as e:
                    print(f"Error processing skill {i + 1}: {str(e)}")
                    continue

            # Update application status
            Tutor.objects.filter(profile__user=user).update(status='added_skills')

            return JsonResponse({
                'success': True,
                'message': 'Skills updated successfully',
                'saved_skills': saved_skills,
                'stats': {
                    'skills_total': len(skills),
                    'skills_new': len(skills_new),
                    'skills_removed': len(skills_removed),
                    'videos_new': len(videos_new),
                    'videos_changed': len(videos_changed),
                    'videos_removed': len(videos_removed),
                    'certs_new': len(certs_new),
                    'certs_changed': len(certs_changed),
                    'certs_removed': len(certs_removed),
                    'thumbs_new': len(thumbs_new),
                    'thumbs_changed': len(thumbs_changed),
                    'thumbs_removed': len(thumbs_removed),
                }
            })

        except Exception as e:
            print(f"Error in save_skills: {str(e)}")
            return JsonResponse({
                'success': False,
                'error': str(e),
                'traceback': traceback.format_exc() if settings.DEBUG else None
            }, status=500)

    return JsonResponse({'success': False, 'error': 'Invalid request'}, status=400)


# -------------------------------------------
@ownership_required(lookup_field='id', lookup_url_kwarg='applicantUId', id_param='applicantUId')
def get_education_data(request):
    try:
        user = request.user

        # Get education records
        educations = UserEducation.objects.filter(user=user).select_related('degree').order_by('-end_year')

        # Get teaching certificates
        certificates = TeachingCertificate.objects.filter(user=user).order_by('-completion_date')

        # Format education data
        education_list = []
        for edu in educations:
            education_list.append({
                'id': edu.id,
                'degree': edu.degree.id,
                'degreeName': edu.degree.name,
                'field': edu.field_of_study,
                'institution': edu.institution,
                'start_year': edu.start_year,
                'end_year': edu.end_year,
                'document': request.build_absolute_uri(edu.document.url) if edu.document else None,
                'description': edu.description,
                'status': edu.status
            })

        # Format certificate data
        certificate_list = []
        for cert in certificates:
            certificate_list.append({
                'id': cert.id,
                'name': cert.name,
                'organization': cert.issuing_organization,
                'completion_year': cert.completion_date,  # Changed from date to year
                'document': request.build_absolute_uri(
                    cert.document.url) if cert.document else None,
                'is_certified': cert.is_certified
            })

        return JsonResponse({
            'status': 'success',
            'education': education_list,
            'certifications': certificate_list
        })

    except Exception as e:
        return JsonResponse({
            'status': 'error',
            'message': str(e),
            'traceback': traceback.format_exc() if settings.DEBUG else None
        }, status=500)


# Shared helper functions
def validate_file_extension(filename, allowed_extensions):
    """Validate file extension against allowed list"""
    extension = filename.split('.')[-1].lower()
    return extension in allowed_extensions


def handle_file_upload(model_instance, field_name, new_file, allowed_extensions):
    """Handle file upload with validation and cleanup of old file"""
    if not validate_file_extension(new_file.name, allowed_extensions):
        return False

    # Delete old file if exists
    old_file = getattr(model_instance, field_name)
    if old_file:
        old_file.delete(save=False)

    # Save new file
    setattr(model_instance, field_name, new_file)
    return True


def process_removals(model, user, ids_to_remove, file_fields=None):
    """Process removal of multiple items with file cleanup"""
    if not ids_to_remove:
        return

    items_to_delete = model.objects.filter(id__in=ids_to_remove, user=user)

    if file_fields:
        for item in items_to_delete:
            for field in file_fields:
                file = getattr(item, field)
                if file:
                    file.delete(save=False)

    items_to_delete.delete()


@require_POST
@csrf_exempt
@transaction.atomic
def save_educations(request):
    if not request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        return JsonResponse({'success': False, 'error': 'Invalid request'}, status=400)

    try:
        user = request.user
        allowed_extensions = ['pdf', 'jpg', 'jpeg', 'png']
        current_year = datetime.now().year
        max_year = current_year + 10

        # Debug logging
        print("Received FILES:", list(request.FILES.keys()))
        print("Received POST data:", {
            k: v for k, v in request.POST.items()
            if not k.startswith('csrf') and not k.endswith('[]')
        })

        # Parse tracking data - we only need new and removed now
        education_new = json.loads(request.POST.get('education_new', '[]'))
        education_removed = json.loads(request.POST.get('education_removed', '[]'))
        education_doc_removed = json.loads(request.POST.get('education_doc_removed', '[]'))

        certification_new = json.loads(request.POST.get('certification_new', '[]'))
        certification_removed = json.loads(request.POST.get('certification_removed', '[]'))
        certification_doc_removed = json.loads(request.POST.get('certification_doc_removed', '[]'))

        # ===== 0. PROCESS Two Optional fields =====
        years_experience = request.POST.get('years_experience')
        teaching_tags = json.loads(request.POST.get('teaching_tags', '[]'))

        tutor = Tutor.objects.get(profile__user=user)
        if years_experience:
            tutor.years_experience = years_experience
        if teaching_tags:
            tutor.teaching_tags.set(teaching_tags)  # Use .set() for ManyToMany fields
        tutor.save()

        # ===== 1. PROCESS REMOVALS FIRST =====
        # Remove education entries and their files
        if education_removed:
            # First get all educations that will be deleted
            educations_to_delete = UserEducation.objects.filter(
                id__in=education_removed,
                user=user
            )

            # Delete their files first
            for education in educations_to_delete:
                if education.document:
                    education.document.delete(save=False)

            # Then delete the records
            educations_to_delete.delete()

        # Remove certification entries and their files
        if certification_removed:
            certs_to_delete = TeachingCertificate.objects.filter(
                id__in=certification_removed,
                user=user
            )

            for cert in certs_to_delete:
                if cert.document:
                    cert.document.delete(save=False)

            certs_to_delete.delete()

        # ===== 2. PROCESS DOCUMENT REMOVALS =====
        # Handle cases where card exists but document was removed
        for card_id in education_doc_removed:
            try:
                education = UserEducation.objects.get(id=card_id, user=user)
                if education.document:
                    education.document.delete(save=False)
                    education.document = None
                    education.save()
            except UserEducation.DoesNotExist:
                continue

        for card_id in certification_doc_removed:
            try:
                certification = TeachingCertificate.objects.get(id=card_id, user=user)
                if certification.document:
                    certification.document.delete(save=False)
                    certification.document = None
                    certification.save()
            except TeachingCertificate.DoesNotExist:
                continue

        # ===== 3. PROCESS EDUCATION ENTRIES =====
        saved_educations = []
        education_ids = request.POST.getlist('education_ids[]')
        degrees = request.POST.getlist('degrees[]')
        fields = request.POST.getlist('fields[]')
        institutions = request.POST.getlist('institutions[]')
        start_years = request.POST.getlist('start_years[]')
        end_years = request.POST.getlist('end_years[]')
        descriptions = request.POST.getlist('descriptions[]')

        for i in range(len(education_ids)):
            card_id = education_ids[i]
            try:
                degree = DegreeLevel.objects.get(id=degrees[i])
                start_year = int(start_years[i])
                end_year = int(end_years[i])

                # Validate years
                if start_year < 1900 or start_year > max_year or end_year < 1900 or end_year > max_year:
                    raise ValueError(f"Invalid year for education entry {i + 1}")
                if end_year < start_year:
                    raise ValueError(f"Graduation year must be >= start year for education entry {i + 1}")

                if card_id in education_new:
                    # Create new education
                    education = UserEducation(
                        user=user,
                        degree=degree,
                        field_of_study=fields[i],
                        institution=institutions[i],
                        start_year=start_year,
                        end_year=end_year,
                        description=descriptions[i],
                        status='pending'
                    )
                else:
                    # Update existing education
                    education = UserEducation.objects.get(id=card_id, user=user)
                    education.degree = degree
                    education.field_of_study = fields[i]
                    education.institution = institutions[i]
                    education.start_year = start_year
                    education.end_year = end_year
                    education.description = descriptions[i]
                    education.status = 'pending'

                # Handle document upload - only process if file was actually uploaded
                file_key = f'education_doc_{card_id}'
                if file_key in request.FILES:
                    file = request.FILES[file_key]
                    if file.name.split('.')[-1].lower() in allowed_extensions:
                        if education.document:  # Remove existing file first
                            education.document.delete(save=False)
                        education.document = file

                education.save()
                saved_educations.append(education.id)

            except (DegreeLevel.DoesNotExist, UserEducation.DoesNotExist, ValueError) as e:
                print(f"Error processing education {i + 1}: {str(e)}")
                continue

        # ===== 4. PROCESS CERTIFICATION ENTRIES =====
        saved_certifications = []
        certification_ids = request.POST.getlist('certification_ids[]')
        cert_names = request.POST.getlist('cert_names[]')
        cert_orgs = request.POST.getlist('cert_orgs[]')
        cert_years = request.POST.getlist('cert_years[]')

        for i in range(len(certification_ids)):
            card_id = certification_ids[i]
            try:
                cert_year = int(cert_years[i])
                if cert_year < 1900 or cert_year > max_year:
                    raise ValueError(f"Invalid year for certification entry {i + 1}")

                if card_id in certification_new:
                    # Create new certification
                    certification = TeachingCertificate(
                        user=user,
                        name=cert_names[i],
                        issuing_organization=cert_orgs[i],
                        completion_date=cert_year,
                        is_certified=False
                    )
                else:
                    # Update existing certification
                    certification = TeachingCertificate.objects.get(id=card_id, user=user)
                    certification.name = cert_names[i]
                    certification.issuing_organization = cert_orgs[i]
                    certification.completion_date = cert_year
                    certification.is_certified = False

                # Handle document upload
                file_key = f'certification_doc_{card_id}'
                if file_key in request.FILES:
                    file = request.FILES[file_key]
                    if file.name.split('.')[-1].lower() in allowed_extensions:
                        if certification.document:  # Remove existing file first
                            certification.document.delete(save=False)
                        certification.document = file

                certification.save()
                saved_certifications.append(certification.id)

            except (TeachingCertificate.DoesNotExist, ValueError) as e:
                print(f"Error processing certification {i + 1}: {str(e)}")
                continue

        # Update application status
        # ProviderApplication.objects.filter(user=user).update(status='added_edu')
        Tutor.objects.filter(profile__user=user).update(status='added_edu')

        return JsonResponse({
            'success': True,
            'message': 'Education and certification data saved successfully',
            'saved_educations': saved_educations,
            'saved_certifications': saved_certifications
        })

    except Exception as e:
        print(f"Error in save_educations: {str(e)}")
        return JsonResponse({
            'success': False,
            'error': str(e),
            'traceback': traceback.format_exc() if settings.DEBUG else None
        }, status=500)


@require_POST
@csrf_exempt
def submit_profile(request):
    user = request.user
    try:
        user_profile = UserProfile.objects.get(user=user)
        tutor = Tutor.objects.get(profile=user_profile)
    except (UserProfile.DoesNotExist, Tutor.DoesNotExist) as e:
        print(f"Profile lookup error: {str(e)}")  # Debug logging
        return JsonResponse({'success': False, 'errors': {'__all__': 'User profile not found'}}, status=400)

    if request.method == 'POST':
        form = ProfileBasicForm(request.POST, request.FILES,
                                user_instance=user,
                                profile_instance=user_profile,
                                # tutor_instance=tutor
                                )
        print("Form data received:", request.POST)  # Check what's actually being submitted
        print("Initial data:", form.initial)  # Check initial values
        if form.is_valid():
            try:
                # Process the form ---------------------------------
                print("Cleaned data:", form.cleaned_data)  # Check after validation

                user_profile.phone_country_code = form.cleaned_data['phone_country_code']
                user_profile.phone_number = form.cleaned_data['phone_number']

                # If phone was changed, reset verification status
                if (user_profile.phone_country_code != form.initial.get('phone_country_code') or
                        user_profile.phone_number != form.initial.get('phone_number')):
                    user_profile.phone_verified = False
                    user_profile.phone_verification_sent_at = None

                user_profile.save()

                # ... rest of your processing -----------------------

                # Debug: Print cleaned data before saving
                print(f"Form cleaned data: {form.cleaned_data}")

                # Save the form
                # saved_user, saved_profile, saved_tutor = form.save(user)
                saved_user, saved_profile = form.save(user)

                # Debug: Print saved objects
                print(f"Saved user: {saved_user}")
                print(f"Saved profile: {saved_profile}")
                # print(f"Saved tutor: {saved_tutor}")

                # Update applicant status
                # applicant = ProviderApplication.objects.get(user=user)
                applicant = Tutor.objects.get(profile__user=user)
                applicant.status = 'completed_profile'
                applicant.save()

                return JsonResponse({
                    'success': True,
                    'message': 'Profile updated successfully'
                })

            except Exception as e:
                # Get the complete traceback
                import traceback
                error_trace = traceback.format_exc()
                print(f"Error during save: {str(e)}\n{error_trace}")  # Detailed error logging

                return JsonResponse({'success': False, 'errors': {'__all__': str(e)},
                                     'traceback': error_trace  # Include in development only
                                     }, status=400)

        else:
            # Print form errors for debugging
            print(f"Form errors: {form.errors}")

            errors = {}
            for field in form.errors:
                errors[field] = form.errors[field][0]

            return JsonResponse({'success': False, 'errors': errors}, status=400)
    else:
        initial = {}
        if hasattr(request.user, 'userprofile'):
            profile = request.user.userprofile
            initial.update({
                'phone_country_code': profile.phone_country_code,
                'phone_number': profile.phone_number,
            })

        form = ProfileBasicForm(initial=initial,
                                user_instance=request.user,
                                profile_instance=getattr(request.user, 'userprofile', None))


@require_POST
@csrf_exempt
def submit_teaching_method(request):
    user = request.user
    try:
        user_profile = UserProfile.objects.get(user=user)
    except (UserProfile.DoesNotExist, Tutor.DoesNotExist) as e:
        return JsonResponse({'success': False, 'errors': {'__all__': 'User profile not found'}}, status=400)

    if request.method == 'POST':
        form = LocationForm(request.POST, user_instance=user, profile_instance=user_profile)
        # print("Form data received:", request.POST)  # Check what's actually being submitted
        # print("Initial data:", form.initial)  # Check initial values
        if form.is_valid():
            try:
                # Process the form ---------------------------------
                print("Cleaned data:", form.cleaned_data)  # Check after validation

                # user_profile.phone_country_code = form.cleaned_data['phone_country_code']
                # user_profile.phone_number = form.cleaned_data['phone_number']
                #
                # # If phone was changed, reset verification status
                # if (user_profile.phone_country_code != form.initial.get('phone_country_code') or
                #         user_profile.phone_number != form.initial.get('phone_number')):
                #     user_profile.phone_verified = False
                #     user_profile.phone_verification_sent_at = None

                user_profile.save()

                # Save the form
                saved_user, saved_profile = form.save(user)

                # Debug: Print saved objects
                print(f"Saved user: {saved_user}")
                print(f"Saved profile: {saved_profile}")
                # print(f"Saved tutor: {saved_tutor}")

                # Update applicant status
                # applicant = ProviderApplication.objects.get(user=user)
                applicant = Tutor.objects.get(profile__user=user)
                applicant.status = 'added_method'
                applicant.save()

                return JsonResponse({
                    'success': True,
                    'message': 'Teaching methods updated successfully'
                })

            except Exception as e:
                # Get the complete traceback
                import traceback
                error_trace = traceback.format_exc()
                print(f"Error during save: {str(e)}\n{error_trace}")  # Detailed error logging

                return JsonResponse({'success': False, 'errors': {'__all__': str(e)},
                                     'traceback': error_trace  # Include in development only
                                     }, status=400)

        else:
            errors = {}
            for field in form.errors:
                errors[field] = form.errors[field][0]

            return JsonResponse({'success': False, 'errors': errors}, status=400)
    else:
        initial = {}
        if hasattr(request.user, 'profile'):
            profile = request.user.profile
            initial.update({
                'phone_country_code': profile.phone_country_code,
                'phone_number': profile.phone_number,
            })

        form = LocationForm(initial=initial,
                            user_instance=request.user,
                            profile_instance=getattr(request.user, 'profile', None))


@require_POST
@csrf_exempt
def submit_edu(request):
    user = request.user
    try:
        user_profile = UserProfile.objects.get(user=user)
        tutor = Tutor.objects.get(profile=user_profile)
    except (UserProfile.DoesNotExist, Tutor.DoesNotExist) as e:
        print(f"Profile lookup error: {str(e)}")  # Debug logging
        return JsonResponse({
            'success': False,
            'errors': {'__all__': 'User profile not found'}
        }, status=400)

    form = ProfileBasicForm(
        request.POST,
        request.FILES,
        user_instance=user,
        profile_instance=user_profile,
        # tutor_instance=tutor
    )

    if form.is_valid():
        try:
            # Debug: Print cleaned data before saving
            print(f"Form cleaned data: {form.cleaned_data}")

            # Save the form
            # saved_user, saved_profile, saved_tutor = form.save(user)
            saved_user, saved_profile = form.save(user)

            # Debug: Print saved objects
            print(f"Saved user: {saved_user}")
            print(f"Saved profile: {saved_profile}")
            # print(f"Saved provider: {saved_tutor}")

            # Update applicant status
            # applicant = ProviderApplication.objects.get(user=user)
            applicant = Tutor.objects.get(profile__user=user)
            applicant.status = 'completed_profile'
            applicant.save()

            return JsonResponse({
                'success': True,
                'message': 'Profile updated successfully'
            })

        except Exception as e:
            # Get the complete traceback
            import traceback
            error_trace = traceback.format_exc()
            print(f"Error during save: {str(e)}\n{error_trace}")  # Detailed error logging

            return JsonResponse({
                'success': False,
                'errors': {'__all__': str(e)},
                'traceback': error_trace  # Include in development only
            }, status=400)
    else:
        # Print form errors for debugging
        print(f"Form errors: {form.errors}")

        errors = {}
        for field in form.errors:
            errors[field] = form.errors[field][0]

        return JsonResponse({
            'success': False,
            'errors': errors
        }, status=400)


@require_POST
@csrf_exempt
def submit_form_skill(request):
    user = request.user
    try:
        user_profile = UserProfile.objects.get(user=user)
        tutor = Tutor.objects.get(profile=user_profile)
    except (UserProfile.DoesNotExist, Tutor.DoesNotExist) as e:
        return JsonResponse({
            'success': False,
            'errors': {'__all__': 'User profile not found'}
        }, status=400)

    form = CombinedProfileForm(
        request.POST,
        request.FILES,
        user_instance=user,
        profile_instance=user_profile,
        tutor_instance=tutor
    )

    if form.is_valid():
        try:
            form.save(user)
            # change applicant status to complete_profile
            # applicant = ProviderApplication.objects.get(user=user)
            applicant = Tutor.objects.get(profile__user=user)
            applicant.status = 'completed_profile'
            applicant.save()
            return JsonResponse({
                'success': True,
                'message': 'Profile updated successfully'
            })
        except Exception as e:
            return JsonResponse({
                'success': False,
                'errors': {'__all__': str(e)}
            }, status=400)

    # Return form errors
    errors = {}
    for field in form.errors:
        errors[field] = form.errors[field][0]

    return JsonResponse({
        'success': False,
        'errors': errors
    }, status=400)


def wizard_submit_final(request):
    if request.method == 'POST':
        form = AgreementForm(request.POST, instance=request.user.profile)
        if form.is_valid():
            form.save()
            # applicant = ProviderApplication.objects.get(user=request.user)
            applicant = Tutor.objects.get(profile__user=request.user)
            applicant.status = 'decision'

            # Get and store the applicant's IP address
            x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
            if x_forwarded_for:
                ip = x_forwarded_for.split(',')[0]
            else:
                ip = request.META.get('REMOTE_ADDR')
            applicant.location_ip = ip

            applicant.save()
            return redirect('provider:dp_wizard_result')
    else:
        form = AgreementForm(instance=request.user.profile)
    return render(request, 'ap2_tutor/wizard/dp_wizard.html', {'form': form})


class DPWizardResult(LoginRequiredMixin, EmailVerificationRequiredMixin, RoleRequiredMixin, TemplateView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/wizard/includes/result.html'  # change and adapt this to dashboard panel of Tutor

    def dispatch(self, request, *args, **kwargs):
        if request.user.profile.tutor_profile.status not in ['decision', 'accepted', 'rejected']:
            return redirect('provider:dp_wizard')
        return super().dispatch(request, *args, **kwargs)


class DPWizardTest(TemplateView, RoleRequiredMixin):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/inp_test.html'  # change and adapt this to dashboard panel of Tutor


class SuccessSubmit(TemplateView, RoleRequiredMixin):
    allowed_roles = ['tutor']
    template_name = 'ap2_meeting/success_submit.html'  # change and adapt this to dashboard panel of Tutor

    # send email to 1.Applicant 2.Interviewer 3.Admin

    # Send acceptance email with registration link
    # subject = f"🙌 Dear {full_name}, Thanks for Applying! Our Team Will Reach Out Soon."
    # to_email = [email]
    # template_name = 'emails/interview/tutor_request_pending'
    # context = {
    #     'full_name': full_name,
    #     'email': email,
    #     'phone': phone,
    #     'bio': bio,
    #     'photo': photo,
    #     'resume_file': resume_file,
    #     'site_name': settings.SITE_NAME,
    # }
    # # this email sends to the applicant to know they should follow up.
    # send_dual_email(subject, template_name, context, to_email)
    #
    # notify_subject = f"New Tutor Request from {full_name}"
    # notification_email_to_admin(notify_subject, 'emails/admin/notify_admin', context)

    # change the applicant status to 'scheduled'
    # send Notification to them


# ====================================
# ==================================== WIZARD end ===================================

class DPSetting(LoginRequiredMixin, RoleRequiredMixin, EmailVerificationRequiredMixin, ActivationRequiredMixin,
                TemplateView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dp_setting.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # context['tutor'] = self.get_object()  # Get the current tutor object
        return context


class DPInPerson(LoginRequiredMixin, RoleRequiredMixin, EmailVerificationRequiredMixin, ActivationRequiredMixin,
                 FormView):
    allowed_roles = ['tutor']
    template_name = 'app_in_person/provider/dp_in_person_settings.html'
    form_class = LocationForm
    success_url = reverse_lazy('provider:dp_in_person')

    def get_form_kwargs(self):
        kwargs = super().get_form_kwargs()
        kwargs['user_instance'] = self.request.user
        kwargs['profile_instance'] = self.request.user.profile
        return kwargs

    def form_valid(self, form):
        messages.success(self.request, 'Your location info saved successfully.')
        form.save(self.request.user)
        return super().form_valid(form)

    def form_invalid(self, form):
        messages.error(self.request, 'Check your options, revise the form and save it again.')
        return super().form_invalid(form)


class DPDeleteAccount(LoginRequiredMixin, RoleRequiredMixin, EmailVerificationRequiredMixin, ActivationRequiredMixin,
                      DeleteView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dp_delete_account.html'
    model = Tutor  # Must CHECK !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


# --------------------------------- Archived ---------------------------------
class DPInterview(BasicProfile, RoleRequiredMixin, EmailVerificationRequiredMixin):
    allowed_roles = ['tutor']
    need_activation = False
    check_profile_activation = False  # No need to activation for interview (temp!!!)
    template_name = 'ap2_tutor/interview/dp_interview.html'
    success_url = reverse_lazy('provider:dp_interview')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # context['interviewerUId'] = User.objects.get(is_superuser=True).id
        user = self.request.user  # Get current user
        current_step = self._get_step(user)
        context['current_step'] = current_step
        print(f'now: {timezone.now()}')
        if current_step == 5:  # (scheduled = 5)
            session = Session.objects.filter(
                clients=user,
                session_type='interview'
            ).first()
            # interview_start_at

            applicant_tz = user.appointment_settings.timezone
            # Convert UTC to local time (timezone-aware in applicant's timezone)
            local_time = utc_to_local(session.start_session_utc, str(applicant_tz))
            context['interview_start_at'] = local_time.strftime("%B %d, %Y, %I:%M %p")
            context['applicant_tz'] = applicant_tz
            if (session and session.video_call_link and
                    timezone.now() >= (session.start_session_utc - timedelta(minutes=30))
            ):
                context['video_call_link'] = session.video_call_link

        if current_step >= 6:  # Decision(6), Accepted(7), Rejected(8)
            context['reviewer_comment'] = user.profile.tutor_profile.reviewer_comment
        else:
            context['reviewer_comment'] = ''
        user_profile = UserProfile.objects.filter(user__username='lucas').first()
        context['reviewerUId'] = user_profile.id
        context['subject'] = 'French Interview by Amin'
        context['session_cost'] = 100  # just for test | we get this from Tutor profile later
        context['currency'] = '€'  # € : alt + 0128
        context['session_type'] = 'interview'
        context['vat'] = 30
        context['discount'] = 10

        # context['providerSessionPeriod'] = user_profile.user.appointment_settings.session_length
        # context['maxSelectableSessions'] = 5  # for test !
        return context

    def _get_step(self, user):
        """This helper method returns stepper step (a number between 0 to 8) based on applicant status"""
        # stepper steps: (1.Primitive submit (Done), 2.Complete Profile, 3.Schedule interview, 4.Review and submit)
        # applicant_status = ProviderApplication.objects.get(user=user).status
        applicant_status = Tutor.objects.get(profile__user=user).status

        status_step_mapping = {
            'pending': 0,
            'invited': 0,
            'email_verified': 0,
            'registered': 2,  # go to step 2 (complete profile) in stepper
            'completed_profile': 3,  # go to step 3 (scheduling) in stepper
            'scheduled': 5,  # just show a page that you have completed all steps, wait for interview
            'decision': 6,  # just show a page that you have completed interview, wait for interviewer decision
            'accepted': 7,  # go to Tutor dashboard
            'rejected': 8,  # Block user access to panel or just an ERROR PAGE!
        }

        return status_step_mapping.get(applicant_status, 0)  # default to 0 if not found


def get_week_schedule(user, tz=None):
    # Get availability information
    available_rules = AvailableRule.objects.filter(user=user, is_available=True)
    try:
        user_timezone = user.appointment_settings.timezone
        session_length = user.appointment_settings.session_length
    except AttributeError:
        user_timezone = 'UTC'
        session_length = 2

    # Create week schedule data
    days_of_week = [
        {'id': '0', 'name': 'Sunday'},
        {'id': '1', 'name': 'Monday'},
        {'id': '2', 'name': 'Tuesday'},
        {'id': '3', 'name': 'Wednesday'},
        {'id': '4', 'name': 'Thursday'},
        {'id': '5', 'name': 'Friday'},
        {'id': '6', 'name': 'Saturday'},
    ]

    week_schedule = []
    total_available_days = 0
    total_time_slots = 0

    for day in days_of_week:
        day_rules = available_rules.filter(weekday=day['id'])
        time_slots = []

        for rule in day_rules:
            time_slots.append({
                'start_time': rule.start_time_utc,
                'end_time': rule.end_time_utc
            })
            total_time_slots += 1

        week_schedule.append({
            'id': day['id'],
            'name': day['name'],
            'available': len(time_slots) > 0,
            'time_slots': time_slots
        })

        if len(time_slots) > 0:
            total_available_days += 1

    return week_schedule;
