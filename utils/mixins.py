from django.contrib import messages
from utils.pages import error_page


class RoleRequiredMixin:
    allowed_roles = []  # You override this in each view class

    def dispatch(self, request, *args, **kwargs):
        user_type = getattr(request.user.profile, 'user_type', None)

        if not self.allowed_roles or user_type not in self.allowed_roles:
            err_title = f"Access Denied"
            err_msg = f"Sorry! You don't have permission to view this page."
            messages.error(self.request, err_msg)
            return error_page(request, err_title, err_msg, 403)

        return super().dispatch(request, *args, **kwargs)


class ActivationRequiredMixin:
    need_activation = True  # useful for some inherited classes! (like DTInterview)

    def dispatch(self, request, *args, **kwargs):
        is_active = getattr(request.user.profile, 'is_active', False)

        if not is_active and self.need_activation:
            err_title = f"Access Denied"
            err_msg = f"Sorry! Your profile is not activated yet!"
            messages.error(self.request, err_msg)
            return error_page(request, err_title, err_msg, 403)

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
