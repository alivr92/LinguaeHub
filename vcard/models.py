from django.db import models
from django.contrib.auth.models import User
from django.urls import reverse
from django.utils.crypto import get_random_string
from django.utils import timezone


class VCardPage(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    slug = models.SlugField(unique=True, max_length=100)
    company_name = models.CharField(max_length=200)
    tagline = models.CharField(max_length=300, blank=True, null=True)

    # Contact Information
    phone_number = models.CharField(max_length=20)
    mobile_number = models.CharField(max_length=20, blank=True, null=True)
    email = models.EmailField()
    website = models.URLField()
    contact_form_link = models.URLField(blank=True, null=True)

    # Additional Fields
    address = models.TextField(blank=True, null=True)
    bio = models.TextField(blank=True, null=True)

    # Visual Elements
    logo = models.ImageField(upload_to='vcard/logos/', blank=True, null=True)
    background_photo = models.ImageField(upload_to='vcard/backgrounds/', blank=True, null=True)
    primary_color = models.CharField(max_length=7, default='#0d6efd')  # Bootstrap primary
    secondary_color = models.CharField(max_length=7, default='#6f42c1')  # Bootstrap purple

    # Social Media Links
    facebook = models.URLField(blank=True, null=True)
    twitter = models.URLField(blank=True, null=True)
    linkedin = models.URLField(blank=True, null=True)
    instagram = models.URLField(blank=True, null=True)
    whatsapp = models.URLField(blank=True, null=True)
    telegram = models.URLField(blank=True, null=True)
    youtube = models.URLField(blank=True, null=True)

    # Settings
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    # QR Code settings
    qr_code_secret = models.CharField(max_length=50, blank=True)
    qr_code_enabled = models.BooleanField(default=True)

    # QR Code Customization
    qr_logo = models.ImageField(upload_to='vcard/qr_logos/', blank=True, null=True)
    qr_style = models.CharField(
        max_length=20,
        choices=[
            ('square', 'Square Dots'),
            ('rounded', 'Rounded Dots'),
            ('circle', 'Circular Dots'),
            ('diamond', 'Diamond Dots'),
        ],
        default='square'
    )
    qr_foreground_color = models.CharField(max_length=7, default='#000000')
    qr_background_color = models.CharField(max_length=7, default='#FFFFFF')
    qr_logo_size = models.PositiveIntegerField(default=80, help_text="Logo size in percentage (20-100)")

    # Analytics
    total_views = models.PositiveIntegerField(default=0)
    total_qr_scans = models.PositiveIntegerField(default=0)
    last_accessed = models.DateTimeField(null=True, blank=True)

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = get_random_string(8)
        if not self.qr_code_secret:
            self.qr_code_secret = get_random_string(32)
        super().save(*args, **kwargs)

    def get_absolute_url(self):
        return reverse('vcard:vcard_page', kwargs={'slug': self.slug})

    def get_qr_code_data(self):
        from django.conf import settings
        domain = getattr(settings, 'SITE_DOMAIN', 'https://lingocept.com')
        return f"{domain}{self.get_absolute_url()}?token={self.qr_code_secret}"

    def record_view(self):
        self.total_views += 1
        self.last_accessed = timezone.now()
        self.save(update_fields=['total_views', 'last_accessed'])

    def record_qr_scan(self):
        self.total_qr_scans += 1
        self.last_accessed = timezone.now()
        self.save(update_fields=['total_qr_scans', 'last_accessed'])

    def get_social_links(self):
        social_links = []
        platforms = [
            ('facebook', 'Facebook', 'bi-facebook'),
            ('twitter', 'Twitter', 'bi-twitter'),
            ('linkedin', 'LinkedIn', 'bi-linkedin'),
            ('instagram', 'Instagram', 'bi-instagram'),
            ('whatsapp', 'WhatsApp', 'bi-whatsapp'),
            ('telegram', 'Telegram', 'bi-telegram'),
            ('youtube', 'YouTube', 'bi-youtube'),
        ]

        for field, name, icon in platforms:
            url = getattr(self, field)
            if url:
                social_links.append((name, icon, url))
        return social_links

    def __str__(self):
        return f"vCard - {self.company_name}"


class VCardAnalytics(models.Model):
    vcard = models.ForeignKey(VCardPage, on_delete=models.CASCADE, related_name='analytics')
    timestamp = models.DateTimeField(auto_now_add=True)
    event_type = models.CharField(max_length=20, choices=[
        ('page_view', 'Page View'),
        ('qr_scan', 'QR Scan'),
        ('phone_click', 'Phone Click'),
        ('email_click', 'Email Click'),
        ('website_click', 'Website Click'),
        ('social_click', 'Social Media Click'),
    ])
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    user_agent = models.TextField(blank=True)
    referrer = models.URLField(blank=True, null=True)

    class Meta:
        indexes = [
            models.Index(fields=['vcard', 'timestamp']),
            models.Index(fields=['event_type', 'timestamp']),
        ]
        verbose_name_plural = 'VCard Analytics'


class QRCodeScan(models.Model):
    vcard = models.ForeignKey(VCardPage, on_delete=models.CASCADE, related_name='qr_scans')
    scanned_at = models.DateTimeField(auto_now_add=True)
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    user_agent = models.TextField(blank=True)
    location_data = models.JSONField(null=True, blank=True)  # Store geolocation data

    class Meta:
        indexes = [
            models.Index(fields=['vcard', 'scanned_at']),
        ]
