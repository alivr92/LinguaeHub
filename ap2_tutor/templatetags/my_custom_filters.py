from django import template

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
