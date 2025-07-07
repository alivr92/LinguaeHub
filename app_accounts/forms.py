from django import forms
from django.contrib.auth.models import User
from django.utils import timezone
from django_recaptcha.fields import ReCaptchaField
from django_recaptcha.widgets import ReCaptchaV2Checkbox
from app_accounts.models import UserEducation, UserProfile

from django.contrib.auth import get_user_model
from django.contrib.auth.forms import UserCreationForm
from django.db import transaction

User = get_user_model()


class RegistrationForm(UserCreationForm):
    first_name = forms.CharField(
        widget=forms.TextInput(attrs={
            'class': 'form-control form-control-lg border-1',
            'placeholder': 'First name',
            'required': 'required',
        })
    )
    last_name = forms.CharField(
        widget=forms.TextInput(attrs={
            'class': 'form-control form-control-lg border-1',
            'placeholder': 'Last name',
            'required': 'required',
        })
    )
    terms_agreed = forms.BooleanField(
        required=True,
        widget=forms.CheckboxInput(attrs={
            'class': 'form-check-input',
            'required': 'required',
        })
    )
    email_consent = forms.BooleanField(
        required=False,
        widget=forms.CheckboxInput(attrs={
            'class': 'form-check-input',
        })
    )
    captcha = ReCaptchaField(widget=ReCaptchaV2Checkbox)

    class Meta:
        model = User
        fields = ['username', 'email', 'password1', 'password2', 'first_name', 'last_name']
        widgets = {
            'username': forms.TextInput(attrs={
                'class': 'form-control form-control-lg border-1',
                'placeholder': 'Username',
            }),
            'email': forms.EmailInput(attrs={
                'class': 'form-control form-control-lg border-1',
                'placeholder': 'Email',
            }),
            'password1': forms.PasswordInput(attrs={
                'class': 'form-control border-1',
                'placeholder': 'Password',
            }),
            'password2': forms.PasswordInput(attrs={
                'class': 'form-control border-1 rounded ps-1',
                'placeholder': 'Confirm Password',
            }),
        }

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        # Add Bootstrap classes to password fields
        self.fields['password1'].widget.attrs.update({
            'class': 'form-control form-control-lg border-1',
            'placeholder': 'Password'
        })
        self.fields['password2'].widget.attrs.update({
            'class': 'form-control border-1',
            'placeholder': 'Confirm Password'
        })
        # Add real-time validation classes
        for field in self.fields:
            if field not in ['terms_agreed', 'email_consent', 'captcha']:
                self.fields[field].widget.attrs.update({
                    'oninput': "this.classList.remove('is-invalid'); this.classList.add('is-valid')"
                })

    def clean_email(self):
        email = self.cleaned_data.get('email')
        if User.objects.filter(email=email).exists():
            self.add_error('email', 'This email is already registered')
            self.fields['email'].widget.attrs.update({'class': 'form-control form-control-lg border-1 is-invalid'})
        return email

    def clean_username(self):
        username = self.cleaned_data.get('username')
        if User.objects.filter(username=username).exists():
            self.add_error('username', 'This username is already taken')
            self.fields['username'].widget.attrs.update({'class': 'form-control form-control-lg border-1 is-invalid'})
        return username

    def save_main(self, commit=True):
        user = super().save(commit=False)
        user.first_name = self.cleaned_data['first_name']
        user.last_name = self.cleaned_data['last_name']

        if commit:
            user.save()
            UserProfile.objects.create(
                user=user,
                terms_agreed=self.cleaned_data['terms_agreed'],
                terms_agreed_date=timezone.now(),
                email_consent=self.cleaned_data['email_consent'],
                email_consent_date=timezone.now() if self.cleaned_data['email_consent'] else None
            )
        return user

    def save(self, commit=True):
        user = super().save(commit=False)
        user.first_name = self.cleaned_data['first_name']
        user.last_name = self.cleaned_data['last_name']

        if commit:
            with transaction.atomic():
                user.save()
                # Use get_or_create to prevent duplicates
                UserProfile.objects.get_or_create(
                    user=user,
                    defaults={
                        'terms_agreed': self.cleaned_data['terms_agreed'],
                        'terms_agreed_date': timezone.now(),
                        'email_consent': self.cleaned_data['email_consent'],
                        'email_consent_date': timezone.now() if self.cleaned_data['email_consent'] else None
                    }
                )
        return user


class RegistrationForm_MAIN(forms.ModelForm):
    captcha = ReCaptchaField(widget=ReCaptchaV2Checkbox)
    first_name = forms.CharField(max_length=50, required=True, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'First name',
        'required': 'required',
    }))
    last_name = forms.CharField(max_length=50, required=True, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Last name',
        'required': 'required',
    }))
    username = forms.CharField(widget=forms.TextInput(attrs={
        'class': 'form-control border-1 rounded ps-1',
        'placeholder': 'Username',
        'id': 'exampleUserName',
    }))
    # user_type = forms.CharField(widget=forms.TextInput(attrs={
    #     'class': 'form-control border-1 bg-light rounded ps-1',
    #     'id': 'user_type',
    #     'user_type': 'student',
    # }))
    email = forms.EmailField(widget=forms.EmailInput(attrs={
        'class': 'form-control border-1 rounded ps-1',
        'placeholder': 'Email'
    }))
    password = forms.CharField(widget=forms.PasswordInput(attrs={
        'class': 'form-control border-1 bg-light rounded ps-1',
        'placeholder': '*********'
    }))
    password_confirm = forms.CharField(widget=forms.PasswordInput(attrs={
        'class': 'form-control border-1 bg-light rounded ps-1',
        'placeholder': '*********',
    }), label="Confirm Password")
    terms_agreed = forms.BooleanField(widget=forms.CheckboxInput(attrs={
        'class': 'form-check-input',
        'required': 'required',
        'id': 'terms_agreed1'  # Match the template's label
    }), )
    email_consent = forms.BooleanField(widget=forms.CheckboxInput(attrs={
        'class': 'form-check-input',
        'id': 'email_consent1'  # Match the template's label
    }), )

    class Meta:
        model = User
        fields = ['username', 'email', 'password']

    def clean(self):
        cleaned_data = super().clean()
        username = cleaned_data.get('username')
        email = cleaned_data.get('email')
        password = cleaned_data.get('password')
        password_confirm = cleaned_data.get('password_confirm')
        first_name = cleaned_data.get('first_name')
        last_name = cleaned_data.get('last_name')
        terms_agreed = cleaned_data.get('terms_agreed')
        email_consent = cleaned_data.get('email_consent')

        # if User.objects.filter(username=username).exists():
        #     raise forms.ValidationError("Sorry, this username has been registered before! Try another one.")
        #
        # if User.objects.filter(email=email).exists():
        #     raise forms.ValidationError("Sorry, this email address has been registered before! Try another one.")
        #
        # if password != password_confirm:
        #     raise forms.ValidationError("Check your passwords! They must be the same.")

        if User.objects.filter(username=username).exists():
            self.add_error('username', 'Sorry, this username has been registered before! Try another one.')

        elif User.objects.filter(email=email).exists():
            self.add_error('email', 'Sorry, this email address has been registered before! Try another one.')

        elif password != password_confirm:
            self.add_error('__all__', 'Check your passwords! They must be the same.')

        return cleaned_data

    def __init__(self, *args, **kwargs):
        self.applicant = kwargs.pop('applicant', None)
        super().__init__(*args, **kwargs)

        # Add form-control-lg consistently
        # for field in self.fields:
        #     self.fields[field].widget.attrs.update({
        #         'class': 'form-control form-control-lg border-1'
        #     })
        #
        #     if self.errors.get(field):
        #         self.fields[field].widget.attrs.update({
        #             'class': 'form-control border-1 is-invalid'
        #         })

        if self.applicant:  # If coming from invitation
            self.fields['email'].initial = self.applicant.email
            self.fields['email'].widget.attrs['readonly'] = True
            self.fields['email'].help_text = "Cannot be changed (set by your invitation)"


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
