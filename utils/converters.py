# Helper method to convert utc to local time and inverse!
import pytz
from datetime import datetime, time, date
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


def localTime_to_utcTime_MAIN(local_time_str, timezone_str, reference_date=None):
    """
    Convert a local time string to UTC time.

    Args:
        local_time_str: Time string in format 'HH:MM' (e.g., '14:30')
        timezone_str: IANA timezone string (e.g., 'America/New_York')
        reference_date: Date object for reference (defaults to today)

    Returns:
        time object in UTC
    """
    # Validate and get timezone
    local_tz = pytz.timezone(timezone_str)

    # Use today as reference date if not provided
    if reference_date is None:
        reference_date = date.today()

    # Create datetime object with reference date and local time
    local_dt = datetime.combine(reference_date,
                                datetime.strptime(local_time_str, '%H:%M').time())

    # Localize and convert to UTC
    localized_dt = local_tz.localize(local_dt)
    utc_dt = localized_dt.astimezone(pytz.UTC)

    # Return just the time part
    return utc_dt.time()


def utcTime_to_localTime_MAIN(utc_time_obj, timezone_str, reference_date=None):
    """
    Convert a UTC time object to local time.

    Args:
        utc_time_obj: time object in UTC
        timezone_str: IANA timezone string (e.g., 'America/New_York')
        reference_date: Date object for reference (defaults to today)

    Returns:
        time object in local timezone
    """
    # Validate and get timezone
    local_tz = pytz.timezone(timezone_str)

    # Use today as reference date if not provided
    if reference_date is None:
        reference_date = date.today()

    # Create datetime object with reference date and UTC time
    utc_dt = datetime.combine(reference_date, utc_time_obj)
    utc_dt = pytz.UTC.localize(utc_dt)

    # Convert to local timezone
    local_dt = utc_dt.astimezone(local_tz)

    # Return just the time part
    return local_dt.time()


def localTime_to_utcTime(local_time_str, timezone_str, reference_date=None):
    """
    Convert a local time string to UTC time
    """
    if reference_date is None:
        reference_date = date.today()

    local_tz = pytz.timezone(timezone_str)

    # Handle 24:00 as end of day
    if local_time_str == '24:00' or local_time_str == '23:59:59':
        local_dt = datetime.combine(reference_date, time(23, 59, 59))
    else:
        # Parse time string
        try:
            time_obj = datetime.strptime(local_time_str, '%H:%M').time()
        except ValueError:
            try:
                time_obj = datetime.strptime(local_time_str, '%H:%M:%S').time()
            except ValueError:
                raise ValueError(f"Invalid time format: {local_time_str}")

        local_dt = datetime.combine(reference_date, time_obj)

    localized_dt = local_tz.localize(local_dt)
    utc_dt = localized_dt.astimezone(pytz.UTC)

    return utc_dt.time()


def utcTime_to_localTime(utc_time_obj, timezone_str, reference_date=None):
    """
    Convert a UTC time object to local time string
    """
    if reference_date is None:
        reference_date = date.today()

    local_tz = pytz.timezone(timezone_str)

    # Create datetime object with reference date and UTC time
    utc_dt = datetime.combine(reference_date, utc_time_obj)
    utc_dt = pytz.UTC.localize(utc_dt)

    # Convert to local timezone
    local_dt = utc_dt.astimezone(local_tz)
    local_time = local_dt.time()

    # Check if this represents the end of day
    if (local_time.hour == 23 and local_time.minute == 59 and local_time.second == 59):
        return "24:00"

    return local_time.strftime('%H:%M')

# --------------------
def utcTime_to_localTime_full(utc_time_obj, timezone_str, reference_date=None):
    """
    Convert UTC time to local time with full datetime context
    Returns a datetime object, not just time string
    """
    if reference_date is None:
        reference_date = date.today()

    local_tz = pytz.timezone(timezone_str)

    # Create datetime object with reference date and UTC time
    utc_dt = datetime.combine(reference_date, utc_time_obj)
    utc_dt = pytz.UTC.localize(utc_dt)

    # Convert to local timezone
    return utc_dt.astimezone(local_tz)


def localTime_to_utcTime_full(local_time_str, timezone_str, reference_date=None):
    """
    Convert local time to UTC time with full datetime context
    """
    if reference_date is None:
        reference_date = date.today()

    local_tz = pytz.timezone(timezone_str)

    # Handle 24:00 as end of day
    if local_time_str == '24:00':
        local_dt = datetime.combine(reference_date, time(23, 59, 59, 999999))
    else:
        # Parse time string
        time_format = '%H:%M:%S' if ':' in local_time_str and local_time_str.count(':') == 2 else '%H:%M'
        time_obj = datetime.strptime(local_time_str, time_format).time()
        local_dt = datetime.combine(reference_date, time_obj)

    localized_dt = local_tz.localize(local_dt)
    return localized_dt.astimezone(pytz.UTC)
# --------------------

def format_time_for_display(time_obj):
    """
    Format time object as HH:MM string.
    """
    return time_obj.strftime('%H:%M')
