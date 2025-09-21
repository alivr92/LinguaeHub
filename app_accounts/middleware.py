from django.contrib.auth import logout
from django.contrib.auth.models import User


class SecurityHeadersMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)

        # Critical for auth pages
        response['X-Frame-Options'] = 'DENY'
        # Prevents page from being embedded in frames/iframes (clickjacking protection)

        response['X-Content-Type-Options'] = 'nosniff'
        # Prevents MIME type sniffing (forces declared Content-Type)

        response['X-XSS-Protection'] = '1; mode=block'
        # Enables XSS filtering in browsers (old but useful for legacy browsers)

        # Recommended for privacy/security
        response['Referrer-Policy'] = 'strict-origin-when-cross-origin'

        # Only if using reCAPTCHA or other external scripts
        response['Content-Security-Policy'] = (
            "default-src 'self'; "
            "script-src 'self' https://www.google.com/recaptcha/ https://www.gstatic.com/; "
            "style-src 'self' 'unsafe-inline'; "
            "form-action 'self';"
        )

        return response


class ValidateUserMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if request.user.is_authenticated:
            try:
                request.user.refresh_from_db()
            except User.DoesNotExist:
                logout(request)
        return self.get_response(request)
