from django import forms
from django.utils import timezone
from ap2_meeting.models import Session, AppointmentSetting
from ap2_tutor.models import Tutor
from ap2_student.models import Student


class AppointmentSettingForm(forms.ModelForm):
    class Meta:
        model = AppointmentSetting
        fields = ['session_length', 'timezone', 'week_start', 'session_type']
        widgets = {
            'session_length': forms.Select(attrs={'class': 'form-control form-select'}),
            'timezone': forms.Select(attrs={'class': 'form-control form-select'}),
            'week_start': forms.Select(attrs={'class': 'form-control form-select form-select-sm'}),
            'session_type': forms.RadioSelect(attrs={'class': 'btn-check'})
        }


class SessionForm(forms.ModelForm):
    class Meta:
        model = Session
        fields = [
            'subject', 'session_type', 'provider', 'clients',
            'start_session_utc', 'end_session_utc', 'status',
            'rescheduled_by', 'is_rescheduled'
        ]
        widgets = {
            'start_session_utc': forms.DateTimeInput(attrs={'type': 'datetime-local'}),
            'end_session_utc': forms.DateTimeInput(attrs={'type': 'datetime-local'}),
            # 'rescheduled_start': forms.DateTimeInput(attrs={'type': 'datetime-local'}),
            'clients': forms.SelectMultiple(attrs={'class': 'form-control'}),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # Customize the queryset for the tutor field (optional)
        self.fields['provider'].queryset = Tutor.objects.all()
        # Customize the queryset for the students field (optional)
        self.fields['clients'].queryset = Student.objects.all()

    def clean(self):
        cleaned_data = super().clean()
        start_session_utc = cleaned_data.get('start_session_utc')
        end_session_utc = cleaned_data.get('end_session_utc')
        provider = cleaned_data.get('provider')

        # Ensure start_session is before end_session
        if start_session_utc and end_session_utc and start_session_utc >= end_session_utc:
            raise forms.ValidationError("The session start time must be before the end time.")

        # Check for overlapping sessions for the same provider (tutor)
        if start_session_utc and end_session_utc and provider:
            overlapping_sessions = Session.objects.filter(
                provider=provider,
                start_session_utc__lt=end_session_utc,
                end_session_utc__gt=start_session_utc,
            ).exclude(id=self.instance.id)  # Exclude the current session when updating

            if overlapping_sessions.exists():
                raise forms.ValidationError("This session overlaps with another session for the same tutor.")

        return cleaned_data
