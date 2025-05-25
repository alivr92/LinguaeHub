# Helper method to convert utc to local time and inverse!
import pytz
from datetime import datetime
from django.utils import timezone


def local_to_utc(date_str: str, date_format: str, timezone_str: str) -> datetime:
    """
    Convert a local datetime string to UTC datetime object.

    Args:
        date_str: The datetime string to convert (e.g., '05/02/2023 14:30')
        date_format: The format of the datetime string (e.g., '%m/%d/%Y %H:%M')
        timezone_str: The IANA timezone string (e.g., 'America/New_York')

    Returns:
        A timezone-aware datetime object in UTC

    Raises:
        pytz.UnknownTimeZoneError: If the timezone is invalid
        ValueError: If the date string doesn't match the format
    """
    # Validate and get timezone
    local_tz = pytz.timezone(timezone_str)

    # Parse and localize datetime
    local_dt = datetime.strptime(date_str, date_format)
    localized_dt = local_tz.localize(local_dt)

    # Convert to UTC
    return localized_dt.astimezone(pytz.UTC)


def utc_to_local(utc_time, timezone_str):
    """
    Convert UTC time to local time based on timezone.
    Returns timezone-aware datetime in the specified timezone.
    """
    # If input is a string, convert to datetime
    if isinstance(utc_time, str):
        utc_time = utc_time.replace('Z', '+00:00')
        try:
            utc_time = datetime.fromisoformat(utc_time)
        except ValueError:
            raise ValueError("Invalid datetime string format")

    # Ensure the input datetime is timezone-aware (UTC)
    if utc_time.tzinfo is None:
        utc_time = pytz.UTC.localize(utc_time)
    else:
        utc_time = utc_time.astimezone(pytz.UTC)

    # Get the target timezone
    try:
        tz = pytz.timezone(str(timezone_str))
    except pytz.exceptions.UnknownTimeZoneError:
        raise ValueError(f"Unknown timezone: {timezone_str}")

    # Convert to local time and return as timezone-aware
    return utc_time.astimezone(tz)
