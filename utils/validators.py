# utils/password_validation.py
from django.core.exceptions import ValidationError
from django.contrib.auth.password_validation import validate_password
import re


def validate_password_strength(password, user=None):
    """Modular password strength validator"""
    errors = []

    # Django's built-in validation
    try:
        validate_password(password, user)
    except ValidationError as e:
        errors.extend(e.messages)

    # Custom rules
    validation_rules = [
        (len(password) >= 8, "Password must be at least 8 characters"),
        (re.search(r'[A-Z]', password), "Password must contain at least one uppercase letter"),
        (re.search(r'[a-z]', password), "Password must contain at least one lowercase letter"),
        (re.search(r'[0-9]', password), "Password must contain at least one number"),
        (re.search(r'[^A-Za-z0-9]', password), "Password must contain at least one special character"),
        (not re.search(r'(.)\1{2,}', password), "Password contains repeating characters (3+ times)")
    ]

    for condition, message in validation_rules:
        if not condition:
            errors.append(message)

    return errors
