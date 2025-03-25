from django.contrib import admin
from ap2_meeting.models import Session, Availability, AppointmentSetting, Review
from django import forms
from django.core.exceptions import ValidationError


class SessionAdminForm(forms.ModelForm):
    class Meta:
        model = Session
        fields = '__all__'

    def clean(self):
        cleaned_data = super().clean()
        students = cleaned_data.get('students')
        session_type = cleaned_data.get('session_type')

        if session_type == 'private' and students and len(students) > 1:
            raise ValidationError('A Private session can only have one student.')
        if session_type == 'group' and students and len(students) < 2:
            raise ValidationError('A Group session needs at least two students or more!')

        return cleaned_data


class SessionAdmin(admin.ModelAdmin):
    form = SessionAdminForm
    list_display = ('id', 'subject', 'session_type', 'appointment_id', 'tutor', 'get_students', 'students_timezone', 'start_session_utc',
                    'end_session_utc', 'status')
    list_display_links = ('subject',)
    list_filter = ('subject', 'session_type', 'tutor', 'students', 'start_session_utc', 'status')
    search_fields = ('subject', 'appointment_id', 'tutor__profile__user__username', 'students__profile__user__username',)

    def get_students(self, obj):
        return ", ".join([stu.profile.user.username for stu in obj.students.all()])

    get_students.short_description = 'Students'

    def save_model(self, request, obj, form, change):
        # Save the main object first, so it gets an ID
        obj.save()
        # Then save the many-to-many relationships
        form.save_m2m()


class AvailabilityAdmin(admin.ModelAdmin):
    list_display = ('id', 'tutor', 'tutor_timezone', 'start_time_utc', 'end_time_utc', 'status', 'is_available')
    list_display_links = ('tutor',)
    list_filter = ('tutor', 'status')
    search_fields = ('id', 'tutor_timezone', 'start_time_utc', 'end_time_utc',)


class AppointmentSettingAdmin(admin.ModelAdmin):
    list_display = ('id', 'tutor', 'provider_timezone', 'session_length', 'week_start', 'session_type')


class ReviewAdmin(admin.ModelAdmin):
    list_display = ('student', 'tutor', 'session_appointment_id', 'session_subject', 'rate_tutor', 'rate_session', 'status', 'is_published')
    list_editable = ('is_published', 'status', )
    list_filter = ('tutor', 'student', 'session', 'rate_tutor', 'status', 'is_published')
    search_fields = ('session_appointment_id', )

    def session_subject(self, obj):
        return obj.session.subject if obj.session else "No Session"

    session_subject.short_description = 'Session Subject'

    def session_appointment_id(self, obj):
            return obj.session.appointment_id if obj.session else "No Session"

    session_appointment_id.short_description = 'Session ID'


admin.site.register(Session, SessionAdmin)
admin.site.register(Availability, AvailabilityAdmin)
admin.site.register(AppointmentSetting, AppointmentSettingAdmin)
admin.site.register(Review, ReviewAdmin)

#
# class SessionAdminForm(forms.ModelForm):
#     class Meta:
#         model = Session
#         fields = '__all__'
#
#     def clean_students(self):
#         students = self.cleaned_data.get('students')
#         session_type = self.cleaned_data.get('session_type')
#         if session_type == 'private' and len(students) > 1:
#             raise ValidationError('A Private session can only have one student.')
#         if session_type == 'group' and len(students) < 2:
#             raise ValidationError('A Group session needs at least two students or more!')
#         return students
#
#
# class SessionAdmin(admin.ModelAdmin):
#     form = SessionAdminForm
#     list_display = ('id', 'subject', 'session_type', 'tutor', 'get_students', 'start_session_utc', 'end_session_utc')
#     list_display_links = ('subject',)
#     list_filter = ('subject', 'session_type', 'tutor', 'students', 'start_session_utc')
#     search_fields = ('subject', 'tutor', 'students',)
#
#     def get_students(self, obj):
#         return ", ".join([stu.profile.user.username for stu in obj.students.all()])
#     get_students.short_description = 'Students'
#
#     def save_model(self, request, obj, form, change):
#         # Save the main object first, so it gets an ID
#         obj.save()
#         # Then save the many-to-many relationships
#         form.save_m2m()
#
# admin.site.register(Session, SessionAdmin)
