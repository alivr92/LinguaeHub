from django.shortcuts import render, get_object_or_404
from django.http import Http404, JsonResponse, HttpResponseForbidden
from django.conf import settings
from django.utils import timezone
from .models import VCardPage, VCardAnalytics, QRCodeScan
from io import BytesIO
import base64
import json
from django.contrib.admin.views.decorators import staff_member_required
from django.db import models

# --
import vobject
from django.http import HttpResponse
from urllib.parse import quote
import qrcode
from qrcode.image.styledpil import StyledPilImage
from qrcode.image.styles.moduledrawers import (
    SquareModuleDrawer,
    GappedSquareModuleDrawer,
    CircleModuleDrawer,
    RoundedModuleDrawer,
    VerticalBarsDrawer,
    HorizontalBarsDrawer
)
from qrcode.image.styles.colormasks import SolidFillColorMask
from PIL import Image, ImageDraw


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


def generate_qr_code1(request, slug):
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


def download_vcard(request, slug):
    vcard_obj = get_object_or_404(VCardPage, slug=slug, is_active=True)

    # Create vCard object
    vcard = vobject.vCard()

    # Add organization
    org = vcard.add('org')
    org.value = [vcard_obj.company_name]

    # Add name
    n = vcard.add('n')
    n.value = vobject.vcard.Name(family='', given=vcard_obj.company_name)

    # Add formatted name
    fn = vcard.add('fn')
    fn.value = vcard_obj.company_name

    # Add phone numbers
    if vcard_obj.phone_number:
        tel_work = vcard.add('tel')
        tel_work.value = vcard_obj.phone_number
        tel_work.type_param = 'WORK'

    if vcard_obj.mobile_number:
        tel_cell = vcard.add('tel')
        tel_cell.value = vcard_obj.mobile_number
        tel_cell.type_param = 'CELL'

    # Add email
    if vcard_obj.email:
        email = vcard.add('email')
        email.value = vcard_obj.email
        email.type_param = 'WORK'

    # Add website
    if vcard_obj.website:
        url = vcard.add('url')
        url.value = vcard_obj.website

    # Add note with tagline
    if vcard_obj.tagline:
        note = vcard.add('note')
        note.value = vcard_obj.tagline

    # Add address if available
    if vcard_obj.address:
        adr = vcard.add('adr')
        adr.value = vobject.vcard.Address(street=vcard_obj.address)
        adr.type_param = 'WORK'

    # Track the download
    VCardAnalytics.objects.create(
        vcard=vcard_obj,
        event_type='vcard_download',
        ip_address=get_client_ip(request),
        user_agent=request.META.get('HTTP_USER_AGENT', ''),
        referrer=request.META.get('HTTP_REFERER', '')
    )

    # Create response
    filename = f"{vcard_obj.company_name.replace(' ', '_')}.vcf"
    response = HttpResponse(vcard.serialize(), content_type='text/vcard')
    response['Content-Disposition'] = f'attachment; filename="{filename}"'
    response['X-Frame-Options'] = 'SAMEORIGIN'

    return response


def generate_qr_code(request, slug):
    vcard = get_object_or_404(VCardPage, slug=slug, is_active=True)

    # Generate QR code
    qr_data = vcard.get_qr_code_data()
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_H,
        box_size=15,
        border=4,
    )
    qr.add_data(qr_data)
    qr.make(fit=True)

    # Create QR code image with basic colors
    qr_img = qr.make_image(
        fill_color=vcard.qr_foreground_color if vcard.qr_foreground_color != '#000000' else 'black',
        back_color=vcard.qr_background_color if vcard.qr_background_color != '#FFFFFF' else 'white'
    )

    # Convert to PIL Image for further processing
    qr_img = qr_img.get_image()

    # Add logo if exists
    if vcard.qr_logo:
        try:
            logo = Image.open(vcard.qr_logo.path)

            # Convert logo to RGB if necessary
            if logo.mode != 'RGB':
                logo = logo.convert('RGB')

            # Calculate logo size (percentage of QR code size)
            qr_width, qr_height = qr_img.size
            logo_size = min(qr_width, qr_height) * (vcard.qr_logo_size / 100)

            # Resize logo maintaining aspect ratio
            logo.thumbnail((logo_size, logo_size), Image.Resampling.LANCZOS)

            # Calculate position to center logo on QR code
            pos = ((qr_width - logo.width) // 2, (qr_height - logo.height) // 2)

            # Create a transparent background for the logo
            logo_with_bg = Image.new('RGBA', qr_img.size, (0, 0, 0, 0))
            logo_with_bg.paste(logo, pos)

            # Convert QR code to RGBA
            qr_img_rgba = qr_img.convert('RGBA')

            # Composite the logo onto the QR code
            qr_img = Image.alpha_composite(qr_img_rgba, logo_with_bg)

        except Exception as e:
            print(f"Error adding logo to QR code: {e}")

    # Convert to base64 for display
    buffer = BytesIO()
    qr_img.save(buffer, format="PNG")
    buffer.seek(0)
    img_str = base64.b64encode(buffer.getvalue()).decode()

    return render(request, 'vcard/qr_display.html', {
        'vcard': vcard,
        'qr_image': img_str,
        'qr_data': qr_data
    })
