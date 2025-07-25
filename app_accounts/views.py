from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse, reverse_lazy
from django.http import HttpResponseForbidden
from django.contrib import messages, auth
from django.contrib.auth import authenticate, login
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User, Group
from django.utils import timezone
from datetime import datetime, timedelta
from django.utils.crypto import get_random_string
from app_accounts.models import UserProfile, UserConsentLog, LoginIPLog
from ap2_tutor.models import Tutor, ProviderApplication
from ap2_student.models import Student
from app_staff.models import Staff
from app_admin.models import AdminProfile
from django.views.generic import View, CreateView, ListView, TemplateView
from .forms import RegistrationForm
from utils.pages import error_page
from utils.email import send_activation_email
from utils.trackers import get_client_ip, get_geo_data
from django.db import transaction


class SignInView(View):
    template_name = 'app_accounts/sign-in.html'

    def get(self, request, *args, **kwargs):
        context = {}
        return render(request, self.template_name, context)

    def post(self, request, *args, **kwargs):
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(username=username, password=password)

        if user is not None:
            login(request, user)
            messages.success(request, "You are successfully logged in. Welcome!")
            log_user_login(request, user)
            return redirect('accounts:dashboard')
        else:
            messages.error(request, 'Invalid login credentials!')
            return redirect('accounts:sign_in')


class ForgetPassword(TemplateView):
    template_name = 'app_accounts/forgot-password.html'


class SignUpView2(View):
    template_name = 'app_accounts/sign_up.html'

    def get(self, request, *args, **kwargs):
        context = {}
        return render(request, self.template_name, context)

    def post(self, request, *args, **kwargs):
        first_name = request.POST['first_name']
        last_name = request.POST['last_name']
        username = request.POST['username']
        email = request.POST['email']
        password = request.POST['password']
        password_confirm = request.POST['password_confirm']

        if User.objects.filter(username=username).exists():
            messages.error(request, "Sorry, This username has been registered before! Try another one!")
            return redirect('accounts:sign_up')
        elif User.objects.filter(email=email).exists():
            messages.error(request, "Sorry, This email address has been registered before! Try another one!")
            return redirect('accounts:sign_up')
        elif password != password_confirm:
            messages.error(request, "Check your passwords! They must be the same!")
            return redirect('accounts:sign_up')
        else:
            user = User.objects.create_user(email=email, username=username, password=password,
                                            first_name=first_name, last_name=last_name)
            user.save()
            messages.success(request, "Congratulations! You registered successfully. Now login for the first time!")
            return redirect('accounts:sign_in')


class RegistrationMixin:
    model = User
    form_class = RegistrationForm
    success_url = reverse_lazy('accounts:dashboard')

    # Add token validation flag
    require_valid_token = False

    def dispatch(self, request, *args, **kwargs):
        # If this view requires token validation
        if self.require_valid_token:
            self.token = request.GET.get('token')
            if not self.token:
                err_title = f"Invite Required"
                err_msg = f"You need a valid invitation to be able to access to this page!"
                messages.error(self.request, err_msg)
                return error_page(request, err_title, err_msg, 403)
                # return redirect('accounts:error_invite_required')  # Or show error page

            try:
                self.applicant = ProviderApplication.objects.get(invitation_token=self.token)
            except ProviderApplication.DoesNotExist:
                err_title = f"Invalid Invite"
                err_msg = f"This link is either invalid or does not belong to any application."
                messages.error(self.request, err_msg)
                return error_page(request, err_title, err_msg, 403)
                # return redirect('accounts:error_invalid_invite')

            if self.applicant.token_expiry and self.applicant.token_expiry < timezone.now():
                err_title = f"Expired Invite"
                err_msg = f"This registration link has expired. Please request a new invitation."
                messages.error(self.request, err_msg)
                return error_page(request, err_title, err_msg, 403)
                # return redirect('accounts:error_expired_invite')

            if self.applicant.user:
                err_title = f"Already Registered"
                err_msg = f"You have registered before with this Invitation Link"
                messages.error(self.request, err_msg)
                return error_page(request, err_title, err_msg, 403)
                # return redirect('accounts:error_already_registered')

        return super().dispatch(request, *args, **kwargs)

    def get_form_kwargs(self):
        kwargs = super().get_form_kwargs()
        if hasattr(self, 'applicant'):
            kwargs['applicant'] = self.applicant
        return kwargs

    def form_valid(self, form):
        try:
            with transaction.atomic():
                user = form.save()

                # Get or create profile to prevent duplicates
                profile, created = UserProfile.objects.get_or_create(
                    user=user,
                    defaults={'user_type': self.user_type}
                )

                if not created:
                    # Profile already existed, update it
                    profile.user_type = self.user_type
                    profile.save()

                # Set additional profile fields
                profile.terms_agreed = form.cleaned_data['terms_agreed']
                profile.terms_agreed_date = timezone.now()
                profile.email_consent = form.cleaned_data['email_consent']
                profile.email_consent_date = timezone.now() if form.cleaned_data['email_consent'] else None

                # Get and store the user's IP address
                save_user_consent(self.request, user, 'terms', 'v1.2')

                profile.save()

                # Rest of your role-specific logic...

                if self.user_type == 'student':
                    Student.objects.get_or_create(profile=profile)
                    # profile.is_active = True
                    # profile.save()
                    # Generate activation token (valid for 24 hours or 1 day)
                    profile.activation_token = get_random_string(64)
                    profile.token_expiry = timezone.now() + timedelta(days=1)  # 24 hours

                    # Build the activation URL
                    activation_url = self.request.build_absolute_uri(
                        reverse('student:ds_home') + f'?token={profile.activation_token}')
                    # Send acceptance email with registration link
                    send_activation_email(self.request, user, activation_url)


                elif self.user_type == 'tutor':
                    Tutor.objects.get_or_create(profile=profile)
                    if hasattr(self, 'applicant'):
                        self._link_applicant_to_user(user)
                        self._transfer_applicant_data(user, profile)
                        self.applicant.status = 'registered'
                        self.applicant.save()

                elif self.user_type == 'staff':
                    Staff.objects.get_or_create(profile=profile)
                elif self.user_type == 'admin':
                    AdminProfile.objects.get_or_create(profile=profile)

                messages.success(self.request, "Registration successful!")
                login(self.request, user)
                return super().form_valid(form)

        except Exception as e:
            messages.error(self.request, f"Registration failed: {str(e)}")
            return self.form_invalid(form)

    def _create_role_profile(self, profile):
        """Create role-specific profile (Tutor/Student/etc)"""
        role_map = {
            'student': Student,
            'tutor': Tutor,
            'staff': Staff,
            'admin': AdminProfile,
        }
        if self.user_type in role_map:
            role_map[self.user_type].objects.create(profile=profile)

    def _link_applicant_to_user(self, user):
        """Link ProviderApplication to the new user"""
        self.applicant.user = user
        self.applicant.invitation_token = None  # Invalidate token
        self.applicant.token_expiry = None

    def _transfer_applicant_data(self, user, profile):
        """Transfer any additional data from application to profile"""
        user.first_name = self.applicant.first_name
        user.last_name = self.applicant.last_name
        user.save()

        profile.phone = self.applicant.phone
        profile.bio = self.applicant.bio

        if hasattr(self.applicant, 'photo') and self.applicant.photo:
            profile.photo.save(
                f"profile_{user.id}_{self.applicant.photo.name}",
                self.applicant.photo.file
            )
        profile.save()


class SignUpStudent(RegistrationMixin, CreateView):
    template_name = 'app_accounts/sign_up.html'
    user_type = 'student'
    require_valid_token = False  # Open registration for students

    def form_invalid(self, form):
        messages.error(self.request, "Please correct the errors below.")
        return self.render_to_response(self.get_context_data(form=form))


class SignUpTutor(RegistrationMixin, CreateView):
    template_name = 'app_accounts/sign_up_tutor.html'
    user_type = 'tutor'
    require_valid_token = True  # Requires valid token for tutors
    success_url = reverse_lazy('tutor:dt_wizard')  # success url for the first time for tutors goes to pre-interview!

    def get_success_url(self):
        # Ensure token is preserved even after success
        return f"{super().get_success_url()}?token={self.token}"

    def form_invalid(self, form):
        for error in form.errors.values():
            messages.error(self.request, str(error))

        # Method 1: Preserve entire original URL (including token)
        return self.render_to_response(
            self.get_context_data(
                form=form,
                token=self.token  # Explicitly pass token
            )
        )

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        if hasattr(self, 'token'):
            context['token'] = self.token
        return context


class SignUpStaff(RegistrationMixin, CreateView):
    template_name = 'app_accounts/sign_up_staff.html'
    user_type = 'staff'
    require_valid_token = True  # Requires valid token for staffs


class SignUpAdmin(RegistrationMixin, CreateView):
    template_name = 'app_accounts/sign_up_admin.html'
    user_type = 'admin'
    require_valid_token = True  # Requires valid token for admins


@login_required
def sign_out(request):
    auth.logout(request)
    return redirect('app_pages:home')


# def sign_up(request):
#     if request.method == 'POST':
#         first_name = request.POST['first_name']
#         last_name = request.POST['last_name']
#         username = request.POST['username']
#         email = request.POST['email']
#         password = request.POST['password']
#         password_confirm = request.POST['password_confirm']
#
#         if User.objects.filter(username=username).exists():
#             messages.error(request, "Sorry, This username has been registered before! Try another one!")
#             return redirect('accounts:sign_up')
#         elif User.objects.filter(email=email).exists():
#             messages.error(request, "Sorry, This email address has been registered before! Try another one!")
#             return redirect('app_accounts:sign_up')
#         elif password != password_confirm:
#             messages.error(request, "Check your passwords! They must be the same!")
#             return redirect('app_accounts:sign_up')
#         else:
#             user = User.objects.create_user(email=email, username=username, password=password,
#                                             first_name=first_name, last_name=last_name)
#             user.save()
#             messages.success(request, "Congratulations! You registered successfully. Now login for the first time!")
#             return redirect('app_accounts:sign_in')
#     else:
#         context = {}
#         return render(request, 'app_accounts/sign-up.html', context)


@login_required
def dashboard(request):
    if not request.user.is_authenticated:
        return redirect('accounts:sign_in')
    user = request.user
    try:
        user_type = user.profile.user_type
    except AttributeError:
        UserProfile.objects.create(user=user, user_type='student')
        user_type = user.profile.user_type

    if user.is_superuser:
        return redirect('my_admin:da_home')
    elif user_type == 'staff':
        return redirect('staff:dstf_home')
    elif user_type == 'tutor':
        if user.profile.is_active:
            return redirect('tutor:dt_home')
        else:
            return redirect('tutor:dt_wizard')
    elif user_type == 'student':
        if user.profile.is_active:
            return redirect('student:ds_home')
        else:
            return redirect('student:activation_required')
    else:
        # Handle invalid or unexpected user_type (e.g., log an error)
        print(f"Invalid or unexpected user_type: {user_type}")
        return redirect('accounts:ds_home')


@login_required
def dashboardEdit(request, pk):
    if not request.user.is_authenticated:
        return redirect('accounts:sign_in')
    user = request.user

    if user.is_superuser:
        return redirect('my_admin:da_edit', pk)
    elif user.groups.filter(name='staff').exists():
        return redirect('staff:dstf_edit', pk)
    elif user.groups.filter(name='tutor').exists():
        return redirect('tutor:dt_edit', pk)
    elif user.groups.filter(name='student').exists():
        return redirect('student:ds_edit', pk)
    else:
        # Redirect to a default page or handle unauthenticated roles
        return redirect('student:ds_edit', pk)


# finally Here MUST CHECK FOR JUST TUTOR ACCESS NOT OTHERS!!!!


def save_user_consent(request, user, consent_type, version):
    ip = get_client_ip(request)
    geo = get_geo_data(ip)
    agent = request.META.get('HTTP_USER_AGENT', '')

    UserConsentLog.objects.create(
        user=user,
        consent_type=consent_type,
        consent_version=version,
        agreed=True,
        ip_address=ip,
        user_agent=agent,
        location_city=geo['city'],
        location_country=geo['country']
    )


def log_user_login(request, user):
    ip = get_client_ip(request)
    geo = get_geo_data(ip)
    agent = request.META.get('HTTP_USER_AGENT', '')

    is_new_ip = not LoginIPLog.objects.filter(user=user, ip_address=ip).exists()

    LoginIPLog.objects.create(
        user=user,
        ip_address=ip,
        user_agent=agent,
        location_city=geo['city'],
        location_country=geo['country'],
        is_new_ip=is_new_ip,
        is_flagged=is_new_ip  # You could add logic here to auto-flag or notify
    )
