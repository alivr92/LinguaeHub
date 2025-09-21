from django import forms
from django.core.exceptions import ValidationError
import os
from django.contrib.auth.models import User
from app_accounts.models import (UserProfile, Language, Skill, Level, UserSkill, UserEducation,
                                 LANGUAGE_CHOICES, GENDER_CHOICES, COUNTRY_CHOICES, MEETING_METHOD_CHOICES,
                                 MEETING_LOCATION_CHOICES)
from ap2_tutor.models import ProviderApplication, Tutor, TeachingCategory, TEACHING_YEARS
from django_recaptcha.fields import ReCaptchaField
from django_recaptcha.widgets import ReCaptchaV2Checkbox
from intl_tel_input.widgets import IntlTelInputWidget

# if user is VIP -> 5 else: 3
MAX_MULTIPLE_ITEMS = 3
# In your forms.py
COUNTRY_CODE_CHOICES1 = [
    ('+1', '🇺🇸 +1'),
    ('+44', '🇬🇧 +44'),
    ('+91', '🇮🇳 +91'),
    ('+86', '🇨🇳 +86'),
    # Add more country codes as needed
]
COUNTRY_CODE_CHOICES = (
    ('+93', 'Afghanistan (AF) +93'),
    ('+355', 'Albania (AL) +355'),
    ('+213', 'Algeria (DZ) +213'),
    ('+1684', 'American Samoa (AS) +1684'),
    ('+376', 'Andorra (AD) +376'),
    ('+244', 'Angola (AO) +244'),
    ('+1264', 'Anguilla (AI) +1264'),
    ('+1268', 'Antigua and Barbuda (AG) +1268'),
    ('+54', 'Argentina (AR) +54'),
    ('+374', 'Armenia (AM) +374'),
    ('+297', 'Aruba (AW) +297'),
    ('+61', 'Australia (AU) +61'),
    ('+43', 'Austria (AT) +43'),
    ('+994', 'Azerbaijan (AZ) +994'),
    ('+1242', 'Bahamas (BS) +1242'),
    ('+973', 'Bahrain (BH) +973'),
    ('+880', 'Bangladesh (BD) +880'),
    ('+1246', 'Barbados (BB) +1246'),
    ('+375', 'Belarus (BY) +375'),
    ('+32', 'Belgium (BE) +32'),
    ('+501', 'Belize (BZ) +501'),
    ('+229', 'Benin (BJ) +229'),
    ('+1441', 'Bermuda (BM) +1441'),
    ('+975', 'Bhutan (BT) +975'),
    ('+591', 'Bolivia (BO) +591'),
    ('+387', 'Bosnia and Herzegovina (BA) +387'),
    ('+267', 'Botswana (BW) +267'),
    ('+55', 'Brazil (BR) +55'),
    ('+246', 'British Indian Ocean Territory (IO) +246'),
    ('+1284', 'British Virgin Islands (VG) +1284'),
    ('+673', 'Brunei (BN) +673'),
    ('+359', 'Bulgaria (BG) +359'),
    ('+226', 'Burkina Faso (BF) +226'),
    ('+257', 'Burundi (BI) +257'),
    ('+855', 'Cambodia (KH) +855'),
    ('+237', 'Cameroon (CM) +237'),
    ('+1', 'Canada (CA) +1'),
    ('+238', 'Cape Verde (CV) +238'),
    ('+1345', 'Cayman Islands (KY) +1345'),
    ('+236', 'Central African Republic (CF) +236'),
    ('+235', 'Chad (TD) +235'),
    ('+56', 'Chile (CL) +56'),
    ('+86', 'China (CN) +86'),
    ('+61', 'Christmas Island (CX) +61'),
    ('+61', 'Cocos Islands (CC) +61'),
    ('+57', 'Colombia (CO) +57'),
    ('+269', 'Comoros (KM) +269'),
    ('+682', 'Cook Islands (CK) +682'),
    ('+506', 'Costa Rica (CR) +506'),
    ('+385', 'Croatia (HR) +385'),
    ('+53', 'Cuba (CU) +53'),
    ('+599', 'Curacao (CW) +599'),
    ('+357', 'Cyprus (CY) +357'),
    ('+420', 'Czech Republic (CZ) +420'),
    ('+243', 'Democratic Republic of the Congo (CD) +243'),
    ('+45', 'Denmark (DK) +45'),
    ('+253', 'Djibouti (DJ) +253'),
    ('+1767', 'Dominica (DM) +1767'),
    ('+1809', 'Dominican Republic (DO) +1809'),
    ('+670', 'East Timor (TL) +670'),
    ('+593', 'Ecuador (EC) +593'),
    ('+20', 'Egypt (EG) +20'),
    ('+503', 'El Salvador (SV) +503'),
    ('+240', 'Equatorial Guinea (GQ) +240'),
    ('+291', 'Eritrea (ER) +291'),
    ('+372', 'Estonia (EE) +372'),
    ('+251', 'Ethiopia (ET) +251'),
    ('+500', 'Falkland Islands (FK) +500'),
    ('+298', 'Faroe Islands (FO) +298'),
    ('+679', 'Fiji (FJ) +679'),
    ('+358', 'Finland (FI) +358'),
    ('+33', 'France (FR) +33'),
    ('+689', 'French Polynesia (PF) +689'),
    ('+241', 'Gabon (GA) +241'),
    ('+220', 'Gambia (GM) +220'),
    ('+995', 'Georgia (GE) +995'),
    ('+49', 'Germany (DE) +49'),
    ('+233', 'Ghana (GH) +233'),
    ('+350', 'Gibraltar (GI) +350'),
    ('+30', 'Greece (GR) +30'),
    ('+299', 'Greenland (GL) +299'),
    ('+1473', 'Grenada (GD) +1473'),
    ('+1671', 'Guam (GU) +1671'),
    ('+502', 'Guatemala (GT) +502'),
    ('+441481', 'Guernsey (GG) +441481'),
    ('+224', 'Guinea (GN) +224'),
    ('+245', 'Guinea-Bissau (GW) +245'),
    ('+592', 'Guyana (GY) +592'),
    ('+509', 'Haiti (HT) +509'),
    ('+504', 'Honduras (HN) +504'),
    ('+852', 'Hong Kong (HK) +852'),
    ('+36', 'Hungary (HU) +36'),
    ('+354', 'Iceland (IS) +354'),
    ('+91', 'India (IN) +91'),
    ('+62', 'Indonesia (ID) +62'),
    ('+98', 'Iran (IR) +98'),
    ('+964', 'Iraq (IQ) +964'),
    ('+353', 'Ireland (IE) +353'),
    ('+441624', 'Isle of Man (IM) +441624'),
    ('+972', 'Israel (IL) +972'),
    ('+39', 'Italy (IT) +39'),
    ('+225', 'Ivory Coast (CI) +225'),
    ('+1876', 'Jamaica (JM) +1876'),
    ('+81', 'Japan (JP) +81'),
    ('+441534', 'Jersey (JE) +441534'),
    ('+962', 'Jordan (JO) +962'),
    ('+7', 'Kazakhstan (KZ) +7'),
    ('+254', 'Kenya (KE) +254'),
    ('+686', 'Kiribati (KI) +686'),
    ('+383', 'Kosovo (XK) +383'),
    ('+965', 'Kuwait (KW) +965'),
    ('+996', 'Kyrgyzstan (KG) +996'),
    ('+856', 'Laos (LA) +856'),
    ('+371', 'Latvia (LV) +371'),
    ('+961', 'Lebanon (LB) +961'),
    ('+266', 'Lesotho (LS) +266'),
    ('+231', 'Liberia (LR) +231'),
    ('+218', 'Libya (LY) +218'),
    ('+423', 'Liechtenstein (LI) +423'),
    ('+370', 'Lithuania (LT) +370'),
    ('+352', 'Luxembourg (LU) +352'),
    ('+853', 'Macau (MO) +853'),
    ('+389', 'North Macedonia (MK) +389'),
    ('+261', 'Madagascar (MG) +261'),
    ('+265', 'Malawi (MW) +265'),
    ('+60', 'Malaysia (MY) +60'),
    ('+960', 'Maldives (MV) +960'),
    ('+223', 'Mali (ML) +223'),
    ('+356', 'Malta (MT) +356'),
    ('+692', 'Marshall Islands (MH) +692'),
    ('+222', 'Mauritania (MR) +222'),
    ('+230', 'Mauritius (MU) +230'),
    ('+262', 'Mayotte (YT) +262'),
    ('+52', 'Mexico (MX) +52'),
    ('+691', 'Micronesia (FM) +691'),
    ('+373', 'Moldova (MD) +373'),
    ('+377', 'Monaco (MC) +377'),
    ('+976', 'Mongolia (MN) +976'),
    ('+382', 'Montenegro (ME) +382'),
    ('+1664', 'Montserrat (MS) +1664'),
    ('+212', 'Morocco (MA) +212'),
    ('+258', 'Mozambique (MZ) +258'),
    ('+95', 'Myanmar (MM) +95'),
    ('+264', 'Namibia (NA) +264'),
    ('+674', 'Nauru (NR) +674'),
    ('+977', 'Nepal (NP) +977'),
    ('+31', 'Netherlands (NL) +31'),
    ('+687', 'New Caledonia (NC) +687'),
    ('+64', 'New Zealand (NZ) +64'),
    ('+505', 'Nicaragua (NI) +505'),
    ('+227', 'Niger (NE) +227'),
    ('+234', 'Nigeria (NG) +234'),
    ('+683', 'Niue (NU) +683'),
    ('+850', 'North Korea (KP) +850'),
    ('+1670', 'Northern Mariana Islands (MP) +1670'),
    ('+47', 'Norway (NO) +47'),
    ('+968', 'Oman (OM) +968'),
    ('+92', 'Pakistan (PK) +92'),
    ('+680', 'Palau (PW) +680'),
    ('+970', 'Palestine (PS) +970'),
    ('+507', 'Panama (PA) +507'),
    ('+675', 'Papua New Guinea (PG) +675'),
    ('+595', 'Paraguay (PY) +595'),
    ('+51', 'Peru (PE) +51'),
    ('+63', 'Philippines (PH) +63'),
    ('+64', 'Pitcairn (PN) +64'),
    ('+48', 'Poland (PL) +48'),
    ('+351', 'Portugal (PT) +351'),
    ('+1787', 'Puerto Rico (PR) +1787'),
    ('+974', 'Qatar (QA) +974'),
    ('+242', 'Republic of the Congo (CG) +242'),
    ('+262', 'Reunion (RE) +262'),
    ('+40', 'Romania (RO) +40'),
    ('+7', 'Russia (RU) +7'),
    ('+250', 'Rwanda (RW) +250'),
    ('+590', 'Saint Barthelemy (BL) +590'),
    ('+290', 'Saint Helena (SH) +290'),
    ('+1869', 'Saint Kitts and Nevis (KN) +1869'),
    ('+1758', 'Saint Lucia (LC) +1758'),
    ('+590', 'Saint Martin (MF) +590'),
    ('+508', 'Saint Pierre and Miquelon (PM) +508'),
    ('+1784', 'Saint Vincent and the Grenadines (VC) +1784'),
    ('+685', 'Samoa (WS) +685'),
    ('+378', 'San Marino (SM) +378'),
    ('+239', 'Sao Tome and Principe (ST) +239'),
    ('+966', 'Saudi Arabia (SA) +966'),
    ('+221', 'Senegal (SN) +221'),
    ('+381', 'Serbia (RS) +381'),
    ('+248', 'Seychelles (SC) +248'),
    ('+232', 'Sierra Leone (SL) +232'),
    ('+65', 'Singapore (SG) +65'),
    ('+1721', 'Sint Maarten (SX) +1721'),
    ('+421', 'Slovakia (SK) +421'),
    ('+386', 'Slovenia (SI) +386'),
    ('+677', 'Solomon Islands (SB) +677'),
    ('+252', 'Somalia (SO) +252'),
    ('+27', 'South Africa (ZA) +27'),
    ('+82', 'South Korea (KR) +82'),
    ('+211', 'South Sudan (SS) +211'),
    ('+34', 'Spain (ES) +34'),
    ('+94', 'Sri Lanka (LK) +94'),
    ('+249', 'Sudan (SD) +249'),
    ('+597', 'Suriname (SR) +597'),
    ('+47', 'Svalbard and Jan Mayen (SJ) +47'),
    ('+268', 'Swaziland (SZ) +268'),
    ('+46', 'Sweden (SE) +46'),
    ('+41', 'Switzerland (CH) +41'),
    ('+963', 'Syria (SY) +963'),
    ('+886', 'Taiwan (TW) +886'),
    ('+992', 'Tajikistan (TJ) +992'),
    ('+255', 'Tanzania (TZ) +255'),
    ('+66', 'Thailand (TH) +66'),
    ('+228', 'Togo (TG) +228'),
    ('+690', 'Tokelau (TK) +690'),
    ('+676', 'Tonga (TO) +676'),
    ('+1868', 'Trinidad and Tobago (TT) +1868'),
    ('+216', 'Tunisia (TN) +216'),
    ('+90', 'Turkey (TR) +90'),
    ('+993', 'Turkmenistan (TM) +993'),
    ('+1649', 'Turks and Caicos Islands (TC) +1649'),
    ('+688', 'Tuvalu (TV) +688'),
    ('+1340', 'U.S. Virgin Islands (VI) +1340'),
    ('+256', 'Uganda (UG) +256'),
    ('+380', 'Ukraine (UA) +380'),
    ('+971', 'United Arab Emirates (AE) +971'),
    ('+44', 'United Kingdom (GB) +44'),
    ('+1', 'United States (US) +1'),
    ('+598', 'Uruguay (UY) +598'),
    ('+998', 'Uzbekistan (UZ) +998'),
    ('+678', 'Vanuatu (VU) +678'),
    ('+379', 'Vatican (VA) +379'),
    ('+58', 'Venezuela (VE) +58'),
    ('+84', 'Vietnam (VN) +84'),
    ('+681', 'Wallis and Futuna (WF) +681'),
    ('+212', 'Western Sahara (EH) +212'),
    ('+967', 'Yemen (YE) +967'),
    ('+260', 'Zambia (ZM) +260'),
    ('+263', 'Zimbabwe (ZW) +263')
)


# MEETING_METHOD_CHOICES = [
#         ('online', mark_safe(
#             '<i class="bi bi-laptop text-primary me-2"></i> '
#             '<span class="fw-bold">Online Only</span> '
#             '<span class="badge bg-primary ms-2">DEFAULT</span>'
#         )),
#         ('hybrid', mark_safe(
#             '<i class="bi bi-laptop text-primary me-1"></i> + '
#             '<i class="bi bi-geo-alt text-success ms-1 me-2"></i>'
#             '<span class="fw-bold">Hybrid</span> '
#             '<span class="badge bg-success ms-2">OPTIONAL</span>'
#         ))

class ProviderApplicationForm(forms.ModelForm):
    captcha = ReCaptchaField(widget=ReCaptchaV2Checkbox)

    class Meta:
        model = ProviderApplication
        fields = ['first_name', 'last_name', 'email', 'phone', 'photo', 'resume', 'bio', 'lang_native', 'skills']
        help_texts = {
            'skills': "Select up to 2 primary teaching skills",
            'resume': "PDF, DOCX (max 1MB)",
        }

    first_name = forms.CharField(max_length=50, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'First name',
    }))
    last_name = forms.CharField(max_length=50, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Last name',
    }))
    email = forms.EmailField(max_length=100, required=True, widget=forms.EmailInput(attrs={
        'class': 'form-control',
        'placeholder': 'Email',
        'required': 'required',
    }))
    phone = forms.CharField(max_length=30, required=True,
                            # validators=[RegexValidator(
                            #     regex=r'^\+?[0-9]{8,15}$',
                            #     message="Enter a valid phone number (8-15 digits, + optional)"
                            # )],
                            widget=forms.TextInput(attrs={
                                'class': 'form-control',
                                'placeholder': 'Phone',
                                'required': 'required',
                            }))
    photo = forms.ImageField(required=False)
    resume = forms.FileField(required=False, widget=forms.FileInput(attrs={
        'class': 'form-control',
    }))
    bio = forms.CharField(max_length=500, required=True, widget=forms.Textarea(attrs={
        'class': 'form-control',
        'spellcheck': "false",
        'rows': 3,
        'required': 'required',
    }))
    lang_native = forms.ChoiceField(choices=LANGUAGE_CHOICES, required=True, initial='', widget=forms.Select(attrs={
        'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
        'aria-label': '.form-select-sm',
        'data-search-enabled': 'true',
        'data-remove-item-button': 'true',
        'required': 'required',
    }))
    skills = forms.ModelMultipleChoiceField(
        queryset=Skill.objects.all(),
        required=True,
        widget=forms.SelectMultiple(attrs={
            'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
            'multiple': 'multiple',
            'aria-label': '.form-select-sm',
            'data-max-item-count': 5,
            'data-remove-item-button': 'true',
            'required': 'required',
        }))

    def clean_photo(self):
        photo = self.cleaned_data.get('photo')
        if photo and photo.size > 1 * 1024 * 1024:  # 5MB limit
            raise forms.ValidationError("Max image size is 1MB")
        return photo

    def clean_resume(self):
        resume = self.cleaned_data.get('resume')
        if resume:
            # Check file extension
            valid_extensions = ['.pdf', '.doc', '.docx']
            extension = os.path.splitext(resume.name)[1].lower()
            if extension not in valid_extensions:
                raise ValidationError(
                    'Unsupported file format. Allowed: PDF, DOC, DOCX'
                )

            # Check file size (5MB limit)
            if resume.size > 1 * 1024 * 1024:
                raise ValidationError(
                    'File too large. Max size is 1MB.'
                )
        return resume


# Profile Setup Form
class CombinedProfileForm(forms.Form):
    # User fields
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
    username = forms.CharField(max_length=50, required=True, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'User name',
        'required': 'required',
    }))
    email = forms.EmailField(max_length=50, required=True, widget=forms.EmailInput(attrs={
        'class': 'form-control',
        'placeholder': 'Email',
        'required': 'required',
    }))

    # UserProfile fields
    title = forms.CharField(max_length=100, required=False, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Title',
    }))
    phone = forms.CharField(max_length=30, required=True, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Phone',
        'required': 'required',
    }))
    gender = forms.ChoiceField(choices=GENDER_CHOICES, required=True, initial='male', widget=forms.Select(attrs={
        'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
        'data-search-enabled': 'false',
        'placeholder': 'Gender',
        'required': 'required',
    }))
    photo = forms.ImageField(required=False)
    delete_photo = forms.BooleanField(required=False, initial=False)
    bio = forms.CharField(max_length=500, required=False, widget=forms.Textarea(attrs={
        'class': 'form-control',
        'rows': 5,
    }))

    country = forms.ChoiceField(choices=COUNTRY_CHOICES, required=True, initial='', widget=forms.Select(attrs={
        'class': 'form-select js-choice border-1 z-index-9 bg-transparent',
        'aria-label': '.form-select-sm',
        'data-search-enabled': 'true',
        'data-remove-item-button': 'true',
        'placeholder': 'Location',
        'required': 'required',
    }))

    #
    availability = forms.BooleanField(required=False, initial=True)
    lang_native = forms.ChoiceField(choices=LANGUAGE_CHOICES, required=True, initial='', widget=forms.Select(attrs={
        'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
        'aria-label': '.form-select-sm',
        'data-search-enabled': 'true',
        'data-remove-item-button': 'true',
        'required': 'required',
    }))

    # Language fields
    lang_speak = forms.ModelMultipleChoiceField(
        queryset=Language.objects.all(),
        required=True,
        widget=forms.SelectMultiple(attrs={
            'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
            'multiple': 'multiple',
            'aria-label': '.form-select-sm',
            'data-max-item-count': 3,
            'data-remove-item-button': 'true',
            'placeholder': 'Select language',
            'required': 'required',
        })
    )

    # Tutor fields
    video_url = forms.URLField(required=False, widget=forms.TextInput(attrs={
        'type': 'text',
        'class': 'form-control',
        'placeholder': 'Introduction Video URL',
    }))
    video_intro = forms.FileField(required=True, widget=forms.FileInput(attrs={
        'class': 'form-control',
        'placeholder': 'Upload Introduction Video',
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

    discount = forms.DecimalField(max_digits=4, decimal_places=0, initial=0.00, required=False,
                                  widget=forms.NumberInput(attrs={
                                      'class': 'form-control',
                                      'placeholder': 'Discount',
                                      'step': '1',
                                      'min': '0',
                                      'max': '100',
                                  }))

    discount_deadline = forms.DateTimeField(required=False, widget=forms.DateTimeInput(attrs={
        'class': 'form-control',
        'type': 'datetime-local',
    }))

    # skills = forms.ModelMultipleChoiceField(
    #     queryset=Skill.objects.all(),
    #     required=True,
    #     widget=forms.SelectMultiple(attrs={
    #         'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
    #         'multiple': 'multiple',
    #         'aria-label': '.form-select-sm',
    #         'data-max-item-count': 5,
    #         'data-remove-item-button': 'true',
    #         'required': 'required',
    #     }))

    # skill_level = forms.ModelMultipleChoiceField(
    #     queryset=Level.objects.all(),
    #     required=False,
    #     widget=forms.SelectMultiple(attrs={
    #         'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
    #         'multiple': 'multiple',
    #         'aria-label': '.form-select-sm',
    #         'data-max-item-count': 6,
    #         'data-remove-item-button': 'true',
    #
    #     })
    # )

    def __init__(self, *args, **kwargs):
        # Extract instance data for User, UserProfile, and Tutor
        self.user_instance = kwargs.pop('user_instance', None)
        self.profile_instance = kwargs.pop('profile_instance', None)
        self.tutor_instance = kwargs.pop('tutor_instance', None)

        # Call super().__init__() first to initialize self.fields
        super().__init__(*args, **kwargs)

        if self.user_instance:
            # Populate User fields
            user_fields = ['first_name', 'last_name', 'username', 'email']
            for field in user_fields:
                self.fields[field].initial = getattr(self.user_instance, field)

        if self.profile_instance:
            # Populate UserProfile fields
            profile_fields = ['gender', 'phone', 'country', 'photo', 'title', 'bio', 'availability', 'lang_native']
            for field in profile_fields:
                self.fields[field].initial = getattr(self.profile_instance, field)
            self.fields['lang_speak'].initial = self.profile_instance.lang_speak.all()

        if self.tutor_instance:
            # Populate Tutor fields
            tutor_fields = ['video_url', 'cost_trial', 'cost_hourly', 'discount', 'discount_deadline']
            for field in tutor_fields:
                self.fields[field].initial = getattr(self.tutor_instance, field)
            # self.fields['skills'].initial = self.tutor_instance.skills.all()
            # self.fields['skill_level'].initial = self.tutor_instance.skill_level.all()

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
        # tutor.skills.set(self.cleaned_data['skills'])
        # tutor.skill_level.set(self.cleaned_data['skill_level'])
        profile.lang_speak.set(self.cleaned_data['lang_speak'])

        return user_instance, profile, tutor


# Profile Basic Form
class ProfileBasicForm(forms.Form):
    # User fields
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
    username = forms.CharField(max_length=50, required=False, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'User name',
        # 'required': 'required',
        'readonly': 'readonly',  # Prevents editing
    }))
    email = forms.EmailField(max_length=50, required=True, widget=forms.EmailInput(attrs={
        'class': 'form-control',
        'placeholder': 'Email',
        # 'required': 'required',
        'readonly': 'readonly',  # Prevents editing
    }))

    # UserProfile fields
    title = forms.CharField(max_length=100, required=False, widget=forms.TextInput(attrs={
        'class': 'form-control',
        'placeholder': 'Title',
    }))

    gender = forms.ChoiceField(choices=GENDER_CHOICES, required=True, initial='male', widget=forms.Select(attrs={
        'class': 'form-select js-choice z-index-9 border-0 bg-light',
        'aria-label': ".form-select-sm",
        'data-search-enabled': 'false',
        'placeholder': 'Gender',
        'required': 'required',
    }))
    photo = forms.ImageField(required=False)
    delete_photo = forms.BooleanField(required=False, initial=False)
    bio = forms.CharField(max_length=500, required=False, widget=forms.Textarea(attrs={
        'class': 'form-control',
        'rows': 5,
    }))
    # Phone fields - separate but will be combined in UI
    phone_country_code = forms.CharField(
        max_length=5,
        required=False,
        widget=forms.HiddenInput(attrs={
            # 'id': 'selectedCountryCodeHidden',
        })
    )

    phone_number = forms.CharField(
        max_length=20,
        required=False,
        widget=forms.HiddenInput(attrs={
            # 'id': 'phoneNumberHidden',
        })
    )

    # Display-only field for the UI
    phone_display = forms.CharField(
        required=False,
        widget=forms.TextInput(attrs={
            'class': 'form-control border-0',
            # 'id': 'phoneNumber',
            'placeholder': '123456789',
            'pattern': '[0-9]{8,15}',
            'title': 'Please enter 8-15 digits'
        })
    )

    lang_native = forms.ChoiceField(choices=LANGUAGE_CHOICES, required=True, initial='', widget=forms.Select(attrs={
        'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
        'aria-label': '.form-select-sm',
        'data-search-enabled': 'true',
        'data-remove-item-button': 'true',
        'required': 'required',
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
            'required': 'required',
        })
    )
    country = forms.ChoiceField(choices=COUNTRY_CHOICES, required=True, initial='', widget=forms.Select(attrs={
        'class': 'form-select js-choice border-1 z-index-9 bg-transparent',
        'aria-label': '.form-select-sm',
        'data-search-enabled': 'true',
        'data-remove-item-button': 'true',
        'placeholder': 'Location',
        'required': 'required',
    }))

    # cost_trial = forms.DecimalField(max_digits=10, decimal_places=2, initial=0.00, widget=forms.NumberInput(attrs={
    #     'class': 'form-control',
    #     'placeholder': 'Trial Cost',
    #     'step': '0.10',
    #     'min': '0',
    # }))
    # cost_hourly = forms.DecimalField(max_digits=10, decimal_places=2, initial=0.00, widget=forms.NumberInput(attrs={
    #     'class': 'form-control',
    #     'placeholder': 'Hourly Cost',
    #     'step': '0.10',
    #     'min': '0',
    # }))
    #
    # discount = forms.DecimalField(max_digits=4, decimal_places=0, initial=0.00, required=False,
    #                               widget=forms.NumberInput(attrs={
    #                                   'class': 'form-control',
    #                                   'placeholder': 'Discount',
    #                                   'step': '1',
    #                                   'min': '0',
    #                                   'max': '100',
    #                               }))
    #
    # discount_deadline = forms.DateTimeField(required=False, widget=forms.DateTimeInput(attrs={
    #     'class': 'form-control',
    #     'type': 'datetime-local',
    # }))

    def __init__(self, *args, **kwargs):
        # Extract instance data for User, UserProfile, and Tutor
        self.user_instance = kwargs.pop('user_instance', None)
        self.profile_instance = kwargs.pop('profile_instance', None)
        self.tutor_instance = kwargs.pop('tutor_instance', None)

        # Call super().__init__() first to initialize self.fields
        super().__init__(*args, **kwargs)

        if self.user_instance:
            # Populate User fields
            user_fields = ['first_name', 'last_name', 'username', 'email']
            for field in user_fields:
                self.fields[field].initial = getattr(self.user_instance, field)
            self.fields['email'].widget.attrs['readonly'] = True
            # self.fields['email'].widget.attrs['disabled'] = True
            self.fields['email'].help_text = "Email cannot be changed"
            self.fields['email'].required = False  # Since disabled fields aren't submitted

            self.fields['username'].widget.attrs['readonly'] = True
            self.fields['username'].help_text = "Username cannot be changed"
            self.fields['username'].required = False  # Since disabled fields aren't submitted

        if self.profile_instance:
            # Populate UserProfile fields
            profile_fields = ['gender', 'phone_country_code', 'phone_number', 'photo', 'title', 'bio', 'lang_native',
                              'country']
            for field in profile_fields:
                self.fields[field].initial = getattr(self.profile_instance, field)

            self.fields['lang_speak'].initial = self.profile_instance.lang_speak.all()

        # if self.tutor_instance:
        # Populate Tutor fields
        # tutor_fields = ['video_url', 'cost_trial', 'cost_hourly', 'discount', 'discount_deadline']
        # for field in tutor_fields:
        #     self.fields[field].initial = getattr(self.tutor_instance, field)
        # self.fields['skills'].initial = self.tutor_instance.skills.all()
        # self.fields['skill_level'].initial = self.tutor_instance.skill_level.all()

    def clean_email(self):
        email = self.cleaned_data.get('email')
        if hasattr(self, 'user_instance') and self.user_instance:
            if email != self.user_instance.email:
                raise forms.ValidationError("Email cannot be changed")
        return email

    def clean_phone_country_code(self):
        country_code = self.cleaned_data.get('phone_country_code', '')
        if country_code and not country_code.startswith('+'):
            raise forms.ValidationError("Country code must start with +")
        return country_code

    # def clean_phone_number(self):
    #     phone_number = self.cleaned_data.get('phone_number')
    #     if phone_number:  # Only validate if phone number is provided
    #         if not phone_number.isdigit():
    #             raise forms.ValidationError("Phone number must contain only digits")
    #         if len(phone_number) < 8 or len(phone_number) > 15:
    #             raise forms.ValidationError("Phone number must be 8-15 digits")
    #     return phone_number

    # --------------------------------------------------------
    def clean(self):
        cleaned_data = super().clean()

        # Phone validation
        phone_value = cleaned_data.get('phone_display', '') or cleaned_data.get('phone_number', '')
        if phone_value:
            clean_phone = ''.join(c for c in phone_value if c.isdigit())
            if len(clean_phone) < 8 or len(clean_phone) > 15:
                raise forms.ValidationError("Phone number must be 8-15 digits")
            cleaned_data['phone_number'] = clean_phone
            cleaned_data['phone_display'] = clean_phone

        return cleaned_data

    def save(self, user):

        # Get original email before any processing
        original_email = user.email
        original_username = user.username

        # Update or create User - explicitly prevent email changes
        user_data = {
            'first_name': self.cleaned_data['first_name'],
            'last_name': self.cleaned_data['last_name'],
            # 'username': self.cleaned_data['username'],
            'email': original_email,  # Force original email regardless of input
            'username': original_username,  # Force original username regardless of input
        }
        user_instance, created = User.objects.update_or_create(id=user.id, defaults=user_data)

        # Update or create UserProfile
        profile_data = {
            'user': user_instance,
            'gender': self.cleaned_data['gender'],
            'phone_country_code': self.cleaned_data['phone_country_code'],
            'phone_number': self.cleaned_data['phone_number'],
            'country': self.cleaned_data['country'],
            'title': self.cleaned_data['title'],
            'bio': self.cleaned_data['bio'],
            'lang_native': self.cleaned_data['lang_native'],
        }
        # Handle photo separately to avoid overwriting if no new photo is provided
        if self.cleaned_data.get('delete_photo'):  # User deleted the photo
            profile_data['photo'] = 'photos/default.png'  # Set default photo
        elif self.cleaned_data.get('photo'):  # New photo uploaded
            profile_data['photo'] = self.cleaned_data['photo']

        profile, created = UserProfile.objects.update_or_create(user=user_instance, defaults=profile_data)

        # Update or create Tutor
        # tutor_data = {
        #     'profile': profile,
        #     'video_url': self.cleaned_data['video_url'],
        #     'cost_trial': self.cleaned_data['cost_trial'],
        #     'cost_hourly': self.cleaned_data['cost_hourly'],
        #     'discount': self.cleaned_data['discount'],
        #     'discount_deadline': self.cleaned_data['discount_deadline'],
        # }
        # tutor, created = Tutor.objects.update_or_create(profile=profile, defaults=tutor_data)

        # Handle many-to-many fields
        # tutor.skills.set(self.cleaned_data['skills'])
        # tutor.skill_level.set(self.cleaned_data['skill_level'])
        profile.lang_speak.set(self.cleaned_data['lang_speak'])

        # return user_instance, profile, tutor
        return user_instance, profile


# Teaching Skills & Video upload field Form
class CombinedSkillForm(forms.Form):
    # Fields from UserSkill model
    skill = forms.ModelChoiceField(queryset=Skill.objects.all(), required=True, widget=forms.Select(attrs={
        'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
        'aria-label': '.form-select-sm',
        'data-search-enabled': 'true',
        'data-remove-item-button': 'true',
        'required': 'required',
    }))
    level = forms.ModelChoiceField(queryset=Level.objects.all(), required=True, widget=forms.Select(attrs={
        'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
        'aria-label': '.form-select-sm',
        'data-search-enabled': 'true',
        'data-remove-item-button': 'true',
        'required': 'required',
    }),
                                   empty_label="Select Level"
                                   )
    certificate = forms.FileField(required=False, widget=forms.FileInput(attrs={
        'accept': '.pdf,.doc,.docx,.png,.jpg,.jpeg',
        'class': 'form-control'
    }))

    # Fields from Tutor model
    video_intro = forms.FileField(required=True, widget=forms.FileInput(attrs={
        'class': 'form-control',
        'placeholder': 'Upload Introduction Video',
        'required': 'required',
    }))
    # Tutor fields
    # video_url = forms.URLField(required=False, widget=forms.TextInput(attrs={
    #     'type': 'text',
    #     'class': 'form-control',
    #     'placeholder': 'Introduction Video URL',
    # }))
    # language Native
    lang_native = forms.ChoiceField(choices=LANGUAGE_CHOICES, required=True, initial='', widget=forms.Select(attrs={
        'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
        'aria-label': '.form-select-sm',
        'data-search-enabled': 'true',
        'data-remove-item-button': 'true',
        'required': 'required',
    }))

    # Language fields
    lang_speak = forms.ModelMultipleChoiceField(queryset=Language.objects.all(), required=True,
                                                widget=forms.SelectMultiple(attrs={
                                                    'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
                                                    'multiple': 'multiple',
                                                    'aria-label': '.form-select-sm',
                                                    'data-max-item-count': 4,
                                                    'data-remove-item-button': 'true',
                                                    'placeholder': 'Select language',
                                                    'required': 'required',
                                                })
                                                )

    def __init__(self, *args, user=None, **kwargs):
        self.user = user
        super().__init__(*args, **kwargs)
        if user and hasattr(user, 'tutor'):
            self.fields['video_intro'].initial = user.profile.tutor_profile.video_intro

    def save(self):
        # Save UserSkill
        user_skill = UserSkill(
            user=self.user,
            skill=self.cleaned_data['skill'],
            level=self.cleaned_data['level'],
            certificate=self.cleaned_data['certificate']
        )
        user_skill.save()

        # Save Tutor
        tutor = self.user.profile.tutor_profile
        tutor.video_intro = self.cleaned_data['video_intro']
        tutor.save()

        return user_skill, tutor


class CombinedSkillForm2(forms.Form):
    skill = forms.ModelChoiceField(
        queryset=Skill.objects.all(),
        required=True,
        widget=forms.Select(attrs={
            'class': 'form-select form-select-sm',
            'data-placeholder': 'Select a skill'
        })
    )

    level = forms.ModelChoiceField(
        queryset=Level.objects.all(),
        required=True,
        widget=forms.Select(attrs={
            'class': 'form-select form-select-sm',
            'data-placeholder': 'Select level'
        })
    )

    certificate = forms.FileField(
        required=False,
        widget=forms.FileInput(attrs={
            'class': 'form-control form-control-sm',
            'accept': '.pdf,.doc,.docx,.png,.jpg,.jpeg'
        })
    )

    video_intro = forms.FileField(
        required=True,
        widget=forms.FileInput(attrs={
            'class': 'form-control',
            'accept': 'video/*'
        })
    )

    def __init__(self, *args, user=None, **kwargs):
        super().__init__(*args, **kwargs)
        self.user = user
        # Optimize querysets
        self.fields['skill'].queryset = Skill.objects.active()
        self.fields['level'].queryset = Level.objects.all()

        if user and hasattr(user, 'tutor'):
            self.fields['video_intro'].initial = user.tutor.video_intro


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
        self.profile_instance = kwargs.pop('profile_instance', None)

        # Call super().__init__() first to initialize self.fields
        super().__init__(*args, **kwargs)

        if self.profile_instance:
            # Populate UserProfile fields
            profile_fields = ['url_facebook', 'url_insta', 'url_twitter', 'url_linkedin', 'url_youtube']
            for field in profile_fields:
                self.fields[field].initial = getattr(self.profile_instance, field)

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


# On-boarding wizard step 4 (Extra info: years_experience, teaching_tags (TAGs) )
class EducationalExtraForm(forms.Form):
    years_experience = forms.ChoiceField(choices=TEACHING_YEARS, required=False, initial='', widget=forms.Select(attrs={
        'class': 'form-select js-choice border-1 z-index-9 bg-transparent',
        'aria-label': '.form-select-sm',
        'data-search-enabled': 'true',
        'data-remove-item-button': 'true',
        'placeholder': 'Years of Experience',
    }))
    teaching_tags = forms.ModelMultipleChoiceField(
        queryset=TeachingCategory.objects.all(),
        required=False,
        widget=forms.SelectMultiple(attrs={
            'class': 'form-select js-choice border-0 z-index-9 bg-transparent',
            'multiple': 'multiple',
            'aria-label': '.form-select-sm',
            'data-max-item-count': MAX_MULTIPLE_ITEMS,
            'data-remove-item-button': 'true',
            'placeholder': 'Select Teaching Tags',
            'required': 'required',
        })
    )

    def __init__(self, *args, **kwargs):
        # Extract instance data for User, UserProfile, and Tutor
        self.user_instance = kwargs.pop('user_instance', None)
        self.tutor_instance = kwargs.pop('tutor_instance', None)

        # Call super().__init__() first to initialize self.fields
        super().__init__(*args, **kwargs)

        if self.tutor_instance:
            # Populate Tutor fields
            tutor_fields = ['years_experience']
            for field in tutor_fields:
                self.fields[field].initial = getattr(self.tutor_instance, field)
            self.fields['teaching_tags'].initial = self.tutor_instance.teaching_tags.all()
            # self.fields['skill_level'].initial = self.tutor_instance.skill_level.all()

    def save(self, user):
        # Update or create Tutor
        tutor_data = {
            'profile': user.profile,
            'years_experience': self.cleaned_data['years_experience'],
        }
        tutor, created = Tutor.objects.update_or_create(profile=user.profile, defaults=tutor_data)
        # Handle many-to-many fields
        tutor.teaching_tags.set(self.cleaned_data['teaching_tags'])

        return tutor


class PricingForm(forms.ModelForm):
    class Meta:
        model = Tutor
        fields = ['cost_hourly', 'cost_trial']
        widgets = {
            'cost_trial': forms.NumberInput(attrs={
                'class': 'form-control',
                'placeholder': 'Trial Cost',
                'step': '0.10',
                'min': '0',
            }),
            'cost_hourly': forms.NumberInput(attrs={
                'class': 'form-control',
                'placeholder': 'Hourly Cost',
                'step': '0.10',
                'min': '0',
            }),
        }
