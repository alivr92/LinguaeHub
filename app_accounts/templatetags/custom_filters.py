from django import template
from django.utils.html import strip_tags

register = template.Library()


@register.filter(name='add_class')
def add_class(value, css_class):
    return value.as_widget(attrs={'class': css_class})


@register.filter(name='add_attrs1')
def add_attrs1(field, css_and_attrs):
    attrs = {}
    for attr in css_and_attrs.split(','):
        if ':' in attr:
            key, value = attr.split(':', 1)
            attrs[key] = value
        else:
            # Consider it as class attribute if only one value is given
            if 'class' in attrs:
                attrs['class'] += f' {attr}'
            else:
                attrs['class'] = attr
    return field.as_widget(attrs=attrs)


@register.filter(name='add_attrs')
def add_attrs(field, attrs_list):
    attrs = {}
    for attr in attrs_list.strip("[]'").split("','"):
        if ':' in attr:
            key, value = attr.split(':', 1)
            attrs[key] = value
        else:
            # Consider it as class attribute if only one value is given
            if 'class' in attrs:
                attrs['class'] += f' {attr}'
            else:
                attrs['class'] = attr
    return field.as_widget(attrs=attrs)


@register.filter(name='strip_html')
def strip_html(value):
    return strip_tags(value)
