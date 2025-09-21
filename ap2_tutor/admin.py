from django.contrib import admin
from ap2_tutor.models import (Tutor, PNotification, ProviderApplication, TeachingCertificate,
                              TeachingCategory, TeachingSubCategory)
from django.utils.html import format_html


@admin.register(ProviderApplication)
class ProviderApplicationAdmin(admin.ModelAdmin):
    def thumbnail(self, object):
        return format_html(
            "<img src='{}' style='width:40px; height:40px; border-radius:20%;'> ".format(object.photo.url))

    thumbnail.short_description = 'Photo'
    list_display = ['id', 'first_name', 'last_name', 'thumbnail', 'email', 'phone', 'lang_native', 'status',
                    'date_submitted']
    list_display_links = ['first_name', ]
    list_filter = ['first_name', 'last_name', 'lang_native', 'status', 'date_submitted']
    search_fields = ['first_name', 'last_name', 'email', 'phone', 'lang_native', 'status', 'date_submitted']
    list_editable = ['status', ]


@admin.register(Tutor)
class TutorAdmin(admin.ModelAdmin):

    def thumbnail(self, object):
        return format_html("<img src='{}' style='width:40px; border-radius:20%;'> ".format(object.profile.photo.url))

    thumbnail.short_description = 'Photo'

    list_display = ('id', 'profile', 'thumbnail', 'cost_trial', 'cost_hourly', 'discount', 'discount_deadline',
                    'session_count', 'status')
    list_display_links = ('profile', 'thumbnail',)
    list_editable = ('discount', 'status')
    list_filter = ('cost_trial', 'cost_hourly',)
    search_fields = ('profile', 'profile__user__first_name', 'profile__user__last_name')


class PNotificationAdmin(admin.ModelAdmin):
    list_display = ('provider', 'appointment', 'type', 'seen', 'date')


admin.site.register(PNotification, PNotificationAdmin)


# @admin.register(DegreeLevel)

@admin.register(TeachingCategory)
class TeachingCategoryAdmin(admin.ModelAdmin):
    list_display = ('name',)


@admin.register(TeachingSubCategory)
class TeachingSubCategoryAdmin(admin.ModelAdmin):
    list_display = ('category', 'name')


@admin.register(TeachingCertificate)
class TeachingCertificateAdmin(admin.ModelAdmin):
    list_display = ('user', 'name', 'issuing_organization', 'is_certified',)
    list_editable = ['is_certified', ]
