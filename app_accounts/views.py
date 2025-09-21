from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse, reverse_lazy
from django.http import HttpResponseForbidden
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User, Group
from django.utils import timezone
from datetime import datetime, timedelta
from django.utils.crypto import get_random_string
from app_accounts.models import UserProfile, UserConsentLog, LoginIPLog, SecurityEvent
from ap2_tutor.models import Tutor, ProviderApplication
from ap2_student.models import Student
from app_marketing.models import Referral
from app_staff.models import Staff
from app_admin.models import AdminProfile
from django.views import View
from django.views.generic import CreateView, ListView, TemplateView
from .forms import RegistrationForm
from utils.pages import error_page
from utils.email import send_verification_email, send_reset_password_link
from utils.trackers import get_client_ip, get_geo_data
from utils.validators import validate_password_strength
from django.contrib.auth.mixins import LoginRequiredMixin
from utils.mixins import RoleRequiredMixin
from django.views.decorators.http import require_POST
from django.http import JsonResponse
from django.views.decorators.cache import never_cache
from django.db import transaction, IntegrityError
from django.views.decorators.csrf import csrf_protect
import re
from django.contrib.auth.password_validation import validate_password

from django.core.exceptions import MultipleObjectsReturned, ValidationError
from django.conf import settings
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from django.core.cache import cache

from django.contrib.auth.signals import user_login_failed
from django.dispatch import receiver
import logging

logger = logging.getLogger(__name__)
# ===========
import secrets
from django.core.exceptions import ObjectDoesNotExist


class SignInView(TemplateView):
    template_name = 'app_accounts/sign_in.html'

    def get(self, request):
        if request.user.is_authenticated:
            return redirect('accounts:dashboard')
        return render(request, self.template_name)

    def post(self, request):
        username = request.POST.get('username')
        password = request.POST.get('password')
        remember_me = request.POST.get('remember_me') == 'on'

        if not username or not password:
            messages.error(request, 'Both username and password are required')
            return redirect('accounts:sign_in')

        user = authenticate(request, username=username, password=password)
        print(f'user: {user}')
        print(f'password: {password}')

        if user is not None:
            login(request, user)

            # Set session expiry based on remember_me
            if remember_me:
                request.session.set_expiry(1209600)  # 2 weeks
            else:
                request.session.set_expiry(0)  # Browser session

            # messages.success(request, f"Welcome back, {user.username}!")
            messages.success(request, "You are successfully logged in. Welcome!")
            log_user_login(request, user)
            return redirect('accounts:dashboard')

        # messages.error(request, 'Invalid username or password')
        messages.error(request, 'Invalid login credentials!')
        return redirect('accounts:sign_in')


class RegistrationMixin_MAIN:
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

    # def get_form_kwargs(self):
    #     kwargs = super().get_form_kwargs()
    #     if hasattr(self, 'applicant'):
    #         kwargs['applicant'] = self.applicant
    #     return kwargs

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
                        reverse('client:dc_home') + f'?token={profile.activation_token}')
                    # Send acceptance email with registration link
                    send_verification_email(self.request, user, activation_url)


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


class RegistrationMixin:
    model = User
    form_class = RegistrationForm
    activation_required = True  # All users require activation
    success_url = reverse_lazy('accounts:dashboard')

    # referral_param = 'ref'  # Referral code URL parameter

    def dispatch(self, request, *args, **kwargs):
        # Common security checks
        if not request.session.session_key:
            request.session.create()

        # Rate limiting
        ip = get_client_ip(request)
        if self._is_rate_limited(ip):
            return HttpResponseForbidden("Too many attempts. Try again later.")

        return super().dispatch(request, *args, **kwargs)

    def _is_rate_limited(self, ip):
        cache_key = f'signup_attempts_{ip}'
        attempts = cache.get(cache_key, 0)
        if attempts >= settings.SIGNUP_ATTEMPTS:
            SecurityEvent.objects.create(
                event_type='ratelimit',
                ip_address=ip,
                path=self.request.path
            )
            return True
        cache.set(cache_key, attempts + 1, 3600)
        return False

    # ----------------------------------------------------
    def form_valid(self, form):
        """
        Handle valid form submission including reCAPTCHA verification
        """
        try:
            with transaction.atomic():
                user = form.save(commit=False)
                user_type = self._get_user_type()

                # Validate user_type before saving
                if user_type not in ['student', 'tutor', 'admin', 'staff']:
                    raise ValueError(f"Invalid user type: {user_type}")

                user.save()

                profile = self._create_user_profile(user, form, user_type)
                self._create_role_profile(profile)
                self._send_verification_email(user)
                # self._track_referral(user)

                # Login user
                login(self.request, user)

                messages.success(self.request,
                                 "Registration successful! Please check your email to activate your account.")
                return redirect(self.success_url)

        except IntegrityError as e:
            logger.error(f"Database error during registration: {str(e)}", exc_info=True)
            messages.error(
                self.request,
                "Account creation failed due to a system error. Please try again."
            )
        except ValueError as e:
            logger.error(f"Invalid user type: {str(e)}")
            messages.error(self.request, str(e))
        except Exception as e:
            logger.error(
                f"Registration failed for {form.cleaned_data.get('email')}: {str(e)}",
                exc_info=True
            )
            messages.error(
                self.request,
                "Registration failed due to an unexpected error. Please try again."
            )

        return self.form_invalid(form)

    def form_invalid(self, form):
        """
        Handle invalid form submission by re-rendering the form with errors
        """
        # Log form errors for debugging
        logger.warning(f"Form validation errors: {form.errors.as_json()}")

        # Add general error message if no field-specific messages exist
        if not any(form.errors):
            messages.error(self.request, "Please correct the errors below and try again.")

        # For AJAX requests, return JSON response
        if self.request.headers.get('x-requested-with') == 'XMLHttpRequest':
            return JsonResponse({
                'errors': form.errors.get_json_data(),
                'success': False
            }, status=400)

        # For regular requests, render the form again
        return self.render_to_response(self.get_context_data(form=form))

    # ----------------------------------------------------

    def form_valid_main_DELETE(self, form):
        try:
            with transaction.atomic():
                user = form.save(commit=False)
                user_type = self._get_user_type()
                # print(f'user type: {user_type}')

                # Validate user_type before saving
                if user_type not in ['student', 'tutor', 'admin', 'staff']:  # Add other valid types if needed
                    raise ValueError(f"Invalid user type: {user_type}")

                user.save()

                profile = self._create_user_profile(user, form, user_type)
                self._create_role_profile(profile)
                self._send_verification_email(user)
                # self._track_referral(user)

                login(self.request, user)

                messages.success(self.request,
                                 "Registration successful! Please check your email to activate your account.")
                # messages.success(self.request, self._get_success_message(profile))

                return redirect(self.success_url)

        except IntegrityError as e:
            logger.error(f"Database error during registration: {str(e)}")
            messages.error(self.request, "Account creation failed due to a system error. Please try again.")
            print('Error 1 !')
        except Exception as e:
            logger.error(f"Registration failed for {form.cleaned_data.get('email')}: {str(e)}", exc_info=True)
            messages.error(self.request, f"Registration failed: {str(e)}")
            print('Error 2 !')

        return self.form_invalid(form)

    def form_invalid_MAIN(self, form):
        if self.user_type == 'tutor':
            return redirect('accounts:sign_up_tutor')
        else:
            return redirect('accounts:sign_up')
        return super().form_invalid(form)

    def _get_user_type(self):
        # Priority: form data > view attribute
        return (self.request.POST.get('utype')
                or getattr(self, 'user_type', 'student'))

    def _create_user_profile(self, user, form, user_type):
        return UserProfile.objects.create(
            user=user,
            user_type=user_type,
            terms_agreed=form.cleaned_data['terms_agreed'],
            email_consent=form.cleaned_data['email_consent'],
            is_active=not self.activation_required
        )

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

    def _send_verification_email(self, user):
        """Generate and send activation email"""
        profile = user.profile
        profile.email_verification_token = get_random_string(64)
        profile.email_token_expiry = timezone.now() + timedelta(days=1)
        profile.save()

        verification_url = self.request.build_absolute_uri(
            reverse('accounts:verify_email') + f'?token={profile.email_verification_token}')

        send_verification_email(self.request, user, verification_url)

    def _track_referral(self, user):
        ref_code = self.request.GET.get(self.referral_param)
        if ref_code:
            Referral.objects.create(
                referrer=ref_code,
                referee=user,
                source=self.request.META.get('HTTP_REFERER', 'direct')
            )

    def _get_success_message(self, profile):
        if self.activation_required:
            return f"Please check your email to activate your {profile.get_user_type_display()} account"
        return "Registration successful!"


@method_decorator(csrf_protect, name='dispatch')
class SignUpStudent(RegistrationMixin, CreateView):
    template_name = 'app_accounts/sign_up.html'
    user_type = 'student'  # Default if not in form
    # success_url = reverse_lazy('accounts:dashboard')


@method_decorator(csrf_protect, name='dispatch')
class SignUpTutor(RegistrationMixin, CreateView):
    template_name = 'app_accounts/sign_up_tutor.html'
    user_type = 'tutor'

    # success_url = reverse_lazy('provider:dp_wizard')

    def form_invalid(self, form):
        logger.error(f"Tutor signup form errors: {form.errors.as_json()}")
        return super().form_invalid(form)


@method_decorator(csrf_protect, name='dispatch')
class SignUpStudent_WORKING(CreateView):
    model = User
    form_class = RegistrationForm
    template_name = 'app_accounts/sign_up.html'
    success_url = reverse_lazy('accounts:dashboard')

    def dispatch(self, request, *args, **kwargs):
        # Ensure session exists
        if not request.session.session_key:
            request.session.create()

        # Rate limiting by IP
        ip = get_client_ip(request)
        cache_key = f'signup_attempts_{ip}'
        attempts = cache.get(cache_key, 0)

        if attempts >= settings.SIGNUP_ATTEMPTS:  # Allow 10 attempts/hour
            SecurityEvent.objects.create(
                event_type='ratelimit',
                ip_address=ip,
                path=request.path,
                reason='Signup rate limit exceeded'
            )
            return HttpResponseForbidden("Too many signup attempts. Please try again in 1 hour.")

        cache.set(cache_key, attempts + 1, timeout=3600)  # 1 hour

        # Additional security check
        if request.method == 'POST' and not request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            referrer = request.META.get('HTTP_REFERER', '')
            if referrer and not any(
                    referrer.startswith(domain) or
                    referrer.startswith(domain.replace('https://', 'http://'))
                    for domain in settings.ALLOWED_DOMAINS
            ):
                SecurityEvent.objects.create(
                    event_type='csrf',
                    ip_address=get_client_ip(request),
                    path=request.path,
                    reason='Invalid referrer',
                    details={
                        'referrer': referrer,
                        'allowed_domains': settings.ALLOWED_DOMAINS
                    }
                )
                return HttpResponseForbidden("Invalid request origin")

        return super().dispatch(request, *args, **kwargs)

    def form_valid(self, form):
        try:
            with transaction.atomic():
                user = form.save(commit=False)
                user.save()

                # Create profile
                profile = UserProfile.objects.create(
                    user=user,
                    terms_agreed=form.cleaned_data['terms_agreed'],
                    email_consent=form.cleaned_data['email_consent'],
                    user_type='student',
                    is_active=False  # Require activation
                )

                # Send activation email
                self._send_verification_email(user)

                # Login user
                login(self.request, user)

                messages.success(self.request,
                                 "Registration successful! Please check your email to activate your account.")
                return redirect(self.success_url)

        except Exception as e:
            messages.error(self.request, f"Registration failed. Please try again. Error: {str(e)}")
            return self.form_invalid(form)

    def form_invalid(self, form):
        """Handle invalid form submission with detailed enhanced error messages."""
        for field, errors in form.errors.items():
            field_name = field.replace('_', ' ').title()
            for error in errors:
                messages.error(self.request, f"{field_name}: {error}")
        return super().form_invalid(form)

    def _send_verification_email(self, user):
        """Generate and send activation email"""
        profile = user.profile
        profile.activation_token = get_random_string(64)
        profile.token_expiry = timezone.now() + timedelta(days=1)
        profile.save()

        activation_url = self.request.build_absolute_uri(
            reverse('client:dc_home') + f'?token={profile.activation_token}')

        send_verification_email(self.request, user, activation_url)


class SignUpTutor_OLD(RegistrationMixin, CreateView):
    template_name = 'app_accounts/sign_up_tutor.html'
    user_type = 'tutor'
    require_valid_token = False  # Requires valid token for tutors
    success_url = reverse_lazy('provider:dp_wizard')  # success url for the first time for tutors goes to pre-interview!

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


class ForgetPasswordView(View):
    template_name = 'app_accounts/forgot-password.html'

    @method_decorator(csrf_exempt)
    def dispatch(self, *args, **kwargs):
        return super().dispatch(*args, **kwargs)

    def get(self, request):
        # Add rate limiting check
        if cache.get(f'password_reset_limit_{request.META.get("REMOTE_ADDR")}'):
            return error_page(request, "Too Many Requests", "Please wait before requesting another password reset.",
                              429)
        return render(request, self.template_name)

    def post(self, request):
        # Rate limiting (5 requests per hour per IP)
        cache_key = f'password_reset_limit_{request.META.get("REMOTE_ADDR")}'
        if cache.get(cache_key):
            return error_page(request, "Too Many Requests", "Please wait before requesting another password reset.",
                              429)
        cache.set(cache_key, True, timeout=3600)  # 1 hour

        email = request.POST.get('email')
        try:
            user = User.objects.get(email=email)

            # Check if a token was recently generated (prevent spam)
            if (user.profile.password_reset_token and
                    user.profile.pss_token_expiry > timezone.now() - timedelta(minutes=5)):
                messages.info(request, 'A password reset link was already sent recently. Please check your email.')
                return redirect('accounts:forget_password')

        except User.DoesNotExist:
            # Don't reveal whether email exists (security best practice)
            messages.success(request, 'If an account exists with this email, a password reset link has been sent.')
            return redirect('accounts:forget_password')
        except MultipleObjectsReturned:
            return error_page(request, "Account Error",
                              "Multiple accounts found with this email. Please contact support.", 400)

        # Generate token
        token = get_random_string(64)
        user.profile.password_reset_token = token
        user.profile.pss_token_expiry = timezone.now() + timedelta(hours=24)
        user.profile.save()

        # Send email
        reset_url = request.build_absolute_uri(reverse('accounts:password_reset_confirm') + f'?token={token}')

        try:
            # send_mail(
            #     'Password Reset Request',
            #     f'Click here to reset your password: {reset_url}\n\n'
            #     f'This link will expire in 24 hours.',
            #     settings.DEFAULT_FROM_EMAIL,
            #     [user.email],
            #     fail_silently=False,
            # )
            send_reset_password_link(request, user, reset_url)
            messages.success(request, 'If an account exists with this email, a password reset link has been sent.')
        except Exception as e:
            # Log the error in production
            if settings.DEBUG:
                messages.error(request, f'Failed to send email: {str(e)}')
            else:
                messages.error(request, 'Failed to send email. Please try again later.')

        return redirect('accounts:forget_password')


class PasswordResetConfirmView(View):
    template_name = 'app_accounts/password_reset_confirm.html'

    def get(self, request):
        token = request.GET.get('token')
        if not token:
            return error_page(request, "Invalid Request", "Password reset token is missing.", 400)

        try:
            user = User.objects.get(profile__password_reset_token=token)

            # Check token expiry
            if user.profile.pss_token_expiry < timezone.now():
                return error_page(request, "Expired Link", "This password reset link has expired.", 400)

        except User.DoesNotExist:
            return error_page(request, "Invalid Token", "The password reset link is invalid or has expired.", 400)
        except MultipleObjectsReturned:
            return error_page(request, "Security Error",
                              "Multiple accounts found with this token. Please contact support.", 400)

        return render(request, self.template_name, {'token': token})

    def post(self, request):
        token = request.POST.get('token')
        password = request.POST.get('password')
        password_confirm = request.POST.get('password_confirm')

        if not token:
            return error_page(request, "Invalid Request", "Password reset token is missing.", 400)

        try:
            user = User.objects.get(profile__password_reset_token=token)
            if user.profile.pss_token_expiry < timezone.now():
                return error_page(request, "Expired Link", "This password reset link has expired.", 400)
        except (User.DoesNotExist, MultipleObjectsReturned) as e:
            return error_page(request, "Invalid Token", "The password reset link is invalid.", 400)

        # Password validation
        errors = []
        if password != password_confirm:
            errors.append("Passwords do not match")

        # Validate password strength
        # ...
        # if errors: =
        # validate_password_strength(password, user):
        # for error in errors:
        #     messages.error(request, error)
        # return redirect(f"{reverse('accounts:password_reset_confirm')}?token={token}")
        try:
            validate_password(password, user=user)
        except ValidationError as e:
            errors.extend(e.messages)

        # Additional custom validation
        validation_rules = [
            (len(password) >= 8, "Password must be at least 8 characters"),
            (re.search(r'[A-Z]', password), "Password must contain at least one uppercase letter"),
            (re.search(r'[a-z]', password), "Password must contain at least one lowercase letter"),
            (re.search(r'[0-9]', password), "Password must contain at least one number"),
            (re.search(r'[^A-Za-z0-9]', password), "Password must contain at least one special character")
        ]

        for condition, message in validation_rules:
            if not condition:
                errors.append(message)

        if errors:
            for error in errors:
                messages.error(request, error)
            return redirect(f"{reverse('accounts:password_reset_confirm')}?token={token}")

        # Update password and clear token
        user.set_password(password)
        # Important: Save the user AFTER set_password
        user.save()

        user.profile.password_reset_token = None
        user.profile.pss_token_expiry = None
        user.profile.save()
        print(f'user pass: {user.password}')

        # Invalidate all sessions
        # from django.contrib.sessions.models import Session
        # Session.objects.filter(expire_date__gte=timezone.now()).delete()
        # ===========================================

        # Update session auth hash if user is logged in
        from django.contrib.auth import update_session_auth_hash
        if request.user.is_authenticated:
            update_session_auth_hash(request, user)
            print(f'user hash pass: {user.password}')

        # ... after successful reset
        logout(request)  # Logout user if they were logged in

        messages.success(request, 'Password updated successfully! Please login with your new password.')
        return redirect('accounts:sign_in')


class EmailVerificationBaseView(LoginRequiredMixin):
    """Base class for email verification views"""

    def dispatch(self, request, *args, **kwargs):
        try:
            if hasattr(request.user, 'profile') and request.user.profile.is_email_verified:
                return redirect('accounts:dashboard')
        except ObjectDoesNotExist:
            logger.warning(f"User profile missing for {request.user}")
            logout(request)
            return redirect('accounts:login')
        return super().dispatch(request, *args, **kwargs)

    def _get_attempts_data(self, user):
        """Get attempts and cooldown data"""
        cache_key = f'email_verify_attempts_{user.id}'
        cooldown_key = f'email_verify_cooldown_{user.id}'

        attempts = cache.get(cache_key, 0)
        cooldown_until = cache.get(cooldown_key)
        cooldown_remaining = (cooldown_until - timezone.now()).seconds if cooldown_until else 0

        return {
            'attempts': attempts,
            'requires_captcha': attempts >= settings.VERIFICATION_CAPTCHA_THRESHOLD,
            'cooldown_remaining': cooldown_remaining,
            'max_attempts': settings.VERIFICATION_MAX_ATTEMPTS,
            'attempts_remaining': max(0, settings.VERIFICATION_MAX_ATTEMPTS - attempts)
        }


class VerifyEmailView(EmailVerificationBaseView, TemplateView):
    """Display verification page with optional token processing"""
    template_name = 'app_accounts/dashboard/verify_email.html'

    @method_decorator(never_cache)
    def get(self, request, *args, **kwargs):
        token = request.GET.get('token')
        if token:
            return self._process_token(request, token)
        return super().get(request, *args, **kwargs)

    def _process_token(self, request, token):
        """Process verification token if present"""
        try:
            profile = request.user.profile

            if not secrets.compare_digest(profile.email_verification_token or '', token):
                messages.error(request, "Invalid verification link")
                return redirect('accounts:verify_email')

            if profile.email_token_expiry and profile.email_token_expiry < timezone.now():
                messages.error(request, "Verification link expired")
                return redirect('accounts:verify_email')

            self._complete_verification(profile)
            messages.success(request, "Email verified successfully!")
            return redirect('accounts:dashboard')

        except Exception as e:
            logger.error(f"Verification failed: {str(e)}", exc_info=True)
            messages.error(request, "Verification failed. Please try again.")
            return redirect('accounts:verify_email')

    def _complete_verification(self, profile):
        """Atomic verification completion"""
        with transaction.atomic():
            profile.is_email_verified = True
            profile.email_verification_token = None
            profile.email_token_expiry = None

            if profile.user_type == 'student':
                profile.is_active = True
                Student.objects.get_or_create(profile=profile)

            if profile.user_type == 'tutor':
                profile.is_active = False
                tutor, created = Tutor.objects.get_or_create(profile=profile)  # Unpack the tuple
                tutor.status = 'email_verified'
                tutor.save()  # Now we're saving the Tutor object, not the tuple

            profile.save()

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user = self.request.user
        attempts_data = self._get_attempts_data(user)

        context.update({
            'user': user,
            'resend_url': reverse('accounts:resend_verification'),
            'next_resend': attempts_data['cooldown_remaining'],
            'max_attempts': attempts_data['max_attempts'],
            'attempts_remaining': attempts_data['attempts_remaining'],
            'requires_captcha': attempts_data['requires_captcha'],
            'recaptcha_site_key': settings.RECAPTCHA_PUBLIC_KEY if attempts_data['requires_captcha'] else None,
        })
        return context


@method_decorator(require_POST, name='dispatch')
class ResendVerificationView(EmailVerificationBaseView, View):
    """Handle verification email resends with rate limiting"""

    def post(self, request, *args, **kwargs):
        user = request.user
        attempts_data = self._get_attempts_data(user)

        # Check rate limits
        if attempts_data['attempts'] >= settings.VERIFICATION_MAX_ATTEMPTS:
            return JsonResponse({
                'error': 'Maximum attempts reached. Try again later.',
                'next_resend': attempts_data['cooldown_remaining']
            }, status=429)

        # Verify CAPTCHA if required
        if attempts_data['requires_captcha']:
            captcha_response = request.POST.get('g-recaptcha-response')
            if not self._verify_captcha(captcha_response):
                return JsonResponse({'error': 'Invalid CAPTCHA verification'}, status=400)

        # Process resend
        try:
            return self._send_verification_email(user, attempts_data['attempts'] + 1)
        except Exception as e:
            logger.error(f"Failed to resend verification: {str(e)}", exc_info=True)
            return JsonResponse({
                'error': 'Failed to send verification email'
            }, status=500)

    def _verify_captcha(self, captcha_response):
        """Verify reCAPTCHA response"""
        if not settings.RECAPTCHA_PRIVATE_KEY:
            return True  # Bypass if not configured

        import requests
        data = {
            'secret': settings.RECAPTCHA_PRIVATE_KEY,
            'response': captcha_response
        }
        try:
            response = requests.post(
                'https://www.google.com/recaptcha/api/siteverify',
                data=data,
                timeout=5
            )
            return response.json().get('success', False)
        except requests.RequestException:
            return False

    def _send_verification_email(self, user, attempt_count):
        """Send verification email with exponential backoff"""
        cache_key = f'email_verify_attempts_{user.id}'
        cooldown_key = f'email_verify_cooldown_{user.id}'

        # Calculate exponential backoff (min 60s, max 1 hour)
        cooldown = min(
            settings.VERIFICATION_BASE_COOLDOWN * (2 ** (attempt_count - 1)),
            settings.VERIFICATION_MAX_COOLDOWN
        )
        cooldown_until = timezone.now() + timedelta(seconds=cooldown)

        # Update cache
        cache.set(cache_key, attempt_count, timeout=3600)  # 1 hour window
        cache.set(cooldown_key, cooldown_until, timeout=cooldown)

        # Generate new token
        profile = user.profile
        profile.email_verification_token = get_random_string(64)
        profile.email_token_expiry = timezone.now() + timedelta(days=1)
        profile.save()

        # Send email
        verification_url = self.request.build_absolute_uri(
            reverse('accounts:verify_email') + f'?token={profile.email_verification_token}'
        )
        send_verification_email(self.request, user, verification_url)

        return JsonResponse({
            'success': True,
            'message': 'Verification email sent',
            'next_resend': cooldown,
            'attempts_remaining': settings.VERIFICATION_MAX_ATTEMPTS - attempt_count,
            'requires_captcha': attempt_count >= settings.VERIFICATION_CAPTCHA_THRESHOLD
        })


@login_required
def dashboard(request):
    if not request.user.is_authenticated:
        return redirect('accounts:sign_in')
    user = request.user
    try:
        user_type = user.profile.user_type
        print(f'User Type: {user_type}')
    except AttributeError:
        UserProfile.objects.create(user=user, user_type='student')
        user_type = user.profile.user_type
    if not user.profile.is_email_verified:
        print('I wanna go to verify email')
        return redirect('accounts:verify_email')

    if user.is_superuser or user_type == 'admin':
        return redirect('my_admin:da_home')
    elif user_type == 'staff':
        return redirect('staff:dstf_home')
    elif user_type == 'student':
        print(f'Im here!')
        return redirect('client:dc_home')
    elif user_type == 'tutor':
        if not user.profile.is_active:
            return redirect('provider:dp_wizard')
        else:
            return redirect('provider:dp_home')
    else:
        # Handle invalid or unexpected user_type (e.g., log an error)
        err_title = 'Error'
        err_msg = f"Invalid or unexpected user_type: {user_type}"
        return error_page(request, err_title, err_msg, 500)
        # return redirect('accounts:error_page')


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
        return redirect('provider:dp_edit', pk)
    elif user.groups.filter(name='student').exists():
        return redirect('client:dc_edit', pk)
    else:
        # Redirect to a default page or handle unauthenticated roles
        return redirect('client:dc_edit', pk)


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


@receiver(user_login_failed)
def handle_failed_login(sender, credentials, request, **kwargs):
    username = credentials.get('username')
    ip = get_client_ip(request)

    try:
        user = User.objects.get(username=username) if username else None
    except User.DoesNotExist:
        user = None

    SecurityEvent.objects.create(
        event_type='login_failed',
        user=user,
        attempted_username=username,
        ip_address=ip,
        user_agent=request.META.get('HTTP_USER_AGENT', ''),
        path=request.path,
        reason='Invalid credentials',
        details={
            'username_attempted': username,
            'login_path': request.path
        }
    )

    # Rate limiting logic can remain in cache
    cache_key = f'login_attempts_{ip}'
    attempts = cache.get(cache_key, 0) + 1
    cache.set(cache_key, attempts, timeout=3600)


@login_required
def sign_out(request):
    logout(request)
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
