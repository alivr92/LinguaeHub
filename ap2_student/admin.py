from django.contrib import admin
from ap2_student.models import Student, CNotification
from django.utils.html import format_html


class StudentAdmin(admin.ModelAdmin):

    def thumbnail(self, object):
        return format_html("<img src='{}' style='width:40px; border-radius:20%;'> ".format(object.profile.photo.url))

    thumbnail.short_description = 'Photo'

    list_display = ('id', 'profile', 'thumbnail', 'major', 'session_count',)
    list_display_links = ('profile', 'thumbnail',)
    list_filter = ('major', 'session_count',)
    search_fields = ('profile',)


class CNotificationAdmin(admin.ModelAdmin):
    list_display = ('client', 'appointment', 'type', 'seen', 'date')


admin.site.register(Student, StudentAdmin)
admin.site.register(CNotification, CNotificationAdmin)
