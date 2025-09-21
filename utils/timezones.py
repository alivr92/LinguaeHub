import pytz
from django.conf import settings


def get_all_timezones():
    """Return a sorted list of all available timezones."""
    return sorted(pytz.all_timezones)


def get_popular_timezones():
    """Return grouped popular timezones."""
    return {
        'Americas': [
            'America/New_York', 'America/Chicago', 'America/Denver',
            'America/Los_Angeles', 'America/Toronto', 'America/Mexico_City'
        ],
        'Europe/Africa': [
            'Europe/London', 'Europe/Paris', 'Europe/Berlin', 'Europe/Moscow',
            'Africa/Cairo', 'Africa/Johannesburg'
        ],
        'Asia/Pacific': [
            'Asia/Tokyo', 'Asia/Shanghai', 'Asia/Singapore', 'Asia/Kolkata',
            'Australia/Sydney', 'Australia/Melbourne', 'Pacific/Auckland'
        ],
        'UTC/GMT': ['UTC', 'GMT']
    }


def is_valid_timezone(timezone_str):
    """Validate if a timezone string is valid."""
    return timezone_str in pytz.all_timezones
