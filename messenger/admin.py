from django.contrib import admin
from django.contrib.auth import get_user_model
from .models import Thread, Message, UserMessageSettings

User = get_user_model()


class MessageInline(admin.TabularInline):
    model = Message
    extra = 0
    readonly_fields = ('sent_at', 'read_at')
    fields = ('sender', 'recipient', 'content', 'is_read', 'sent_at', 'read_at')


class ParticipantFilter(admin.SimpleListFilter):
    title = 'participant'
    parameter_name = 'participant'

    def lookups(self, request, model_admin):
        return [(user.id, user.username) for user in User.objects.all()]

    def queryset(self, request, queryset):
        if self.value():
            return queryset.filter(participants__id=self.value())
        return queryset


@admin.register(Thread)
class ThreadAdmin(admin.ModelAdmin):
    list_display = ('id', 'participants_list', 'created_at', 'updated_at', 'is_active')
    list_filter = (ParticipantFilter, 'is_active', 'created_at')
    search_fields = ('participants__username',)
    inlines = [MessageInline]

    def participants_list(self, obj):
        return ", ".join([u.username for u in obj.participants.all()])

    participants_list.short_description = 'Participants'

    def save_model(self, request, obj, form, change):
        # First save to create ID
        super().save_model(request, obj, form, change)
        # Now set participants
        obj.participants.set(form.cleaned_data['participants'])


@admin.register(Message)
class MessageAdmin(admin.ModelAdmin):
    list_display = ('id', 'thread', 'sender', 'recipient', 'truncated_content', 'sent_at', 'is_read')
    list_filter = ('is_read', 'sent_at', 'sender', 'recipient')
    search_fields = ('content', 'sender__username', 'recipient__username')
    readonly_fields = ('sent_at', 'read_at')

    def truncated_content(self, obj):
        return obj.content[:50] + '...' if len(obj.content) > 50 else obj.content

    truncated_content.short_description = 'Content'


@admin.register(UserMessageSettings)
class UserMessageSettingsAdmin(admin.ModelAdmin):
    list_display = ('user', 'email_notifications', 'push_notifications', 'allow_messages_from')
    list_filter = ('email_notifications', 'push_notifications', 'allow_messages_from')
    search_fields = ('user__username',)
    filter_horizontal = ('blocked_users',)
    raw_id_fields = ('user',)

#
# class UserProfileInline(admin.StackedInline):
#     model = UserProfile
#     can_delete = False
#     verbose_name_plural = 'Profile'
#     filter_horizontal = ('lang_speak',)

#
# class UserAdmin(admin.ModelAdmin):
#     inlines = (UserProfileInline,)
#     list_display = ('username', 'email', 'get_user_type', 'is_active')
#
#     def get_user_type(self, obj):
#         return obj.profile.user_type
#
#     get_user_type.short_description = 'User Type'
#
#
# # Unregister default User admin and register custom one
# admin.site.unregister(User)
# admin.site.register(User, UserAdmin)

#
# @admin.register(UserProfile)
# class UserProfileAdmin(admin.ModelAdmin):
#     list_display = ('user', 'user_type', 'is_active', 'meeting_method', 'country', 'city')
#     list_filter = ('user_type', 'is_active', 'meeting_method', 'country')
#     search_fields = ('user__username', 'city', 'country')
#     filter_horizontal = ('lang_speak',)
#     readonly_fields = ('create_date', 'last_modified')
#     fieldsets = (
#         ('Basic Info', {
#             'fields': ('user', 'user_type', 'photo', 'gender', 'title', 'bio')
#         }),
#         ('Language', {
#             'fields': ('lang_native', 'lang_speak')
#         }),
#         ('Contact', {
#             'fields': ('phone_country_code', 'phone_number', 'phone_verified')
#         }),
#         ('Availability', {
#             'fields': ('availability', 'is_vip', 'is_active')
#         }),
#         ('Location', {
#             'fields': ('meeting_method', 'country', 'city',
#                        'latitude', 'longitude', 'meeting_radius')
#         }),
#         ('Verification', {
#             'fields': ('is_email_verified', 'email_verification_token')
#         }),
#         ('Timestamps', {
#             'fields': ('create_date', 'last_modified')
#         }),
#     )
