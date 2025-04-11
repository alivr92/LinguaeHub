from django import template
from datetime import datetime

register = template.Library()


@register.filter
def get_embedded(post, key):
    """Access _embedded data with special keys like wp:featuredmedia"""
    if hasattr(post, '_embedded'):
        return post._embedded.get(key, None)
    return None


@register.filter
def simplified_timesince(date):
    try:
        now = datetime.now()
        difference = now - date

        years = difference.days // 365
        months = (difference.days % 365) // 30

        if years > 0 and months > 0:
            return f"{years}Y, {months}M"
        elif years > 0:
            return f"{years}Y"
        elif months > 0:
            return f"{months}M"
        else:
            return "Just Now"
    except Exception:
        return "Invalid Date"
