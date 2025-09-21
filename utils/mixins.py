from django.contrib import messages
from django.contrib.auth import logout
from django.contrib.auth.models import User
from django.shortcuts import redirect
from utils.pages import error_page
from django.http import JsonResponse


class RoleRequiredMixin_DEL:
    allowed_roles = []  # You override this in each view class

    def dispatch(self, request, *args, **kwargs):
        user_type = getattr(request.user.profile, 'user_type', None)

        if not self.allowed_roles or user_type not in self.allowed_roles:
            err_title = f"Access Denied"
            err_msg = f"Sorry! You don't have permission to view this page."
            messages.error(self.request, err_msg)
            return error_page(request, err_title, err_msg, 403)

        return super().dispatch(request, *args, **kwargs)


class RoleRequiredMixin:
    allowed_roles = []

    def dispatch(self, request, *args, **kwargs):
        try:
            # Explicitly check if user exists
            request.user.refresh_from_db()
        except User.DoesNotExist:
            # Force logout if user was deleted
            logout(request)
            messages.error(request, "Your session was terminated")
            return redirect('accounts:login')

        # Then check profile and roles
        if not hasattr(request.user, 'profile'):
            logout(request)
            messages.error(request, "Account configuration error")
            return redirect('accounts:login')

        user_type = request.user.profile.user_type
        if self.allowed_roles and user_type not in self.allowed_roles:
            err_title = f"Access Denied"
            err_msg = f"Sorry! You don't have permission to view this page."
            messages.error(self.request, err_msg)
            return error_page(request, err_title, err_msg, 403)

        return super().dispatch(request, *args, **kwargs)


class ActivationRequiredMixin:
    need_activation = True  # useful for some inherited classes! (like DPInterview)

    def dispatch(self, request, *args, **kwargs):
        is_active = getattr(request.user.profile, 'is_active', False)

        if not is_active and self.need_activation:
            err_title = f"Access Denied"
            err_msg = f"Sorry! Your profile is not activated yet!"
            messages.error(self.request, err_msg)
            return error_page(request, err_title, err_msg, 403)

        return super().dispatch(request, *args, **kwargs)


class EmailVerificationRequiredMixin:
    need_email_verification = True  # useful for some inherited classes!

    def dispatch(self, request, *args, **kwargs):
        is_email_verified = getattr(request.user.profile, 'is_email_verified', False)

        if not is_email_verified and self.need_email_verification:
            err_title = f"Access Denied"
            err_msg = f"Sorry! Your email is not verified yet!"
            messages.error(self.request, err_msg)
            return redirect('accounts:verify_email')
            # return error_page(request, err_title, err_msg, 403)

        return super().dispatch(request, *args, **kwargs)


class VIPRequiredMixin:

    def dispatch(self, request, *args, **kwargs):
        is_vip = getattr(request.user.profile, 'is_vip', False)

        if not is_vip:
            err_title = f"Access Denied"
            err_msg = f"Sorry! Just VIP members have access to this page!"
            messages.error(self.request, err_msg)
            return error_page(request, err_title, err_msg, 403)

        return super().dispatch(request, *args, **kwargs)


class OwnershipRequiredMixin:
    """
    Ensures the user can only access their own data.
    Configure by setting owner_lookup_field (default 'pk') and owner_lookup_url_kwarg (same as owner_lookup_field).
    """
    owner_lookup_field = 'pk'  # The field to compare against request.user
    owner_lookup_url_kwarg = None  # The URL kwarg containing the owner ID (defaults to same as owner_lookup_field)
    owner_model = None  # The model to fetch (defaults to User)
    owner_access_denied_message = "Forbidden Access!, You can only access your own data"

    def dispatch(self, request, *args, **kwargs):
        # Get the lookup kwargs if not specified
        if self.owner_lookup_url_kwarg is None:
            self.owner_lookup_url_kwarg = self.owner_lookup_field

        # Get the owner ID from URL kwargs
        owner_id = kwargs.get(self.owner_lookup_url_kwarg)
        if not owner_id:
            return self.handle_invalid_ownership(request)

        # Get the owner model (default to User)
        owner_model = self.owner_model or request.user.__class__

        try:
            # Get the owner object
            owner = owner_model.objects.get(**{self.owner_lookup_field: owner_id})
        except (owner_model.DoesNotExist, ValueError):
            return self.handle_invalid_ownership(request)

        # Check ownership
        if owner != request.user:
            return self.handle_invalid_ownership(request)

        return super().dispatch(request, *args, **kwargs)

    def handle_invalid_ownership(self, request):
        if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
            return JsonResponse({
                'status': 'error',
                'message': self.owner_access_denied_message
            }, status=403)

        messages.error(request, self.owner_access_denied_message)
        return error_page(request, "Access Denied", self.owner_access_denied_message, 403)
