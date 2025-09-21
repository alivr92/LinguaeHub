from django import template
from decimal import Decimal
from django.utils.timezone import now

register = template.Library()


@register.filter
def float_add(value, arg):
    try:
        return float(value) + float(arg)
    except (ValueError, TypeError):
        return value


@register.filter
def float_sub(value, arg):
    try:
        return float(value) - float(arg)
    except (ValueError, TypeError):
        return value


@register.filter(name='truncatewords')
def truncatewords(value, arg):
    """
    Truncates a string after a certain number of words.
    """
    words = value.split()
    if len(words) > arg:
        return ' '.join(words[:arg]) + '...'
    else:
        return value


@register.filter
def format_decimal(value, places=1):
    if isinstance(value, Decimal):
        return f"{value:.{places}f}"  # Format to the specified number of decimal places
    return value


@register.filter
def timeuntil(deadline):
    """
    Returns the time left until the given deadline as days and hours.
    """
    if not deadline:
        return "No deadline set"
    remaining_time = deadline - now()
    if remaining_time.total_seconds() <= 0:
        return "Deadline has passed"
    days = remaining_time.days
    hours = remaining_time.seconds // 3600
    if days > 0:
        return f"{days} d, {hours} h left"
    else:
        return f"{hours} h left"


@register.filter
def status(queryset, status):
    return queryset.filter(status=status)
