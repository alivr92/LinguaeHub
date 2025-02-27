from django import template

register = template.Library()


@register.filter(name='weekday_name')
def weekday_name(value):
    days_of_week = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    return days_of_week[value]


@register.filter
def get(dictionary, key):
    return dictionary.get(key)