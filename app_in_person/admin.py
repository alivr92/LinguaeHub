from django.contrib import admin
from django.utils.html import format_html
from django.urls import reverse
from .models import InPersonService, InPersonRequest, InPersonOffer
from django.contrib import messages
from django.contrib.auth.models import User


@admin.register(InPersonService)
class InPersonServiceAdmin(admin.ModelAdmin):
    list_display = (
        'name', 'category', 'student_price_per_hour', 'tutor_payout_per_hour', 'is_active', 'implied_commission')
    list_filter = ('category', 'is_active')
    list_editable = ('is_active', 'student_price_per_hour', 'tutor_payout_per_hour')  # Allow quick edits
    search_fields = ('name', 'category')
    ordering = ('category', 'name')

    def implied_commission(self, obj):
        """Calculate and display the commission percentage"""
        if obj.student_price_per_hour > 0:
            commission = (obj.student_price_per_hour - obj.tutor_payout_per_hour) / obj.student_price_per_hour * 100
            return f"{commission:.1f}%"
        return "N/A"

    implied_commission.short_description = 'Commission'


@admin.register(InPersonRequest)
class InPersonRequestAdmin(admin.ModelAdmin):
    list_display = ('id', 'get_student_name', 'service', 'status', 'preferred_start_date', 'number_of_sessions',
                    'session_duration_hours', 'total_student_value', 'created_at', 'accepted_offer_link')
    list_filter = ('status', 'service__category', 'created_at')
    list_editable = ('status',)
    search_fields = ('user__username', 'user__first_name', 'user__last_name', 'service__name')
    readonly_fields = ('created_at', 'updated_at', 'total_student_value', 'total_tutor_payout', 'accepted_offer_link')

    # Filter the form to only show student users
    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "user":
            kwargs["queryset"] = User.objects.filter(profile__user_type='student')
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    def get_student_name(self, obj):
        return obj.user.get_full_name() or obj.user.username

    get_student_name.short_description = 'Student'
    get_student_name.admin_order_field = 'user__first_name'

    # ADD THIS MISSING METHOD
    def accepted_offer_link(self, obj):
        if obj.accepted_offer:
            url = reverse('admin:app_in_person_inpersonoffer_change', args=[obj.accepted_offer.id])
            return format_html('<a href="{}">View Accepted Offer (#{})</a>', url, obj.accepted_offer.id)
        return "—"

    accepted_offer_link.short_description = 'Accepted Offer'

    # ADD THESE PROPERTY METHODS IF THEY DON'T EXIST
    def total_student_value(self, obj):
        return obj.total_student_value

    total_student_value.short_description = 'Total Value'

    def total_tutor_payout(self, obj):
        return obj.total_tutor_payout

    total_tutor_payout.short_description = 'Tutor Payout'


@admin.register(InPersonOffer)
class InPersonOfferAdmin(admin.ModelAdmin):
    list_display = (
        'id', 'get_tutor_name', 'request', 'status', 'total_payout', 'sent_at', 'expires_at', 'responded_at',
        'is_expired_display')
    list_filter = ('status', 'sent_at', 'expires_at')
    search_fields = ('user__username', 'request__user__username', 'request__service__name')
    readonly_fields = (
        'sent_at', 'responded_at', 'is_expired_display', 'accept_token', 'decline_token', 'request_link', 'user_link')
    list_select_related = ('user', 'request', 'request__user')  # For performance

    # CRITICAL: Filter the form to only show tutor users
    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "user":
            # Only show users who have a tutor profile or are marked as tutors
            kwargs["queryset"] = User.objects.filter(profile__user_type='tutor')
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    def get_tutor_name(self, obj):
        return obj.user.get_full_name() or obj.user.username

    get_tutor_name.short_description = 'Tutor'
    get_tutor_name.admin_order_field = 'user__first_name'

    def is_expired_display(self, obj):
        return obj.is_expired()

    is_expired_display.boolean = True
    is_expired_display.short_description = 'Expired?'

    def request_link(self, obj):
        url = reverse('admin:app_in_person_inpersonrequest_change', args=[obj.request.id])
        return format_html('<a href="{}">{}</a>', url, obj.request)

    request_link.short_description = 'Request'

    def user_link(self, obj):
        url = reverse('admin:auth_user_change', args=[obj.user.id])
        return format_html('<a href="{}">{}</a>', url, obj.user.get_full_name() or obj.user.username)

    user_link.short_description = 'Tutor'
