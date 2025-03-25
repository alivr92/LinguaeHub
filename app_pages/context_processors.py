from app_pages.models import ContentFiller, ContactUs


def counters(request):
    return {
        'range': range(1, 6),  # for rating stars
        'contact_us_unread': ContactUs.objects.filter(is_read=False).count(),  # to show in admin sidebar
    }
