from django import forms
from .models import ContactUs


class ContactUsForm(forms.ModelForm):
    class Meta:
        model = ContactUs
        fields = ['name', 'phone', 'email', 'message']
        widgets = {
            'name': forms.TextInput(attrs={'class': 'form-control form-control-lg border-1', 'placeholder': 'Fullname',
                                           'style': 'border: 1px solid #000;',
                                           }),
            'phone': forms.TextInput(
                attrs={'class': 'form-control form-control-lg border-success', 'placeholder': 'Phone'}),
            'email': forms.EmailInput(attrs={'class': 'form-control form-control-lg border-1', 'placeholder': 'Email'}),
            'message': forms.Textarea(attrs={'class': 'form-control border-1', 'placeholder': 'Type your message here', 'rows': 4}),
        }
