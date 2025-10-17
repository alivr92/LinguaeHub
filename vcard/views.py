from django.shortcuts import render, get_object_or_404
from django.http import Http404, JsonResponse, HttpResponseForbidden
from django.conf import settings
from django.utils import timezone
from .models import VCardPage, VCardAnalytics, QRCodeScan
import qrcode
from io import BytesIO
import base64
import json
from django.contrib.admin.views.decorators import staff_member_required
from django.db import models


def get_client_ip(request):
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        ip = x_forwarded_for.split(',')[0]
    else:
        ip = request.META.get('REMOTE_ADDR')
    return ip


def vcard_page(request, slug):
    vcard = get_object_or_404(VCardPage, slug=slug, is_active=True)

    # Verify QR token if present
    token = request.GET.get('token')
    is_qr_scan = bool(token)

    if is_qr_scan:
        if token != vcard.qr_code_secret:
            raise Http404("Invalid QR code")
        vcard.record_qr_scan()

        # Record detailed QR scan
        QRCodeScan.objects.create(
            vcard=vcard,
            ip_address=get_client_ip(request),
            user_agent=request.META.get('HTTP_USER_AGENT', '')
        )

    # Record page view
    vcard.record_view()

    # Record analytics
    VCardAnalytics.objects.create(
        vcard=vcard,
        event_type='qr_scan' if is_qr_scan else 'page_view',
        ip_address=get_client_ip(request),
        user_agent=request.META.get('HTTP_USER_AGENT', ''),
        referrer=request.META.get('HTTP_REFERER', '')
    )

    context = {
        'vcard': vcard,
        'qr_token': token,
        'social_links': vcard.get_social_links(),
    }
    # return render(request, 'vcard/vcard_page.html', context)
    return render(request, 'vcard/vcard2.html', context)


def generate_qr_code(request, slug):
    vcard = get_object_or_404(VCardPage, slug=slug, is_active=True)

    # Generate QR code
    qr_data = vcard.get_qr_code_data()
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )
    qr.add_data(qr_data)
    qr.make(fit=True)

    img = qr.make_image(fill_color="black", back_color="white")
    buffer = BytesIO()
    img.save(buffer, format="PNG")
    buffer.seek(0)

    # Convert to base64 for embedding in HTML
    img_str = base64.b64encode(buffer.getvalue()).decode()

    return render(request, 'vcard/qr_display.html', {
        'vcard': vcard,
        'qr_image': img_str,
        'qr_data': qr_data
    })


def track_interaction(request, slug):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            event_type = data.get('event_type')
            vcard = get_object_or_404(VCardPage, slug=slug)

            VCardAnalytics.objects.create(
                vcard=vcard,
                event_type=event_type,
                ip_address=get_client_ip(request),
                user_agent=request.META.get('HTTP_USER_AGENT', ''),
                referrer=request.META.get('HTTP_REFERER', '')
            )

            return JsonResponse({'status': 'success'})
        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)})

    return JsonResponse({'status': 'error'})


def analytics_dashboard1(request, slug):
    vcard = get_object_or_404(VCardPage, slug=slug)

    # Basic stats
    today = timezone.now().date()
    last_7_days = today - timezone.timedelta(days=7)

    recent_views = VCardAnalytics.objects.filter(
        vcard=vcard,
        timestamp__date__gte=last_7_days,
        event_type='page_view'
    ).count()

    recent_qr_scans = VCardAnalytics.objects.filter(
        vcard=vcard,
        timestamp__date__gte=last_7_days,
        event_type='qr_scan'
    ).count()

    context = {
        'vcard': vcard,
        'recent_views': recent_views,
        'recent_qr_scans': recent_qr_scans,
        'total_views': vcard.total_views,
        'total_qr_scans': vcard.total_qr_scans,
    }

    return render(request, 'vcard/analytics_dashboard.html', context)


@staff_member_required
def analytics_dashboard(request, slug):
    """Admin-only analytics dashboard"""
    vcard = get_object_or_404(VCardPage, slug=slug)

    # Advanced analytics calculations
    today = timezone.now().date()
    last_7_days = today - timezone.timedelta(days=7)
    last_30_days = today - timezone.timedelta(days=30)

    # Time-based analytics
    recent_views_7d = VCardAnalytics.objects.filter(
        vcard=vcard,
        timestamp__date__gte=last_7_days,
        event_type='page_view'
    ).count()

    recent_qr_scans_7d = VCardAnalytics.objects.filter(
        vcard=vcard,
        timestamp__date__gte=last_7_days,
        event_type='qr_scan'
    ).count()

    recent_views_30d = VCardAnalytics.objects.filter(
        vcard=vcard,
        timestamp__date__gte=last_30_days,
        event_type='page_view'
    ).count()

    # Event type breakdown
    event_breakdown = VCardAnalytics.objects.filter(
        vcard=vcard,
        timestamp__date__gte=last_30_days
    ).values('event_type').annotate(count=models.Count('id'))

    context = {
        'vcard': vcard,
        'recent_views_7d': recent_views_7d,
        'recent_qr_scans_7d': recent_qr_scans_7d,
        'recent_views_30d': recent_views_30d,
        'total_views': vcard.total_views,
        'total_qr_scans': vcard.total_qr_scans,
        'event_breakdown': event_breakdown,
        'last_accessed': vcard.last_accessed,
    }

    return render(request, 'vcard/analytics_dashboard.html', context)
