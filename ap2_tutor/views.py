from ap2_tutor.models import Tutor, SkillLevel, Skill
from django.views.generic import ListView, DetailView
from ap2_meeting.models import Review
from app_accounts.models import UserProfile
from django.db.models import Q

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
    paginate_by = 4  # Number of items per page

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
        tutorId = self.object.pk  # or self.kwargs['pk']

        context = super().get_context_data(**kwargs)
        context['range'] = range(1, 6)  # we use this for rating stars
        context['reviews'] = Review.objects.filter(tutor_id=tutorId)
        return context


class TutorReserveView(DetailView):
    model = Tutor
    template_name = 'ap2_tutor/tutor_reserve.html'
    context_object_name = 'tutor_single'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['range'] = range(1, 6)  # we use this for rating stars
        # context['minutes'] = ['00', '30']
        return context
