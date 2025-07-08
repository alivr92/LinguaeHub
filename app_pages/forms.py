from django import forms
from .models import ContactUs
from django_recaptcha.fields import ReCaptchaField
from django_recaptcha.widgets import ReCaptchaV2Checkbox


class ContactUsForm(forms.ModelForm):
    captcha = ReCaptchaField(widget=ReCaptchaV2Checkbox)

    class Meta:
        model = ContactUs
        fields = ['name', 'phone', 'email', 'message']
        widgets = {
            'name': forms.TextInput(
                attrs={'class': 'form-control form-control-lg border-1', 'placeholder': 'Fullname', }),
            'phone': forms.TextInput(
                attrs={'class': 'form-control form-control-lg border-1', 'placeholder': 'Phone'}),
            'email': forms.EmailInput(attrs={'class': 'form-control form-control-lg border-1', 'placeholder': 'Email'}),
            'message': forms.Textarea(
                attrs={'class': 'form-control border-1', 'placeholder': 'Type your message here', 'rows': 4}),
        }
