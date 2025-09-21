# templatetags/tocify.py
from django import template
from bs4 import BeautifulSoup
import re
import html

register = template.Library()


@register.filter
def tocify(value):
    soup = BeautifulSoup(value, 'html.parser')
    headings = soup.find_all(['h2', 'h3'])

    toc = '<ul class="toc-list">'
    for heading in headings:
        if not heading.get('id'):
            heading['id'] = heading.text.lower().replace(' ', '-')
        toc += f'<li class="toc-{heading.name}">'
        toc += f'<a href="#{heading["id"]}">{heading.text}</a>'
        toc += '</li>'
    toc += '</ul>'

    return toc


@register.filter
def generate_toc(value):
    if not value:
        return {'toc': [], 'content': ''}

    soup = BeautifulSoup(value, 'html.parser')
    headings = soup.find_all(re.compile('^h[1-4]$'))

    toc_items = []
    for heading in headings:
        # Create URL-safe ID
        heading_text = html.unescape(heading.text)
        heading_id = re.sub(r'[^\w-]+', '', heading_text.lower().replace(' ', '-'))
        heading_id = re.sub(r'-+', '-', heading_id).strip('-')
        heading['id'] = heading_id or f"section-{len(toc_items)+1}"

        toc_items.append({
            'text': heading.text,
            'id': heading['id'],
            'level': int(heading.name[1])
        })

    return {
        'toc': toc_items,
        'content': str(soup)
    }


@register.filter
def dictget(value, arg):
    return value.get(arg, '')
