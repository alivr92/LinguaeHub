from django.shortcuts import render, redirect, get_object_or_404
from django.http import JsonResponse, HttpResponseForbidden
from django.views.decorators.http import require_POST
from django.contrib.auth.decorators import login_required
from django.views.decorators.csrf import csrf_exempt
from django.views.generic import View, TemplateView, ListView, DetailView, DeleteView, FormView
from django.urls import reverse_lazy
from django.utils.timezone import now
from django.utils import timezone
from datetime import timedelta
from django.conf import settings
from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from utils.mixins import RoleRequiredMixin, ActivationRequiredMixin, VIPRequiredMixin
from django.contrib.auth.models import User
from django.core.mail import send_mail, EmailMessage, EmailMultiAlternatives
from django.db.models import Count, Q

from decimal import Decimal

from utils.email import send_dual_email, notification_email_to_admin
from utils.converters import utc_to_local
from ap2_meeting.models import Review, Session
from ap2_tutor.models import ProviderApplication, Tutor
from app_accounts.models import UserProfile, Level, Skill, UserSkill
from .forms import ProviderApplicationForm, CombinedProfileForm, UserSkillForm, CombinedSkillForm
from ap2_meeting.forms import AppointmentSettingForm

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
    success_url = reverse_lazy('tutor:become_tutor')

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

        form.save()
        messages.success(self.request, "We received your application, please check your email (inbox, spam) "
                                       "in next 24 hours for invitation link")
        return super().form_valid(form)

    def form_invalid(self, form):
        messages.error(self.request, 'There is an error in sending message! please check the form fields')
        return self.render_to_response(self.get_context_data(form=form))


# this works well for attaching photo and resume to email
def send_formatted_email(full_name, email, phone, bio, photo, resume_file, admin_email):
    # Define the subject, body, and other details
    subject = f"{full_name} has sent his/her application."

    # HTML content
    html_content = f"""
        <html>
            <body style="font-family: Arial, sans-serif; line-height: 1.6; background-color: #f9f9f9; margin: 0; padding: 20px;">
                <div style="max-width: 600px; margin: auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); padding: 20px;">
                    <h2 style="color: #4CAF50; text-align: center;">New Tutor Application</h2>
                    <p style="font-size: 16px; color: #333;">Dear Admin,</p>
                    <p style="font-size: 16px; color: #333;">A new tutor application has been submitted. Here are the details:</p>
                    <table style="width: 100%; border-collapse: collapse; margin: 20px 0;">
                        <tr>
                            <td style="padding: 10px; border: 1px solid #ddd; font-weight: bold; color: #555;">Full Name:</td>
                            <td style="padding: 10px; border: 1px solid #ddd; color: #333;">{full_name}</td>
                        </tr>
                        <tr>
                            <td style="padding: 10px; border: 1px solid #ddd; font-weight: bold; color: #555;">Email:</td>
                            <td style="padding: 10px; border: 1px solid #ddd; color: #333;">{email}</td>
                        </tr>
                        <tr>
                            <td style="padding: 10px; border: 1px solid #ddd; font-weight: bold; color: #555;">Phone:</td>
                            <td style="padding: 10px; border: 1px solid #ddd; color: #333;">{phone}</td>
                        </tr>
                    </table>
                    <p style="font-size: 16px; color: #333;"><strong>Bio:</strong></p>
                    <p style="background-color: #f2f2f2; padding: 10px; border-radius: 5px; color: #333;">{bio}</p>
                    <p style="font-size: 16px; color: #333;">The applicant has also provided a photo and resume for your review. They are attached to this email.</p>
                    <p style="font-size: 16px; color: #333;">Best regards,<br>Your LMS Team</p>
                </div>
            </body>
        </html>
        """

    # Set up the email
    email_message = EmailMessage(
        subject,
        html_content,  # Message content
        settings.EMAIL_HOST_USER,  # From email
        [admin_email]  # To email
    )

    # Specify that the content is HTML
    email_message.content_subtype = 'html'

    # Attach the photo and resume files
    if photo:
        email_message.attach(photo.name, photo.read(), photo.content_type)
    if resume_file:
        email_message.attach(resume_file.name, resume_file.read(), resume_file.content_type)

    # Send the email
    email_message.send(fail_silently=False)


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

        sLevel = self.request.GET.get('sLevel')
        if sLevel:
            sLevel = sLevel.split(',')
            queryset = queryset.filter(skill_level__name__in=sLevel).distinct()

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
        context['reviews'] = Review.objects.filter(provider=tutor.profile.user, is_published=True).order_by(
            '-create_date')
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

        skill_ids = tutor.profile.user.skills.values_list('id', flat=True)
        if skill_ids:
            limit = 10
            # context['related_tutors'] = Tutor.objects.filter(skills__in=skill_ids).exclude(id=tutor.id).distinct()
            tutor_skills = UserSkill.objects.filter(user=tutor.profile.user).values_list('skill', flat=True)

            context['related_tutors'] = Tutor.objects.filter(profile__user__skills__skill__in=tutor_skills).exclude(
                id=tutor.id).distinct().annotate(shared_skills_count=Count('profile__user__skills__skill')).order_by(
                '-shared_skills_count')[:limit]
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
class DTHome(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, TemplateView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dt_home.html'

    # model = Session
    # paginate_by = 6

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['tutor'] = self.request.user.profile.tutor_profile
        # context['session_list'] = Session.objects.all()

        return context


class DTManageCourse(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, ListView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dt_manage_course.html'
    model = Tutor  # Must change to Course !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # ordering = ['-profile__create_date']
    paginate_by = 6

    # def get_queryset(self):
    #     # Assuming the logged-in user is a Tutor and you have a relationship between Tutor and UserProfile
    #     return Session.objects.filter(tutor__profile__user=self.request.user).order_by('-start_session_utc')


class DTQuiz(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, TemplateView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dt_quiz.html'


class DTEarning(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, ListView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dt_earning.html'
    model = Tutor  # Must change to Payment !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    paginate_by = 6


class DTOrder(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, ListView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dt_order.html'
    model = Tutor  # Must change to Order Payments !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    paginate_by = 6


class DTPayout(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, ListView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dt_payout.html'
    model = Tutor  # Must change to Order Payments !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    paginate_by = 6


class DTStudentList(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, ListView):
    allowed_roles = ['tutor']
    model = Session
    template_name = 'ap2_tutor/dashboard/dt_student_list.html'
    # ordering = ['-profile__create_date']
    paginate_by = 6

    def get_queryset(self):
        # Assuming the logged-in user is a Tutor and you have a relationship between Tutor and UserProfile
        return Session.objects.filter(tutor__profile__user=self.request.user).order_by('-start_session_utc')


class DTReviews(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, ListView):
    allowed_roles = ['tutor']
    model = Review
    template_name = 'ap2_tutor/dashboard/dt_review.html'
    # ordering = ['-last_modified']
    paginate_by = 6  # Number of items per page

    def get_queryset(self):
        # Assuming the logged-in user is a Tutor and you have a relationship between Tutor and UserProfile
        return Review.objects.filter(tutor__profile__user=self.request.user).order_by('-create_date')


class DTEditProfile(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, View):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dt_edit.html'
    success_url = reverse_lazy('tutor:dt_home')

    def get_context_data(self, **kwargs):
        user = self.request.user
        user_profile = UserProfile.objects.get(user=user)
        tutor = Tutor.objects.get(profile=user_profile)

        context = {
            'form': CombinedProfileForm(
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


class DTWizard(DTEditProfile, RoleRequiredMixin):
    allowed_roles = ['tutor']
    need_activation = False
    template_name = 'ap2_tutor/wizard/dt_wizard.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user

        current_step = self._get_step(user)
        context['current_step'] = current_step
        # Add UserSkillForm to context
        # context['skillForm'] = UserSkillForm(user=user)  # Pass user to the form
        context['skillForm'] = CombinedSkillForm(user=user)  # Pass user to the form
        context['AppointmentSettingForm'] = AppointmentSettingForm()

        # Get existing skills for display
        context['existing_skills'] = UserSkill.objects.filter(user=user)
        context['skills'] = Skill.objects.all()
        context['levels'] = Level.objects.all()
        context['applicantUId'] = user.id

        return context

    def _get_step(self, user):
        """This helper method returns stepper step (a number between 0 to 8) based on applicant status"""
        # stepper steps: (1.Primitive submit (Done), 2.Complete Profile, 3.Schedule interview, 4.Review and submit)
        applicant_status = ProviderApplication.objects.get(user=user).status

        status_step_mapping = {
            'pending': 0,
            'invited': 0,  # 1
            'registered': 2,  # go to step 2 (complete profile) in stepper
            'completed_profile': 3,  # go to step 4 (teaching skills) in stepper
            'completed_skills': 4,  # go to step 5 (decision) in stepper
            'decision': 5,  # just show a page that you have completed interview, wait for interviewer decision
            'accepted': 6,  # go to Tutor dashboard
            'rejected': 7,  # Block user access to panel or just an ERROR PAGE!
        }

        return status_step_mapping.get(applicant_status, 0)  # default to 0 if not found

    def post(self, request, *args, **kwargs):
        # Determine which form was submitted
        if 'submit_profile' in request.POST:
            return self.handle_profile_form(request)
        elif 'submit_skills' in request.POST:
            return self.handle_skills_form(request)
        return redirect(self.success_url)

    def handle_profile_form(self, request):
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
            # Update application status to 'completed_profile'
            application = ProviderApplication.objects.get(user=user)
            application.status = 'completed_profile'
            application.save()

            messages.success(request, 'Profile information saved successfully!')
            return redirect('tutor:dt_wizard')

        context = self.get_context_data(form=form)
        return render(request, self.template_name, context)

    def handle_skills_form(self, request):
        user = request.user
        form = UserSkillForm(request.POST, request.FILES, user=user)

        if form.is_valid():
            skill = form.save(commit=False)
            skill.user = user
            skill.save()

            # Update application status to 'completed_skills'
            application = ProviderApplication.objects.get(user=user)
            application.status = 'completed_skills'
            application.save()

            messages.success(request, 'Skill information saved successfully!')
            return redirect('tutor:dt_wizard')

        context = self.get_context_data(skillForm=form)
        return render(request, self.template_name, context)


@login_required
def get_existed_skills(request):
    # Get and validate user ID parameter
    applicantUId = request.GET.get('applicantUId')
    if not applicantUId or not applicantUId.isdigit():
        return JsonResponse({'status': 'error', 'message': 'Invalid user ID format'},status=400)

    try:
        # Check if user exists
        try:
            applicantUser = User.objects.get(id=int(applicantUId))
        except User.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': 'User does not exist'}, status=404)

        # applicant user MUST be same as logged in user
        # Verify authorization (user can only access their own data)
        if applicantUser != request.user:
            return JsonResponse({'status': 'error', 'message': 'Forbidden Access: You can only access your own data'}, status=403)

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


def save_skills(request):
    video_allowed_extensions = ['mp4', 'ts']
    certificate_allowed_extensions = ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg']
    if request.method == 'POST' and request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        try:
            # Get current user and tutor profile
            user = request.user
            tutor = user.profile.tutor_profile

            # Process video intro
            video_intro = request.FILES.get('video_intro')
            if video_intro:
                tutor.video_intro = video_intro
                tutor.save()

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

            # Validate video intro
            if not video_intro:
                return JsonResponse({'error': 'Introduction video is required'}, status=400)

            if not validate_file_extension(video_intro.name, video_allowed_extensions):
                return JsonResponse({'error': f'Invalid video format. Only {video_allowed_extensions} allowed.'},
                                    status=400)

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
                                    'error': f'Invalid video format for skill {i+1}. Only {video_allowed_extensions} are allowed.'},
                                status=400)

                    # Validate certificate if exists
                    if i < len(certificates):
                        if not validate_file_extension(certificates[i].name, certificate_allowed_extensions):
                            return JsonResponse({'error': f'Invalid certificate format for skill {i+1}'}, status=400)

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
                    applicant = ProviderApplication.objects.get(user=user)
                    applicant.status = 'decision'  # after added skills we need to decide
                    applicant.save()
                    print(f'applicant status updated! {applicant.status}')


                except (Skill.DoesNotExist, Level.DoesNotExist):
                    return JsonResponse({'error': f'Invalid skill or level for row {i+1}'}, status=400)

            # Process data (same as before)
            # ... your save logic ...

            # return JsonResponse({'success': True})
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


def validate_file_extension(filename, allowed_extensions):
    extension = filename.split('.')[-1].lower()
    return extension in allowed_extensions


class DTWizard_1(DTEditProfile, RoleRequiredMixin):
    allowed_roles = ['tutor']
    need_activation = False
    check_profile_activation = False  # No need to activation for interview (temp!!!)
    template_name = 'ap2_tutor/wizard/dt_wizard.html'
    success_url = reverse_lazy('tutor:dt_wizard')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # context['interviewerUId'] = User.objects.get(is_superuser=True).id
        user = self.request.user  # Get current user
        current_step = self._get_step(user)
        context['current_step'] = current_step
        # context['skillForm'] = UserSkillForm

        if current_step >= 5:  # Decision(6), Accepted(7), Rejected(8)
            context['reviewer_comment'] = user.provider_application.interviewer_comment
        else:
            context['reviewer_comment'] = ''
        user_profile = UserProfile.objects.filter(user__username='lucas').first()
        context['interviewerUId'] = user_profile.id
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
        applicant_status = ProviderApplication.objects.get(user=user).status

        status_step_mapping = {
            'pending': 0,
            'invited': 0,  # 1
            'registered': 2,  # go to step 2 (complete profile) in stepper
            'completed_profile': 3,  # go to step 4 (teaching skills) in stepper
            'completed_skills': 4,  # go to step 5 (decision) in stepper
            'decision': 5,  # just show a page that you have completed interview, wait for interviewer decision
            'accepted': 6,  # go to Tutor dashboard
            'rejected': 7,  # Block user access to panel or just an ERROR PAGE!
        }

        return status_step_mapping.get(applicant_status, 0)  # default to 0 if not found


@require_POST
@csrf_exempt
def submit_form_profile(request):
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
            applicant = ProviderApplication.objects.get(user=user)
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
            applicant = ProviderApplication.objects.get(user=user)
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


class DTSetting(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, TemplateView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dt_setting.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # context['tutor'] = self.get_object()  # Get the current tutor object
        return context


class DTDeleteAccount(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, DeleteView):
    allowed_roles = ['tutor']
    template_name = 'ap2_tutor/dashboard/dt_delete_account.html'
    model = Tutor  # Must CHECK !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


class DInterview(DTEditProfile, RoleRequiredMixin):
    allowed_roles = ['tutor']
    need_activation = False
    check_profile_activation = False  # No need to activation for interview (temp!!!)
    template_name = 'ap2_tutor/interview/dt_wizard.html'
    success_url = reverse_lazy('tutor:dt_wizard')

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

            applicant_tz = user.provider_application.timezone
            # Convert UTC to local time (timezone-aware in applicant's timezone)
            local_time = utc_to_local(session.start_session_utc, str(applicant_tz))
            context['interview_start_at'] = local_time.strftime("%B %d, %Y, %I:%M %p")
            context['applicant_tz'] = applicant_tz
            if (session and session.video_call_link and
                    timezone.now() >= (session.start_session_utc - timedelta(minutes=30))
            ):
                context['video_call_link'] = session.video_call_link

        if current_step >= 6:  # Decision(6), Accepted(7), Rejected(8)
            context['interviewer_comment'] = user.provider_application.interviewer_comment
        else:
            context['interviewer_comment'] = ''
        user_profile = UserProfile.objects.filter(user__username='lucas').first()
        context['interviewerUId'] = user_profile.id
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
        applicant_status = ProviderApplication.objects.get(user=user).status

        status_step_mapping = {
            'pending': 0,
            'invited': 0,
            'registered': 2,  # go to step 2 (complete profile) in stepper
            'completed_profile': 3,  # go to step 3 (scheduling) in stepper
            'scheduled': 5,  # just show a page that you have completed all steps, wait for interview
            'decision': 6,  # just show a page that you have completed interview, wait for interviewer decision
            'accepted': 7,  # go to Tutor dashboard
            'rejected': 8,  # Block user access to panel or just an ERROR PAGE!
        }

        return status_step_mapping.get(applicant_status, 0)  # default to 0 if not found
