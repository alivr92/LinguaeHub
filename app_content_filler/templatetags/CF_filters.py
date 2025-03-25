from django import template
import json
register = template.Library()


@register.filter(name='quill_to_json')
def quill_to_json(value):
    # Extract the Delta JSON from the FieldQuill object
    if hasattr(value, 'delta'):
        return value.delta
    return {}
