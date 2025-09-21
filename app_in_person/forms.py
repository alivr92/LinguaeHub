from django import forms
from .models import InPersonService, InPersonRequest
from django.utils import timezone
from datetime import date


class InPersonRequestForm(forms.ModelForm):
    # You might want to let them choose from active services
    service = forms.ModelChoiceField(
        queryset=InPersonService.objects.filter(is_active=True),
        empty_label="Select a service type",
        widget=forms.Select(attrs={
            'class': 'form-select js-choice border-1 z-index-9 bg-transparent',
            'aria-label': 'Select service type',
            'required': 'required',
        }),
        help_text="What kind of help are you looking for?"
    )

    # Keep the notes field from the model
    student_notes = forms.CharField(
        widget=forms.Textarea(attrs={
            'class': 'form-control',
            'rows': 3,
            'placeholder': 'Please describe your specific goals, e.g., "I need to prepare for a job interview in English" or "I want to improve my conversation skills for an upcoming trip."'
        }),
        required=False,
        help_text="Any specific details for the tutor?"
    )

    preferred_start_date = forms.DateField(
        widget=forms.DateInput(attrs={
            'class': 'form-control',
            'type': 'date',
            'min': date.today().isoformat(),  # Prevent selecting past dates
        }),
        help_text="When would you ideally like to start?"
    )

    number_of_sessions = forms.IntegerField(
        min_value=1,
        initial=1,
        widget=forms.NumberInput(attrs={
            'class': 'form-control',
            'placeholder': 'e.g., 4',
        }),
        help_text="How many sessions are you looking for initially?"
    )

    session_duration_hours = forms.DecimalField(
        min_value=0.5,
        max_value=4,
        initial=1.5,
        decimal_places=1,
        widget=forms.NumberInput(attrs={
            'class': 'form-control',
            'step': '0.5',  # Allow 0.5 hour increments (30 mins, 1h, 1.5h, etc.)
            'placeholder': 'e.g., 1.5',
        }),
        help_text="Duration of each session (in hours)."
    )

    class Meta:
        model = InPersonRequest
        fields = ['service', 'student_notes', 'preferred_start_date', 'number_of_sessions', 'session_duration_hours']
        # exclude = ['student', 'status', 'created_at', 'updated_at', 'accepted_offer']

    def __init__(self, *args, **kwargs):
        # Get the user from the keyword arguments and pop it so it doesn't break the parent init
        self.user = kwargs.pop('user', None)
        super().__init__(*args, **kwargs)

    def clean_preferred_start_date(self):
        data = self.cleaned_data['preferred_start_date']
        if data < date.today():
            raise forms.ValidationError("The start date cannot be in the past.")
        return data

    def save(self, commit=True):
        # Link the request to the logged-in student before saving
        instance = super().save(commit=False)
        instance.student = self.user
        if commit:
            instance.save()
        return instance


class RescheduleRequestForm(forms.Form):
    new_date = forms.DateField(
        widget=forms.DateInput(attrs={
            'class': 'form-control',
            'type': 'date',
            'min': date.today().isoformat()
        }),
        help_text="Select new date for the session"
    )
    new_time = forms.TimeField(
        widget=forms.TimeInput(attrs={
            'class': 'form-control',
            'type': 'time'
        }),
        help_text="Select new time"
    )
    reason = forms.CharField(
        widget=forms.Textarea(attrs={
            'class': 'form-control',
            'rows': 3,
            'placeholder': 'Please explain why you need to reschedule...'
        }),
        required=False,
        help_text="Reason for rescheduling (optional)"
    )

    def clean_new_date(self):
        data = self.cleaned_data['new_date']
        if data < date.today():
            raise forms.ValidationError("Cannot reschedule to a past date.")
        return data


class SessionCompletionForm(forms.Form):
    notes = forms.CharField(
        widget=forms.Textarea(attrs={
            'class': 'form-control',
            'rows': 4,
            'placeholder': 'Session notes, progress, homework assigned...'
        }),
        required=False,
        help_text="Session summary and notes"
    )
    materials_used = forms.CharField(
        widget=forms.TextInput(attrs={
            'class': 'form-control',
            'placeholder': 'e.g., Textbook Chapter 3, Worksheet A'
        }),
        required=False,
        help_text="Materials used during the session"
    )
    next_steps = forms.CharField(
        widget=forms.Textarea(attrs={
            'class': 'form-control',
            'rows': 2,
            'placeholder': 'What to cover in the next session...'
        }),
        required=False,
        help_text="Plan for next session"
    )
    rating = forms.IntegerField(
        min_value=1,
        max_value=5,
        widget=forms.NumberInput(attrs={
            'class': 'form-control',
            'type': 'range',
            'min': '1',
            'max': '5'
        }),
        help_text="Student performance rating (1-5)",
        required=False
    )
