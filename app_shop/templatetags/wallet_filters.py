# templatetags/wallet_filters.py
from django import template

register = template.Library()


@register.filter
def filter_type(transactions, type_name):
    return [t for t in transactions if t.transaction_type == type_name]


@register.simple_tag
def sum_amount(transactions):
    return sum(t.amount for t in transactions)
