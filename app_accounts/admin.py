from django.contrib import admin
from app_accounts.models import (UserProfile, Language, UserSkill, Level, SkillCategory, Skill, UserSpecialization,
                                 UserEducation, DegreeLevel, LoginIPLog, UserConsentLog, SecurityEvent)
from django.utils.html import format_html
from utils.trackers import get_client_ip
from django.contrib.auth import get_user_model
from django.urls import reverse
import json

User = get_user_model()


class UserProfileAdmin111(admin.ModelAdmin):
    def user_full_name(self, obj):
        return f"{obj.user.first_name} {obj.user.last_name}"

    user_full_name.short_description = 'Full Name'

    def thumbnail(self, object):
        return format_html("<img src='{}' style='width:40px; border-radius:20%;'> ".format(object.photo.url))

    thumbnail.short_description = 'Photo'

    def dipslay_lang_speak(self, obj):
        return " ,".join([lang.name for lang in obj.lang_speak.all()])

    dipslay_lang_speak.short_description = 'Spoken Languages'

    list_display = (
        'id', 'user', 'thumbnail', 'user_full_name', 'country', 'lang_native', 'dipslay_lang_speak', 'rating',
        'user_type', 'is_vip', 'is_active', 'is_email_verified')
    list_display_links = ('user', 'thumbnail',)
    list_editable = ('is_active', 'is_vip', 'is_email_verified')
    list_filter = ('user_type', 'gender', 'rating', 'is_vip', 'country', 'lang_speak__name',)
    search_fields = ('user__username', 'country', 'lang_native', 'lang_speak__name', 'user_type')

    # fieldsets = (
    #     ('General Info', {
    #         'fields': ( 'user', 'user_type', 'is_vip', 'is_active',
    #                    'is_email_verified')
    #     }),
    #     ('In Person Info', {
    #         'fields': ('country', 'city', 'latitude', 'longitude', 'meeting_radius', 'meeting_location', 'inp_aim',
    #                    'inp_start')
    #     }),
    #     ('Language Info', {
    #         'fields': ('lang_native', )
    #     }),
    #     ('Rating Info', {
    #         'fields': ('rating',)
    #     }),
    # )
    fieldsets = (
        ('User Connection', {
            'fields': ('user',)
        }),
        ('Basic Information', {
            'fields': (
                'user_type', 'gender', 'title', 'photo', 'bio', 'resume'
            )
        }),
        ('Language Information', {
            'fields': (
                'lang_native', 'lang_speak'
            )
        }),
        ('Contact Information', {
            'fields': (
                'phone_country_code', 'phone_number', 'phone_verified',
                'phone_verification_sent_at'
            )
        }),
        ('Location Information', {
            'fields': (
                'meeting_method', 'country', 'city', 'latitude', 'longitude',
                'meeting_radius', 'meeting_location', 'inp_aim', 'inp_start'
            )
        }),
        ('Rating & Status', {
            'fields': (
                'rating', 'reviews_count', 'availability', 'is_vip', 'is_active'
            )
        }),
        ('Verification & Consent', {
            'fields': (
                'is_email_verified', 'terms_agreed', 'terms_agreed_date',
                'email_consent', 'email_consent_date'
            )
        }),
        ('Tokens & Security', {
            'fields': (
                'email_verification_token', 'email_token_expiry',
                'activation_token', 'token_expiry',
                'password_reset_token', 'pss_token_expiry'
            )
        }),
        ('Timestamps', {
            'fields': (
                'create_date', 'last_modified'
            )
        }),
    )


class UserProfileAdmin(admin.ModelAdmin):
    def user_full_name(self, obj):
        return f"{obj.user.first_name} {obj.user.last_name}"

    user_full_name.short_description = 'Full Name'

    def thumbnail(self, object):
        if object.photo:
            return format_html("<img src='{}' style='width:40px; border-radius:20%;'> ".format(object.photo.url))
        return "No Photo"

    thumbnail.short_description = 'Photo'

    def display_lang_speak(self, obj):
        return ", ".join([lang.name for lang in obj.lang_speak.all()])

    display_lang_speak.short_description = 'Spoken Languages'

    def display_full_phone(self, obj):
        return obj.full_phone if obj.phone_country_code and obj.phone_number else None

    display_full_phone.short_description = 'Phone Number'

    list_display = (
        'id', 'user', 'thumbnail', 'user_full_name', 'user_type', 'gender', 'title',
        'country', 'city', 'lang_native', 'display_lang_speak', 'rating', 'reviews_count',
        'display_full_phone', 'phone_verified', 'meeting_method', 'is_vip',
        'is_active', 'is_email_verified', 'create_date'
    )
    list_display_links = ('user', 'thumbnail',)
    list_editable = ('is_active', 'is_vip', 'is_email_verified')
    list_filter = (
        'user_type', 'gender', 'rating', 'is_vip', 'country', 'lang_speak__name',
        'meeting_method', 'phone_verified', 'is_email_verified', 'availability'
    )
    search_fields = (
        'user__username', 'user__first_name', 'user__last_name', 'country', 'city',
        'lang_native', 'lang_speak__name', 'title', 'phone_number'
    )
    readonly_fields = ('create_date', 'last_modified', 'email_verification_token',
                       'email_token_expiry', 'activation_token', 'token_expiry',
                       'password_reset_token', 'pss_token_expiry')
    filter_horizontal = ('lang_speak',)
    date_hierarchy = 'create_date'

    fieldsets = (
        ('User Connection', {
            'fields': ('user',)
        }),
        ('Basic Information', {
            'fields': (
                'user_type', 'gender', 'title', 'photo', 'bio', 'resume'
            )
        }),
        ('Language Information', {
            'fields': (
                'lang_native', 'lang_speak'
            )
        }),
        ('Contact Information', {
            'fields': (
                'phone_country_code', 'phone_number', 'phone_verified',
                'phone_verification_sent_at'
            )
        }),
        ('Location Information', {
            'fields': (
                'meeting_method', 'country', 'city', 'latitude', 'longitude',
                'meeting_radius', 'meeting_location', 'inp_aim', 'inp_start'
            )
        }),
        ('Rating & Status', {
            'fields': (
                'rating', 'reviews_count', 'availability', 'is_vip', 'is_active'
            )
        }),
        ('Verification & Consent', {
            'fields': (
                'is_email_verified', 'terms_agreed', 'terms_agreed_date',
                'email_consent', 'email_consent_date'
            )
        }),
        ('Tokens & Security', {
            'fields': (
                'email_verification_token', 'email_token_expiry',
                'activation_token', 'token_expiry',
                'password_reset_token', 'pss_token_expiry'
            )
        }),
        ('Timestamps', {
            'fields': (
                'create_date', 'last_modified'
            )
        }),
    )


@admin.register(Language)
class LanguageAdmin(admin.ModelAdmin):
    ordering = ('name',)


@admin.register(SkillCategory)
class SkillCategoryAdmin(admin.ModelAdmin):
    list_display = ['name', ]
    ordering = ('name',)


@admin.register(Skill)
class SkillAdmin(admin.ModelAdmin):
    list_display = ['category', 'name', ]
    ordering = ('category', 'name',)


@admin.register(Level)
class LevelAdmin(admin.ModelAdmin):
    list_display = ['name', ]
    ordering = ('name',)


@admin.register(UserEducation)
class UserEducationAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'degree', 'field_of_study', 'institution', 'start_year', 'end_year', 'status',
                    'is_certified', 'is_notified']
    list_display_links = ['user', ]
    list_editable = ['status', 'is_certified', 'is_notified']
    ordering = ('user',)


@admin.register(DegreeLevel)
class DegreeLevelAdmin(admin.ModelAdmin):
    list_display = ('name', 'order')
    list_editable = ('order',)


@admin.register(UserSkill)
class UserSkillAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'skill', 'level', 'is_certified', 'status', 'is_notified']
    list_display_links = ['user', ]
    list_editable = ['level', 'status', 'is_certified', 'is_notified']
    ordering = ('skill',)


@admin.register(UserSpecialization)
class UserSpecializationAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'specialization', 'is_certified']
    list_display_links = ['user', ]
    ordering = ('specialization',)


admin.site.register(UserProfile, UserProfileAdmin)


@admin.register(LoginIPLog)
class LoginIPLogAdmin(admin.ModelAdmin):
    list_display = (
        'user', 'ip_address', 'location_city', 'location_country',
        'login_time', 'is_new_ip', 'is_flagged'
    )
    list_filter = ('is_flagged', 'is_new_ip', 'location_country')
    search_fields = ('user__username', 'ip_address')
    readonly_fields = ('user', 'ip_address', 'login_time', 'location_city', 'location_country')

    actions = ['mark_as_safe', 'send_alert_email']

    def mark_as_safe(self, request, queryset):
        updated = queryset.update(is_flagged=False)
        self.message_user(request, f"{updated} entries marked as safe.")

    def send_alert_email(self, request, queryset):
        for log in queryset:
            # Integrate with your email utility
            # send_security_alert(log.user, log.ip_address, log.login_time)
            self.message_user(request, f"Alert would be sent to {log.user.email} (IP: {log.ip_address})")

    send_alert_email.short_description = "Send email alerts to selected users"


@admin.register(UserConsentLog)
class UserConsentLogAdmin(admin.ModelAdmin):
    list_display = ('user', 'consent_type', 'consent_version', 'timestamp', 'ip_address', 'location_country')
    list_filter = ('consent_type', 'consent_version', 'location_country')
    search_fields = ('user__username', 'ip_address', 'consent_type')
    readonly_fields = ('user', 'consent_type', 'timestamp', 'ip_address')


@admin.register(SecurityEvent)
class SecurityEventAdmin(admin.ModelAdmin):
    list_display = ('event_type', 'display_user', 'ip_address', 'timestamp', 'short_reason')
    list_filter = ('event_type', 'timestamp')
    search_fields = ('ip_address', 'attempted_username', 'user__username', 'reason')
    readonly_fields = ('formatted_details', 'timestamp')
    date_hierarchy = 'timestamp'
    ordering = ('-timestamp',)

    fieldsets = (
        ('Event Info', {
            'fields': ('event_type', 'timestamp', 'path', 'reason')
        }),
        ('User Info', {
            'fields': ('user', 'attempted_username', 'ip_address')
        }),
        ('Technical Details', {
            'fields': ('user_agent', 'formatted_details'),
            'classes': ('collapse',),
        }),
    )

    def display_user(self, obj):
        if obj.user:
            url = reverse('admin:auth_user_change', args=[obj.user.id])
            return format_html('<a href="{}">{}</a>', url, obj.user.username)
        return "Anonymous"

    display_user.short_description = 'User'

    def short_reason(self, obj):
        return obj.reason[:50] + '...' if len(obj.reason) > 50 else obj.reason

    short_reason.short_description = 'Reason'

    def formatted_details(self, obj):
        return format_html('<pre>{}</pre>', json.dumps(obj.details, indent=2))

    formatted_details.short_description = 'Details'

    def has_add_permission(self, request):
        return False  # Prevent manual creation of security events

    def has_change_permission(self, request, obj=None):
        return False  # Make all records read-only
