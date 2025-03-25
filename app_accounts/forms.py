from django import forms
from django.contrib.auth.models import User


class UserRegistrationForm(forms.ModelForm):
    username = forms.CharField(widget=forms.TextInput(attrs={
            'class': 'form-control border-1 bg-light rounded ps-1',
            'placeholder': 'Username',
            'id': 'exampleUserName',
        }))
    email = forms.EmailField(widget=forms.EmailInput(attrs={
            'class': 'form-control border-1 bg-light rounded ps-1',
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

    class Meta:
        model = User
        fields = ['username', 'email', 'password']

    def clean(self):
        cleaned_data = super().clean()
        username = cleaned_data.get('username')
        email = cleaned_data.get('email')
        password = cleaned_data.get('password')
        password_confirm = cleaned_data.get('password_confirm')

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

