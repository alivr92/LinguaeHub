from django import forms
from django.contrib.auth.models import User
from app_accounts.models import UserProfile, Language, LANGUAGE_CHOICES, GENDER_CHOICES, COUNTRY_CHOICES
from ap2_tutor.models import Tutor, Skill, SkillLevel


class CombinedProfileForm(forms.Form):
    # User fields
    first_name = forms.CharField(max_length=50, required=False, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'First name',
    }))
    last_name = forms.CharField(max_length=50, required=False, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Last name',
    }))
    username = forms.CharField(max_length=50, required=True, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'User name',
    }))
    email = forms.CharField(max_length=50, required=True, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Email',
    }))

    # UserProfile fields
    title = forms.CharField(max_length=100, required=False, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Title',
    }))
    phone = forms.CharField(max_length=20, required=False, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Phone',
    }))
    gender = forms.ChoiceField(choices=GENDER_CHOICES, required=True, initial='male', widget=forms.Select(attrs={
        'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
        'data-search-enabled': 'false',
        'placeholder': 'Gender',
    }))
    photo = forms.ImageField(required=False)
    delete_photo = forms.BooleanField(required=False, initial=False)
    bio = forms.CharField(max_length=350, required=False, widget=forms.Textarea(attrs={
        'class': 'form-control',
        'rows': 3,
    }))
    availability = forms.BooleanField(required=False, initial=True)
    country = forms.ChoiceField(choices=COUNTRY_CHOICES, required=True, initial='', widget=forms.Select(attrs={
        'class': 'form-select js-choice border-1 z-index-9 bg-transparent',
        'aria-label': '.form-select-sm',
        'data-search-enabled': 'true',
        'data-remove-item-button': 'true',
        'placeholder': 'Location',
        'required': 'required',  # Add the required attribute
    }))
    lang_native = forms.ChoiceField(choices=LANGUAGE_CHOICES, required=True, initial='', widget=forms.Select(attrs={
        'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
        'aria-label': '.form-select-sm',
        'data-search-enabled': 'true',
        'data-remove-item-button': 'true',
    }))

    # Language fields
    lang_speak = forms.ModelMultipleChoiceField(
        queryset=Language.objects.all(),
        required=True,
        widget=forms.SelectMultiple(attrs={
            'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
            'multiple': 'multiple',
            'aria-label': '.form-select-sm',
            'data-max-item-count': 4,
            'data-remove-item-button': 'true',
            'placeholder': 'Select language',
        })
    )

    # Tutor fields
    video_url = forms.URLField(required=False, widget=forms.TextInput(attrs={
        'type': 'text',
        'class': 'form-control',
        'placeholder': 'Introduction Video URL',
    }))
    cost_trial = forms.DecimalField(max_digits=10, decimal_places=2, initial=0.00, widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'placeholder': 'Trial Cost',
        'step': '0.10',
        'min': '0',
    }))
    cost_hourly = forms.DecimalField(max_digits=10, decimal_places=2, initial=0.00, widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'placeholder': 'Hourly Cost',
        'step': '0.10',
        'min': '0',
    }))

    discount = forms.DecimalField(max_digits=4, decimal_places=0, initial=0.00, widget=forms.NumberInput(attrs={
        'class': 'form-control',
        'placeholder': 'Discount',
        'step': '1',
        'min': '0',
        'max': '100',
    }))

    discount_deadline = forms.DateTimeField(widget=forms.DateTimeInput(attrs={
        'class': 'form-control',
        'type': 'datetime-local',
    }))

    skills = forms.ModelMultipleChoiceField(
        queryset=Skill.objects.all(),
        required=False,
        widget=forms.SelectMultiple(attrs={
            'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
            'multiple': 'multiple',
            'aria-label': '.form-select-sm',
            'data-max-item-count': 5,
            'data-remove-item-button': 'true',
        }))
    skill_level = forms.ModelMultipleChoiceField(
        queryset=SkillLevel.objects.all(),
        required=False,
        widget=forms.SelectMultiple(attrs={
            'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
            'multiple': 'multiple',
            'aria-label': '.form-select-sm',
            'data-max-item-count': 6,
            'data-remove-item-button': 'true',

        })
    )

    def __init__(self, *args, **kwargs):
        # Extract instance data for User, UserProfile, and Tutor
        self.user_instance = kwargs.pop('user_instance', None)
        self.user_profile_instance = kwargs.pop('user_profile_instance', None)
        self.tutor_instance = kwargs.pop('tutor_instance', None)

        # Call super().__init__() first to initialize self.fields
        super().__init__(*args, **kwargs)

        if self.user_instance:
            # Populate User fields
            user_fields = ['first_name', 'last_name', 'username', 'email']
            for field in user_fields:
                self.fields[field].initial = getattr(self.user_instance, field)

        if self.user_profile_instance:
            # Populate UserProfile fields
            profile_fields = ['gender', 'phone', 'country', 'photo', 'title', 'bio', 'availability', 'lang_native']
            for field in profile_fields:
                self.fields[field].initial = getattr(self.user_profile_instance, field)
            self.fields['lang_speak'].initial = self.user_profile_instance.lang_speak.all()

        if self.tutor_instance:
            # Populate Tutor fields
            tutor_fields = ['video_url', 'cost_trial', 'cost_hourly', 'discount', 'discount_deadline']
            for field in tutor_fields:
                self.fields[field].initial = getattr(self.tutor_instance, field)
            self.fields['skills'].initial = self.tutor_instance.skills.all()
            self.fields['skill_level'].initial = self.tutor_instance.skill_level.all()

    def save(self, user):
        # Update or create User
        user_data = {
            'first_name': self.cleaned_data['first_name'],
            'last_name': self.cleaned_data['last_name'],
            'username': self.cleaned_data['username'],
            'email': self.cleaned_data['email'],
        }
        user_instance, created = User.objects.update_or_create(id=user.id, defaults=user_data)

        # Update or create UserProfile
        profile_data = {
            'user': user_instance,
            'gender': self.cleaned_data['gender'],
            'phone': self.cleaned_data['phone'],
            'country': self.cleaned_data['country'],
            'title': self.cleaned_data['title'],
            'bio': self.cleaned_data['bio'],
            'availability': self.cleaned_data['availability'],
            'lang_native': self.cleaned_data['lang_native'],
        }
        # Handle photo separately to avoid overwriting if no new photo is provided
        print("Cleaned Data:", self.cleaned_data)  # Debugging
        if self.cleaned_data.get('delete_photo'):  # User deleted the photo
            print("Deleting photo and setting default...")  # Debugging
            profile_data['photo'] = 'photos/default.png'  # Set default photo
        elif self.cleaned_data.get('photo'):  # New photo uploaded
            print("New photo uploaded:", self.cleaned_data['photo'])  # Debugging
            profile_data['photo'] = self.cleaned_data['photo']

        profile, created = UserProfile.objects.update_or_create(user=user_instance, defaults=profile_data)

        # Update or create Tutor
        tutor_data = {
            'profile': profile,
            'video_url': self.cleaned_data['video_url'],
            'cost_trial': self.cleaned_data['cost_trial'],
            'cost_hourly': self.cleaned_data['cost_hourly'],
            'discount': self.cleaned_data['discount'],
            'discount_deadline': self.cleaned_data['discount_deadline'],
        }
        tutor, created = Tutor.objects.update_or_create(profile=profile, defaults=tutor_data)

        # Handle many-to-many fields
        tutor.skills.set(self.cleaned_data['skills'])
        tutor.skill_level.set(self.cleaned_data['skill_level'])
        profile.lang_speak.set(self.cleaned_data['lang_speak'])

        return user_instance, profile, tutor


class SocialURLForm_GOOD(forms.Form):
    # User fields
    url_facebook = forms.URLField(max_length=150, required=False, widget=forms.TextInput(attrs={
        'type': 'text',
        'class': 'form-control',
        'placeholder': 'Enter username',
    }))
    url_insta = forms.URLField(max_length=150, required=False, widget=forms.TextInput(attrs={
        'type': 'text',
        'class': 'form-control',
        'placeholder': 'Enter username',
    }))
    url_twitter = forms.URLField(max_length=150, required=False, widget=forms.TextInput(attrs={
        'type': 'text',
        'class': 'form-control',
        'placeholder': 'Enter username',
    }))
    url_linkedin = forms.URLField(max_length=150, required=False, widget=forms.TextInput(attrs={
        'type': 'text',
        'class': 'form-control',
        'placeholder': 'Enter username',
    }))
    url_youtube = forms.URLField(max_length=150, required=False, widget=forms.TextInput(attrs={
        'type': 'text',
        'class': 'form-control',
        'placeholder': 'Enter username',
    }))

    def __init__(self, *args, **kwargs):
        # Extract instance data for User, UserProfile, and Tutor
        self.user_profile_instance = kwargs.pop('user_profile_instance', None)

        # Call super().__init__() first to initialize self.fields
        super().__init__(*args, **kwargs)

        if self.user_profile_instance:
            # Populate UserProfile fields
            profile_fields = ['url_facebook', 'url_insta', 'url_twitter', 'url_linkedin', 'url_youtube']
            for field in profile_fields:
                self.fields[field].initial = getattr(self.user_profile_instance, field)

    def save(self, user):
        # Update or create UserProfile
        profile_data = {
            'user': user,
            'url_facebook': self.cleaned_data['url_facebook'],
            'url_insta': self.cleaned_data['url_insta'],
            'url_twitter': self.cleaned_data['url_twitter'],
            'url_linkedin': self.cleaned_data['url_linkedin'],
            'url_youtube': self.cleaned_data['url_youtube'],
        }
        profile, created = UserProfile.objects.update_or_create(user=user, defaults=profile_data)

        return profile


class SocialURLForm(forms.Form):
    # User fields
    url_facebook = forms.URLField(max_length=150, required=False, widget=forms.TextInput(attrs={
        'type': 'text',
        'class': 'form-control',
        'placeholder': 'Enter username',
    }))
    url_insta = forms.URLField(max_length=150, required=False, widget=forms.TextInput(attrs={
        'type': 'text',
        'class': 'form-control',
        'placeholder': 'Enter username',
    }))
    url_twitter = forms.URLField(max_length=150, required=False, widget=forms.TextInput(attrs={
        'type': 'text',
        'class': 'form-control',
        'placeholder': 'Enter username',
    }))
    url_linkedin = forms.URLField(max_length=150, required=False, widget=forms.TextInput(attrs={
        'type': 'text',
        'class': 'form-control',
        'placeholder': 'Enter username',
    }))
    url_youtube = forms.URLField(max_length=150, required=False, widget=forms.TextInput(attrs={
        'type': 'text',
        'class': 'form-control',
        'placeholder': 'Enter username',
    }))

    def __init__(self, *args, **kwargs):
        # Extract instance data for User, UserProfile, and Tutor
        self.user_profile_instance = kwargs.pop('user_profile_instance', None)

        # Call super().__init__() first to initialize self.fields
        super().__init__(*args, **kwargs)

        if self.user_profile_instance:
            # Populate UserProfile fields
            profile_fields = ['url_facebook', 'url_insta', 'url_twitter', 'url_linkedin', 'url_youtube']
            for field in profile_fields:
                self.fields[field].initial = getattr(self.user_profile_instance, field)

    def save(self, user):
        # Update or create UserProfile
        profile_data = {
            'user': user,
            'url_facebook': self.cleaned_data['url_facebook'],
            'url_insta': self.cleaned_data['url_insta'],
            'url_twitter': self.cleaned_data['url_twitter'],
            'url_linkedin': self.cleaned_data['url_linkedin'],
            'url_youtube': self.cleaned_data['url_youtube'],
        }
        profile, created = UserProfile.objects.update_or_create(user=user, defaults=profile_data)

        return profile
