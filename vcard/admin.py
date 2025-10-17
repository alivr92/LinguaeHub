from django.contrib import admin
from .models import VCardPage, VCardAnalytics, QRCodeScan


@admin.register(VCardPage)
class VCardPageAdmin(admin.ModelAdmin):
    list_display = [
        'company_name', 'slug', 'phone_number', 'email',
        'total_views', 'total_qr_scans', 'last_accessed', 'is_active'
    ]
    list_filter = ['is_active', 'created_at']
    search_fields = ['company_name', 'email', 'phone_number', 'mobile_number']
    readonly_fields = [
        'slug', 'qr_code_secret', 'created_at', 'updated_at',
        'total_views', 'total_qr_scans', 'last_accessed'
    ]

    fieldsets = (
        ('Basic Information', {
            'fields': ('user', 'company_name', 'tagline', 'slug', 'is_active')
        }),
        ('Visual Design', {
            'fields': ('logo', 'background_photo', 'primary_color', 'secondary_color'),
            'classes': ('collapse',)
        }),
        ('Contact Information', {
            'fields': ('phone_number', 'mobile_number', 'email', 'website', 'contact_form_link', 'address')
        }),
        ('Additional Information', {
            'fields': ('bio',),
            'classes': ('collapse',)
        }),
        ('Social Media', {
            'fields': ('facebook', 'twitter', 'linkedin', 'instagram', 'whatsapp', 'telegram', 'youtube'),
            'classes': ('collapse',)
        }),
        ('QR Code Settings', {
            'fields': ('qr_code_secret', 'qr_code_enabled'),
            'classes': ('collapse',)
        }),
        ('QR Code Customization', {
            'fields': (
                'qr_logo',
                'qr_style',
                'qr_foreground_color',
                'qr_background_color',
                'qr_logo_size'
            ),
            'classes': ('collapse',)
        }),
        ('Analytics', {
            'fields': ('total_views', 'total_qr_scans', 'last_accessed'),
            'classes': ('collapse',)
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )


@admin.register(VCardAnalytics)
class VCardAnalyticsAdmin(admin.ModelAdmin):
    list_display = ['vcard', 'event_type', 'timestamp', 'ip_address']
    list_filter = ['event_type', 'timestamp']
    search_fields = ['vcard__company_name', 'ip_address']
    readonly_fields = ['timestamp']


@admin.register(QRCodeScan)
class QRCodeScanAdmin(admin.ModelAdmin):
    list_display = ['vcard', 'scanned_at', 'ip_address']
    list_filter = ['scanned_at']
    search_fields = ['vcard__company_name', 'ip_address']
    readonly_fields = ['scanned_at']
