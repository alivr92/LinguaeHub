from django import forms
from django.contrib.auth.models import User
from django.utils import timezone
from django_recaptcha.fields import ReCaptchaField
from django_recaptcha.widgets import ReCaptchaV2Checkbox
from app_accounts.models import (UserEducation, UserProfile, MEETING_METHOD_CHOICES, MEETING_LOCATION_CHOICES,
                                 COUNTRY_CHOICES, IN_PERSON_AIM_CHOICES)

from django.contrib.auth.forms import UserCreationForm
from django.contrib.auth import get_user_model
import re
import logging

logger = logging.getLogger(__name__)

User = get_user_model()


class RegistrationForm(UserCreationForm):
    # captcha = ReCaptchaField(widget=ReCaptchaV2Checkbox)
    captcha = ReCaptchaField(
        required=True,
        widget=ReCaptchaV2Checkbox(
            attrs={
                'data-theme': 'light',  # or 'dark'
                'data-size': 'normal',  # or 'compact'
            }
        ),
        error_messages={
            'required': 'Please complete the reCAPTCHA verification',
            'invalid': 'Invalid reCAPTCHA. Please try again.'
        }
    )
    # referral_code = forms.CharField(required=False, widget=forms.HiddenInput(), initial='0')  # Empty by default
    utype = forms.CharField(required=False, widget=forms.HiddenInput())
    first_name = forms.CharField(
        max_length=30,
        widget=forms.TextInput(attrs={
            'placeholder': 'First name',
            'class': 'form-control',
        }),
        error_messages={
            'required': 'Please enter a valid name',
            'max_length': 'Name must be max 30 characters'
        }
    )
    last_name = forms.CharField(
        max_length=30,
        widget=forms.TextInput(attrs={
            'placeholder': 'Last name',
            'class': 'form-control',
        })
    )
    terms_agreed = forms.BooleanField(
        required=True,
        widget=forms.CheckboxInput(attrs={
            'class': 'form-check-input',
        })
    )
    email_consent = forms.BooleanField(
        required=False,
        widget=forms.CheckboxInput(attrs={
            'class': 'form-check-input',
        })
    )

    email = forms.EmailField(
        widget=forms.EmailInput(attrs={
            'class': 'form-control',
            'placeholder': 'Email',
            'pattern': '[^@\s]+@[^@\s]+\.[^@\s]+',  # Basic email pattern
        }),
        error_messages={
            'invalid': 'Please enter a valid email address',
        }
    )

    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'email', 'username', 'password1', 'password2']
        widgets = {
            'email': forms.EmailInput(attrs={
                'class': 'form-control',
                'placeholder': 'Email',
            }),
            'username': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Username',
            }),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # Set all fields as required by default
        for field in self.fields:
            self.fields[field].required = True
        self.fields['email_consent'].required = False

    def clean_email(self):
        email = self.cleaned_data.get('email')
        if not re.match(r'^[a-zA-Z0-9.+_-]+@[a-zA-Z0-9._-]+\.[a-zA-Z]+$', email):
            raise forms.ValidationError("Please enter a valid email address")
        if User.objects.filter(email=email).exists():
            raise forms.ValidationError("This email is already registered")
        return email

    def clean_username(self):
        username = self.cleaned_data.get('username')
        if User.objects.filter(username=username).exists():
            raise forms.ValidationError("This username is already taken.")
        return username

    def save(self, commit=True):
        try:
            user = super().save(commit=False)
            user_type = self.cleaned_data.get('utype', 'student')

            if commit:
                user.save()
                UserProfile.objects.create(
                    user=user,
                    terms_agreed=self.cleaned_data['terms_agreed'],
                    email_consent=self.cleaned_data['email_consent'],
                    user_type=user_type
                )
            return user
        except Exception as e:
            logger.error(f"Error saving user: {str(e)}")
            raise  # Re-raise to be caught in form_valid


class UserEducationForm(forms.ModelForm):
    class Meta:
        model = UserEducation
        fields = ['degree', 'field_of_study', 'institution', 'end_year', 'document']
        widgets = {
            'degree': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'e.g. B.Sc, M.Sc., Ph.D., ... ',
            }),
            'field_of_study': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Field of study',
            }),
            'institution': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Institution',
            }),
            'end_year': forms.NumberInput(attrs={
                'class': 'form-control',
                'placeholder': 'Graduation year',
                'min': 1900,
                'max': 2100,
            }),
            'document': forms.FileInput(attrs={
                'class': 'form-control',
                'accept': '.pdf,.doc,.docx,.png,.jpg,.jpeg',
            }),
        }

    def __init__(self, *args, user=None, **kwargs):
        self.user = user
        super().__init__(*args, **kwargs)

    def save(self, commit=True):
        instance = super().save(commit=False)
        if self.user:
            instance.user = self.user
        if commit:
            instance.save()
        return instance


class AgreementForm(forms.ModelForm):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['terms_agreed'].required = True  # Explicitly mark as required

    class Meta:
        model = UserProfile
        fields = ['terms_agreed', 'email_consent']
        widgets = {
            'terms_agreed': forms.CheckboxInput(attrs={
                'class': 'form-check-input',
                'required': 'required',
                'id': 'terms_agreed1'  # Match the template's label
            }),
            'email_consent': forms.CheckboxInput(attrs={
                'class': 'form-check-input',
                'id': 'email_consent1'  # Match the template's label
            }),
        }

    def save(self, commit=True):
        instance = super().save(commit=False)
        if self.cleaned_data.get('terms_agreed'):
            instance.terms_agreed_date = timezone.now()  # Auto-set agreement timestamp
        if self.cleaned_data.get('email_consent'):
            instance.email_consent_date = timezone.now()  # Auto-set consent timestamp
        if commit:
            instance.save()
        return instance


class LocationForm_MAIN(forms.Form):
    country = forms.ChoiceField(choices=COUNTRY_CHOICES, required=True, initial='', widget=forms.Select(attrs={
        'class': 'form-select js-choice border-1 z-index-9 bg-transparent',
        'aria-label': '.form-select-sm',
        'data-search-enabled': 'true',
        'data-remove-item-button': 'true',
        'placeholder': 'Location',
        'required': 'required',
    }))
    # ===== IN-PERSON MEETING FIELDS  =====
    meeting_method = forms.ChoiceField(choices=MEETING_METHOD_CHOICES, widget=forms.RadioSelect(attrs={
        'class': 'btn-check meeting-method-radio', }),
                                       initial='online'
                                       )
    city = forms.CharField(max_length=100, required=False, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'e.g. Berlin, Toronto Downtown',
        'data-city-autocomplete': 'true'
    }),
                           help_text="Primary location where you'll teach")
    meeting_radius = forms.IntegerField(required=False, min_value=0, max_value=100, widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'placeholder': 'Maximum distance you\'ll travel',
        'step': '1'
    }),
                                        help_text="In kilometers (0 = only at specified location)"
                                        )
    latitude = forms.DecimalField(required=False, max_digits=9, decimal_places=6, widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'placeholder': 'latitude',
        'step': '0.1'
    }), )
    longitude = forms.DecimalField(required=False, max_digits=9, decimal_places=6, widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'placeholder': 'longitude',
        'step': '0.1'
    }), )
    meeting_location = forms.ChoiceField(choices=MEETING_LOCATION_CHOICES, required=False, initial='any',
                                         widget=forms.Select(attrs={
                                             'class': 'form-select js-choice z-index-9 border-0 bg-light',
                                             'aria-label': ".form-select-sm",
                                             'data-search-enabled': 'false',
                                             'placeholder': 'Meeting location',
                                         }))
    inp_aim = forms.ChoiceField(choices=IN_PERSON_AIM_CHOICES, required=False,
                                widget=forms.Select(attrs={
                                    'class': 'form-select js-choice z-index-9 border-0 bg-light',
                                    'aria-label': ".form-select-sm",
                                    'data-search-enabled': 'false',
                                    'placeholder': 'Your aim of meeting',
                                }))
    inp_start = forms.DateField(required=False, )

    def __init__(self, *args, **kwargs):
        # Extract instance data for User, UserProfile, and Tutor
        self.user_instance = kwargs.pop('user_instance', None)
        self.profile_instance = kwargs.pop('profile_instance', None)

        # Call super().__init__() first to initialize self.fields
        super().__init__(*args, **kwargs)

        if self.profile_instance:
            # Populate UserProfile fields
            profile_fields = ['meeting_method', 'country', 'city', 'meeting_radius', 'latitude', 'longitude',
                              'meeting_location', 'inp_aim', 'inp_start']
            for field in profile_fields:
                self.fields[field].initial = getattr(self.profile_instance, field)

    def clean(self):
        cleaned_data = super().clean()

        meeting_method = cleaned_data.get('meeting_method')

        # Validate in-person fields based on meeting method
        if meeting_method in ['hybrid', 'in_person']:
            required_fields = {
                'country': 'Country is required for in-person meeting',
                'city': 'City is required for in-person meeting',
                'meeting_radius': 'Please specify maximum travel distance',
                'latitude': 'Please set your location on the map',
                'longitude': 'Please set your location on the map',
                'inp_aim': 'Please set your aim of meeting',
                'inp_start': 'Please set your desired start time',
            }
            for field, error_msg in required_fields.items():
                if not cleaned_data.get(field):
                    self.add_error(field, error_msg)

            if (cleaned_data.get('meeting_radius') is not None and
                    (cleaned_data['meeting_radius'] < 0 or cleaned_data['meeting_radius'] > 100)):
                self.add_error('meeting_radius', 'Please enter a value between 0-100 km')

            if (self.profile_instance.user_type == 'student'):
                self.profile_instance.inp_aim = cleaned_data.get('inp_aim')
                self.profile_instance.inp_start = cleaned_data.get('inp_start')
            else:
                self.profile_instance.inp_aim = None
                self.profile_instance.inp_start = None

        return cleaned_data

    def save(self, user):
        # user_instance, created = User.objects.update_or_create(id=user.id, defaults=user_data)
        user_instance, created = User.objects.update_or_create(id=user.id)

        # Update or create UserProfile
        profile_data = {
            'user': user_instance,
            'meeting_method': self.cleaned_data['meeting_method'],
        }
        # Handle location fields conditionally
        if self.cleaned_data['meeting_method'] in ['hybrid', 'in_person']:
            profile_data.update({
                'country': self.cleaned_data['country'],
                'city': self.cleaned_data['city'],
                'latitude': self.cleaned_data['latitude'],
                'longitude': self.cleaned_data['longitude'],
                'meeting_radius': self.cleaned_data['meeting_radius'],
                'meeting_location': self.cleaned_data.get('meeting_location', 'any'),
                'inp_aim': self.cleaned_data.get('inp_aim', ''),
                'inp_start': self.cleaned_data.get('inp_start', ''),

            })
        else:  # online only
            profile_data.update({
                'country': self.cleaned_data['country'],
                'city': '',
                'latitude': None,
                'longitude': None,
                'meeting_radius': None,
                'meeting_location': None,
                'inp_aim': None,
                'inp_start': None,
            })

        profile, created = UserProfile.objects.update_or_create(user=user_instance, defaults=profile_data)

        # return user_instance, profile, tutor
        return user_instance, profile


class LocationForm(forms.Form):
    country = forms.ChoiceField(choices=COUNTRY_CHOICES, required=True, initial='', widget=forms.Select(attrs={
        'class': 'form-select js-choice border-1 z-index-9 bg-transparent',
        'aria-label': '.form-select-sm',
        'data-search-enabled': 'true',
        'data-remove-item-button': 'true',
        'placeholder': 'Location',
        'required': 'required',
    }))

    meeting_method = forms.ChoiceField(choices=MEETING_METHOD_CHOICES, widget=forms.RadioSelect(attrs={
        'class': 'btn-check meeting-method-radio', }),
                                       initial='online'
                                       )
    city = forms.CharField(max_length=100, required=False, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'e.g. Berlin, Toronto Downtown',
        'data-city-autocomplete': 'true'
    }),
                           help_text="Primary location where you'll teach")
    meeting_radius = forms.IntegerField(required=False, min_value=0, max_value=100, widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'placeholder': 'Maximum distance you\'ll travel',
        'step': '1'
    }),
                                        help_text="In kilometers (0 = only at specified location)"
                                        )
    latitude = forms.DecimalField(required=False, max_digits=9, decimal_places=6, widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'placeholder': 'latitude',
        'step': '0.1'
    }), )
    longitude = forms.DecimalField(required=False, max_digits=9, decimal_places=6, widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'placeholder': 'longitude',
        'step': '0.1'
    }), )
    meeting_location = forms.ChoiceField(choices=MEETING_LOCATION_CHOICES, required=False, initial='any',
                                         widget=forms.Select(attrs={
                                             'class': 'form-select js-choice z-index-9 border-0 bg-light',
                                             'aria-label': ".form-select-sm",
                                             'data-search-enabled': 'false',
                                             'placeholder': 'Meeting location',
                                         }))
    # Student-specific fields
    inp_aim = forms.ChoiceField(choices=IN_PERSON_AIM_CHOICES, required=False,
                                widget=forms.Select(attrs={
                                    'class': 'form-select js-choice z-index-9 border-0 bg-light',
                                    'aria-label': ".form-select-sm",
                                    'data-search-enabled': 'false',
                                    'placeholder': 'Your aim of meeting',
                                }))
    # inp_start = forms.DateField(
    #     required=False,
    #     widget=forms.DateInput(attrs={
    #         'class': 'form-control datepicker',
    #         'placeholder': 'Select start date',
    #         'type': 'date',  # This enables HTML5 date picker
    #         'data-date-format': 'yyyy-mm-dd',
    #         'data-date-autoclose': 'true',
    #         'data-date-today-highlight': 'true',
    #         'data-date-orientation': 'bottom auto',
    #     })
    # )

    inp_start = forms.DateField(
        required=False,
        widget=forms.DateInput(attrs={
            'class': 'form-control',
            'type': 'date',  # HTML5 date input
            'placeholder': 'yyyy-mm-dd',
        })
    )

    def __init__(self, *args, **kwargs):
        self.user_instance = kwargs.pop('user_instance', None)
        self.profile_instance = kwargs.pop('profile_instance', None)
        super().__init__(*args, **kwargs)

        # Hide student-specific fields if user is a tutor
        if self.profile_instance and self.profile_instance.user_type == 'tutor':
            self.fields.pop('inp_aim', None)
            self.fields.pop('inp_start', None)

        if self.profile_instance:
            profile_fields = ['meeting_method', 'country', 'city', 'meeting_radius',
                              'latitude', 'longitude', 'meeting_location']
            if self.profile_instance.user_type == 'student':  # Only include for students
                profile_fields.extend(['inp_aim', 'inp_start'])

            for field in profile_fields:
                self.fields[field].initial = getattr(self.profile_instance, field)

    def clean(self):
        cleaned_data = super().clean()
        meeting_method = cleaned_data.get('meeting_method')
        user_type = self.profile_instance.user_type if self.profile_instance else None

        # Validate in-person fields based on meeting method
        if meeting_method in ['hybrid', 'in_person']:
            required_fields = {
                'country': 'Country is required for in-person meeting',
                'city': 'City is required for in-person meeting',
                'meeting_radius': 'Please specify maximum travel distance',
                'latitude': 'Please set your location on the map',
                'longitude': 'Please set your location on the map',
            }

            # Only require student-specific fields for students
            if user_type == 'student':
                required_fields.update({
                    'inp_aim': 'Please set your aim of meeting',
                    'inp_start': 'Please set your desired start time',
                })

            for field, error_msg in required_fields.items():
                if field in self.fields and not cleaned_data.get(field):
                    self.add_error(field, error_msg)

            if (cleaned_data.get('meeting_radius') is not None and
                    (cleaned_data['meeting_radius'] < 0 or cleaned_data['meeting_radius'] > 100)):
                self.add_error('meeting_radius', 'Please enter a value between 0-100 km')

        return cleaned_data

    def save(self, user):
        user_instance = User.objects.get(id=user.id)
        user_type = self.profile_instance.user_type if self.profile_instance else None

        profile_data = {
            'user': user_instance,
            'meeting_method': self.cleaned_data['meeting_method'],
            'country': self.cleaned_data['country'],
        }

        # Handle location fields conditionally
        if self.cleaned_data['meeting_method'] in ['hybrid', 'in_person']:
            profile_data.update({
                'city': self.cleaned_data['city'],
                'latitude': self.cleaned_data['latitude'],
                'longitude': self.cleaned_data['longitude'],
                'meeting_radius': self.cleaned_data['meeting_radius'],
                'meeting_location': self.cleaned_data.get('meeting_location', 'any'),
            })

            # Only include student-specific fields if they exist in the form
            if user_type == 'student':
                if 'inp_aim' in self.cleaned_data:
                    profile_data['inp_aim'] = self.cleaned_data.get('inp_aim')
                if 'inp_start' in self.cleaned_data:
                    profile_data['inp_start'] = self.cleaned_data.get('inp_start')
            else:
                profile_data['inp_aim'] = None
                profile_data['inp_start'] = None

        else:  # online only
            profile_data.update({
                'city': '',
                'latitude': None,
                'longitude': None,
                'meeting_radius': None,
                'meeting_location': None,
                'inp_aim': None,
                'inp_start': None,
            })

        profile, created = UserProfile.objects.update_or_create(
            user=user_instance,
            defaults=profile_data
        )

        return user_instance, profile
