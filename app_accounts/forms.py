from django import forms
from django.contrib.auth.models import User
from app_accounts.models import UserProfile, Language, LANGUAGE_CHOICES
from ap2_tutor.models import Tutor, Skill, SkillLevel


class UserRegistrationForm(forms.ModelForm):
    username = forms.CharField(
        widget=forms.TextInput(attrs={
            'class': 'form-control border-1 bg-light rounded ps-1',
            'placeholder': 'Username',
            'id': 'exampleUserName',
        })
    )
    email = forms.EmailField(
        widget=forms.EmailInput(attrs={
            'class': 'form-control border-1 bg-light rounded ps-1',
            'placeholder': 'Email'
        })
    )
    password = forms.CharField(
        widget=forms.PasswordInput(attrs={
            'class': 'form-control border-1 bg-light rounded ps-1',
            'placeholder': '*********'
        })
    )
    password_confirm = forms.CharField(
        widget=forms.PasswordInput(attrs={
            'class': 'form-control border-1 bg-light rounded ps-1',
            'placeholder': '*********',
        }), label="Confirm Password"
    )

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


# class DTEditProfileForm(forms.ModelForm):
#     first_name = forms.CharField(
#         max_length=30,
#         widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'First name'})
#     )
#     last_name = forms.CharField(
#         max_length=30,
#         widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Last name'})
#     )
#     username = forms.CharField(
#         max_length=30,
#         widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Username'})
#     )
#     email = forms.EmailField(
#         max_length=30,
#         widget=forms.EmailInput(attrs={'class': 'form-control', 'placeholder': 'Email'})
#     )
#
#     class Meta:
#         model = Tutor
#         fields = ['title', 'photo', 'phone', 'video_url', 'country', 'video_intro',
#                   'lang_native', 'lang_speak', 'skills', 'language_levels',
#                   'cost_trial', 'cost_hourly', 'bio', 'url_facebook',
#                   'url_insta', 'url_twitter', 'url_linkedin']
#         widgets = {
#             'title': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Title'}),
#             'phone': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Phone number'}),
#             'photo': forms.FileInput(attrs={'class': 'form-control d-none', 'id': 'uploadfile-1'}),
#             'video_intro': forms.FileInput(attrs={'class': 'form-control', 'placeholder': 'Video Introduction',
#                                                   'id': 'inputGroupFile01'}),
#             # 'video_url': forms.URLInput(attrs={'class': 'form-control', 'placeholder': 'Video URL'}),
#             'country': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Location (Country)'}),
#             # 'lang_native': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Native Language'}),
#             # 'lang_speak': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Speaking Languages'}),
#             # 'skills': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Skills'}),
#             # 'language_levels': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Language Levels'}),
#             'cost_trial': forms.NumberInput(attrs={'class': 'form-control', 'placeholder': 'Trial Cost'}),
#             'cost_hourly': forms.NumberInput(attrs={'class': 'form-control', 'placeholder': 'Hourly Cost'}),
#             'bio': forms.Textarea(
#                 attrs={'class': 'form-control', 'rows': 3, 'placeholder': 'Brief description for your profile'}),
#             'url_facebook': forms.URLInput(attrs={'class': 'form-control', 'placeholder': 'Facebook URL'}),
#             'url_insta': forms.URLInput(attrs={'class': 'form-control', 'placeholder': 'Instagram URL'}),
#             'url_twitter': forms.URLInput(attrs={'class': 'form-control', 'placeholder': 'Twitter URL'}),
#             'url_linkedin': forms.URLInput(attrs={'class': 'form-control', 'placeholder': 'LinkedIn URL'}),
#         }
#
#         lang_native = forms.ChoiceField(
#             choices=LANGUAGE_CHOICES,
#             # widget=forms.Select(attrs={})
#         )
#
#         lang_speak = forms.ModelMultipleChoiceField(
#             queryset=Language.objects.all(),
#             widget=forms.SelectMultiple(attrs={
#                 'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
#                 'multiple': 'multiple',
#                 'aria-label': '.form-select-sm',
#                 'data-max-item-count': '4',
#                 'data-remove-item-button': 'true'
#             })
#         )
#
#         skills = forms.ModelMultipleChoiceField(
#             queryset=Skill.objects.all(),
#             widget=forms.SelectMultiple(attrs={
#                 'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
#                 'multiple': 'multiple',
#                 'aria-label': '.form-select-sm',
#                 'data-max-item-count': '4',
#                 'data-remove-item-button': 'true'
#             })
#         )
#         language_levels = forms.ModelMultipleChoiceField(
#             queryset=LanguageLevel.objects.all(),
#             widget=forms.SelectMultiple(attrs={
#                 'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
#                 'multiple': 'multiple',
#                 'aria-label': '.form-select-sm',
#                 'data-max-item-count': '6',
#                 'data-remove-item-button': 'true'
#             })
#         )
#
#     def __init__(self, *args, **kwargs):
#         super().__init__(*args, **kwargs)
#         self.fields['first_name'].initial = self.instance.user.first_name
#         self.fields['last_name'].initial = self.instance.user.last_name
#         self.fields['username'].initial = self.instance.user.username
#         self.fields['email'].initial = self.instance.user.email
#
#     def save(self, commit=True):
#         instance = super().save(commit=False)
#         instance.user.first_name = self.cleaned_data['first_name']
#         instance.user.last_name = self.cleaned_data['last_name']
#         instance.user.username = self.cleaned_data['username']
#         instance.user.email = self.cleaned_data['email']
#         if commit:
#             instance.user.save()
#             instance.save()
#         return instance


class DTEditProfileForm2(forms.ModelForm):
    first_name = forms.CharField(
        max_length=30,
        widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'First name'})
    )
    last_name = forms.CharField(
        max_length=30,
        widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Last name'})
    )
    username = forms.CharField(
        max_length=30,
        widget=forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Username'})
    )
    email = forms.EmailField(
        max_length=30,
        widget=forms.EmailInput(attrs={'class': 'form-control', 'placeholder': 'Email'})
    )

    class Meta:
        model = Tutor
        fields = ['video_url', 'video_intro','cost_trial', 'cost_hourly',
                    # 'skills', 'language_levels',
                  ]
        # fields = ['title', 'photo', 'phone', 'video_url', 'video_intro',
        #           # 'lang_native',  'skills', 'language_levels','country',
        #           'lang_native', 'lang_speak',
        #           'cost_trial', 'cost_hourly', 'bio', 'url_facebook',
        #           'url_insta', 'url_twitter', 'url_linkedin']
        widgets = {
            'video_intro': forms.FileInput(attrs={'class': 'form-control', 'placeholder': 'Video Introduction',
                                                  'id': 'inputGroupFile01'}),
            'cost_trial': forms.NumberInput(attrs={'class': 'form-control', 'placeholder': 'Trial Cost'}),
            'cost_hourly': forms.NumberInput(attrs={'class': 'form-control', 'placeholder': 'Hourly Cost'}),
            # 'title': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Title'}),
            # 'phone': forms.TextInput(attrs={'class': 'form-control', 'placeholder': 'Phone number'}),
            # 'photo': forms.FileInput(attrs={'class': 'form-control d-none', 'id': 'uploadfile-1'}),
            # 'bio': forms.Textarea(attrs={'class': 'form-control', 'rows': 3, 'placeholder': 'Brief description for your profile'}),
            # 'url_facebook': forms.URLInput(attrs={'class': 'form-control', 'placeholder': 'Facebook URL'}),
            # 'url_insta': forms.URLInput(attrs={'class': 'form-control', 'placeholder': 'Instagram URL'}),
            # 'url_twitter': forms.URLInput(attrs={'class': 'form-control', 'placeholder': 'Twitter URL'}),
            # 'url_linkedin': forms.URLInput(attrs={'class': 'form-control', 'placeholder': 'LinkedIn URL'}),
        }

        lang_native = forms.ChoiceField(
            choices=LANGUAGE_CHOICES,
            widget=forms.Select(attrs={
                'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
                'required': 'required',
                'aria-label': '.form-select-sm',
                'data-search-enabled': 'false',
                'data-remove-item-button': 'true',
            })
        )

        # lang_speak = forms.ChoiceField(
        #     choices=LANGUAGE_CHOICES,
        #     # multiple=True,
        #     widget=forms.SelectMultiple(attrs={
        #         'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
        #         'required': 'required',
        #         'multiple': 'multiple',
        #         'aria-label': '.form-select-sm',
        #         'data-max-item-count': '4',
        #         'data-remove-item-button': 'true'
        #     })
        # )

        lang_speak = forms.ModelMultipleChoiceField(
            queryset=Language.objects.all(),
            widget=forms.SelectMultiple(attrs={
                'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
                'required': 'required',
                'multiple': 'multiple',
                'aria-label': '.form-select-sm',
                'data-max-item-count': '4',
                'data-remove-item-button': 'true'
            })
        )
        #
        # skills = forms.ModelMultipleChoiceField(
        #     queryset=Skill.objects.all(),
        #     widget=forms.SelectMultiple(attrs={
        #         'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
        #         'multiple': 'multiple',
        #         'aria-label': '.form-select-sm',
        #         'data-max-item-count': '4',
        #         'data-remove-item-button': 'true'
        #     })
        # )
        # language_levels = forms.ModelMultipleChoiceField(
        #     queryset=LanguageLevel.objects.all(),
        #     widget=forms.SelectMultiple(attrs={
        #         'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
        #         'multiple': 'multiple',
        #         'aria-label': '.form-select-sm',
        #         'data-max-item-count': '6',
        #         'data-remove-item-button': 'true'
        #     })
        # )

    # def clean(self):
    #     cleaned_data = super().clean()
    #     username = cleaned_data.get('username')
    #     if User.objects.filter(username=username).exists():
    #         self.add_error('username', 'Sorry, this username has been registered before! Try another one.')
    #     return cleaned_data

    def clean_lang_native(self):
        lang_native = self.cleaned_data.get('lang_native')
        if not lang_native:
            raise forms.ValidationError("This field is required.")
        return lang_native

    def get_data(self):
        return {field: self.cleaned_data.get(field) for field in self._meta.fields}

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['first_name'].initial = self.instance.user.first_name
        self.fields['last_name'].initial = self.instance.user.last_name
        self.fields['username'].initial = self.instance.user.username
        self.fields['email'].initial = self.instance.user.email

    def save(self, commit=True):
        instance = super().save(commit=False)
        instance.user.first_name = self.cleaned_data['first_name']
        instance.user.last_name = self.cleaned_data['last_name']
        instance.user.username = self.cleaned_data['username']
        instance.user.email = self.cleaned_data['email']
        # if commit:
        #     instance.user.save()
        #     instance.save()
        # return instance
        if commit:
            instance.user.save()
            super().save()  # Save the Tutor instance first
            instance.lang_speak.set(self.cleaned_data['lang_speak']) #now we have access to cleaned_data
        return instance



