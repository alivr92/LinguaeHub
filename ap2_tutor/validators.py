from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _


def validate_max_size(max_size):
    def validator(file):
        if file.size > max_size:
            raise ValidationError(
                _('File too large. Max size is %(max_size)s MB.'),
                params={'max_size': max_size // 1024 // 1024},
            )

    return validator
