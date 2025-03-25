from django.contrib import admin
from app_accounts.models import UserProfile, Language
from django.utils.html import format_html


class UserProfileAdmin(admin.ModelAdmin):
    def user_full_name(self, obj):
        return f"{obj.user.first_name} {obj.user.last_name}"
    user_full_name.short_description = 'Full Name'

    def thumbnail(self, object):
        return format_html("<img src='{}' style='width:40px; border-radius:20%;'> ".format(object.photo.url))
    thumbnail.short_description = 'Photo'

    list_display = ('id', 'user', 'thumbnail', 'user_full_name', 'country', 'lang_native', 'rating', 'user_type', 'is_vip')
    list_display_links = ('user', 'thumbnail', )
    list_filter = ('user_type', 'gender', 'rating', 'is_vip', 'country')
    search_fields = ('user__username', 'country', 'lang_native', 'user_type')


class LanguageAdmin(admin.ModelAdmin):
    ordering = ('name',)


admin.site.register(UserProfile, UserProfileAdmin)
admin.site.register(Language, LanguageAdmin)