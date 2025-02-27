from django.contrib import admin
from ap2_tutor.models import Tutor, Skill, SkillLevel
from django.utils.html import format_html


class TutorAdmin(admin.ModelAdmin):

    def thumbnail(self, object):
        return format_html("<img src='{}' style='width:40px; border-radius:20%;'> ".format(object.profile.photo.url))
    thumbnail.short_description = 'Photo'

    list_display = ('id', 'profile', 'thumbnail', 'cost_trial', 'cost_hourly',
                    'session_count',)
    list_display_links = ('profile', 'thumbnail', )
    list_filter = ('cost_trial', 'cost_hourly', )
    search_fields = ('profile', )


class SkillAdmin(admin.ModelAdmin):
    ordering = ('name',)


class SkillLevelAdmin(admin.ModelAdmin):
    ordering = ('name',)


admin.site.register(Tutor, TutorAdmin)
admin.site.register(Skill, SkillAdmin)
admin.site.register(SkillLevel, SkillLevelAdmin)
