from django.contrib import admin
from ap2_tutor.models import Tutor, Skill, SkillLevel, PNotification
from django.utils.html import format_html


class TutorAdmin(admin.ModelAdmin):

    def thumbnail(self, object):
        return format_html("<img src='{}' style='width:40px; border-radius:20%;'> ".format(object.profile.photo.url))

    thumbnail.short_description = 'Photo'

    list_display = (
    'id', 'profile', 'thumbnail', 'cost_trial', 'cost_hourly', 'discount', 'discount_deadline', 'session_count',)
    list_display_links = ('profile', 'thumbnail',)
    list_editable = ('discount', 'discount_deadline',)
    list_filter = ('cost_trial', 'cost_hourly',)
    search_fields = ('profile', 'profile__user__first_name', 'profile__user__last_name')


class SkillAdmin(admin.ModelAdmin):
    ordering = ('name',)


class SkillLevelAdmin(admin.ModelAdmin):
    ordering = ('name',)


class PNotificationAdmin(admin.ModelAdmin):
    list_display = ('provider', 'appointment', 'type', 'seen', 'date')


admin.site.register(Tutor, TutorAdmin)
admin.site.register(Skill, SkillAdmin)
admin.site.register(SkillLevel, SkillLevelAdmin)
admin.site.register(PNotification, PNotificationAdmin)
