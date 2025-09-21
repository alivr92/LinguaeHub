# accounts/validators.py
import re
from django.core.exceptions import ValidationError
from django.utils.translation import gettext as _


class ComplexityValidator:
    """
    Validate whether the password meets complexity requirements.
    """

    def __init__(self):
        self.min_length = 8

    def validate(self, password, user=None):
        if len(password) < self.min_length:
            raise ValidationError(
                _("Password must be at least %(min_length)d characters long."),
                code='password_too_short',
                params={'min_length': self.min_length},
            )

        checks = [
            (r'[A-Z]', 'uppercase'),
            (r'[a-z]', 'lowercase'),
            (r'[0-9]', 'numeric'),
            (r'[^A-Za-z0-9]', 'special')
        ]

        for pattern, name in checks:
            if not re.search(pattern, password):
                raise ValidationError(
                    _("Password must contain at least one %(character_type)s character."),
                    code=f'password_no_{name}',
                    params={'character_type': name},
                )

    def get_help_text(self):
        return _(
            "Your password must contain at least: "
            "8 characters, 1 uppercase, 1 lowercase, "
            "1 number, and 1 special character."
        )
