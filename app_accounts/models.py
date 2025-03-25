from django.db import models
from django.contrib.auth.models import User, Group
from django.utils import timezone

USER_TYPES = [('student', 'Student'), ('tutor', 'Tutor'), ('admin', 'Admin'), ('staff', 'Staff')]
COUNTRY_CHOICES = [
    ('', 'Choose a country'),
    ('Afghanistan', 'Afghanistan'),
    ('Albania', 'Albania'),
    ('Algeria', 'Algeria'),
    ('Andorra', 'Andorra'),
    ('Angola', 'Angola'),
    ('Antigua and Barbuda', 'Antigua and Barbuda'),
    ('Argentina', 'Argentina'),
    ('Armenia', 'Armenia'),
    ('Australia', 'Australia'),
    ('Austria', 'Austria'),
    ('Azerbaijan', 'Azerbaijan'),
    ('Bahamas', 'Bahamas'),
    ('Bahrain', 'Bahrain'),
    ('Bangladesh', 'Bangladesh'),
    ('Barbados', 'Barbados'),
    ('Belarus', 'Belarus'),
    ('Belgium', 'Belgium'),
    ('Belize', 'Belize'),
    ('Benin', 'Benin'),
    ('Bhutan', 'Bhutan'),
    ('Bolivia', 'Bolivia'),
    ('Bosnia and Herzegovina', 'Bosnia and Herzegovina'),
    ('Botswana', 'Botswana'),
    ('Brazil', 'Brazil'),
    ('Brunei', 'Brunei'),
    ('Bulgaria', 'Bulgaria'),
    ('Burkina Faso', 'Burkina Faso'),
    ('Burundi', 'Burundi'),
    ('Cabo Verde', 'Cabo Verde'),
    ('Cambodia', 'Cambodia'),
    ('Cameroon', 'Cameroon'),
    ('Canada', 'Canada'),
    ('Central African Republic', 'Central African Republic'),
    ('Chad', 'Chad'),
    ('Chile', 'Chile'),
    ('China', 'China'),
    ('Colombia', 'Colombia'),
    ('Comoros', 'Comoros'),
    ('Congo (Congo-Brazzaville)', 'Congo (Congo-Brazzaville)'),
    ('Costa Rica', 'Costa Rica'),
    ('Croatia', 'Croatia'),
    ('Cuba', 'Cuba'),
    ('Cyprus', 'Cyprus'),
    ('Czech Republic', 'Czech Republic'),
    ('Democratic Republic of the Congo', 'Democratic Republic of the Congo'),
    ('Denmark', 'Denmark'),
    ('Djibouti', 'Djibouti'),
    ('Dominica', 'Dominica'),
    ('Dominican Republic', 'Dominican Republic'),
    ('Ecuador', 'Ecuador'),
    ('Egypt', 'Egypt'),
    ('El Salvador', 'El Salvador'),
    ('Equatorial Guinea', 'Equatorial Guinea'),
    ('Eritrea', 'Eritrea'),
    ('Estonia', 'Estonia'),
    ('Eswatini', 'Eswatini'),
    ('Ethiopia', 'Ethiopia'),
    ('Fiji', 'Fiji'),
    ('Finland', 'Finland'),
    ('France', 'France'),
    ('Gabon', 'Gabon'),
    ('Gambia', 'Gambia'),
    ('Georgia', 'Georgia'),
    ('Germany', 'Germany'),
    ('Ghana', 'Ghana'),
    ('Greece', 'Greece'),
    ('Grenada', 'Grenada'),
    ('Guatemala', 'Guatemala'),
    ('Guinea', 'Guinea'),
    ('Guinea-Bissau', 'Guinea-Bissau'),
    ('Guyana', 'Guyana'),
    ('Haiti', 'Haiti'),
    ('Honduras', 'Honduras'),
    ('Hungary', 'Hungary'),
    ('Iceland', 'Iceland'),
    ('India', 'India'),
    ('Indonesia', 'Indonesia'),
    ('Iran', 'Iran'),
    ('Iraq', 'Iraq'),
    ('Ireland', 'Ireland'),
    ('Israel', 'Israel'),
    ('Italy', 'Italy'),
    ('Jamaica', 'Jamaica'),
    ('Japan', 'Japan'),
    ('Jordan', 'Jordan'),
    ('Kazakhstan', 'Kazakhstan'),
    ('Kenya', 'Kenya'),
    ('Kiribati', 'Kiribati'),
    ('Kuwait', 'Kuwait'),
    ('Kyrgyzstan', 'Kyrgyzstan'),
    ('Laos', 'Laos'),
    ('Latvia', 'Latvia'),
    ('Lebanon', 'Lebanon'),
    ('Lesotho', 'Lesotho'),
    ('Liberia', 'Liberia'),
    ('Libya', 'Libya'),
    ('Liechtenstein', 'Liechtenstein'),
    ('Lithuania', 'Lithuania'),
    ('Luxembourg', 'Luxembourg'),
    ('Madagascar', 'Madagascar'),
    ('Malawi', 'Malawi'),
    ('Malaysia', 'Malaysia'),
    ('Maldives', 'Maldives'),
    ('Mali', 'Mali'),
    ('Malta', 'Malta'),
    ('Marshall Islands', 'Marshall Islands'),
    ('Mauritania', 'Mauritania'),
    ('Mauritius', 'Mauritius'),
    ('Mexico', 'Mexico'),
    ('Micronesia', 'Micronesia'),
    ('Moldova', 'Moldova'),
    ('Monaco', 'Monaco'),
    ('Mongolia', 'Mongolia'),
    ('Montenegro', 'Montenegro'),
    ('Morocco', 'Morocco'),
    ('Mozambique', 'Mozambique'),
    ('Myanmar (Burma)', 'Myanmar (Burma)'),
    ('Namibia', 'Namibia'),
    ('Nauru', 'Nauru'),
    ('Nepal', 'Nepal'),
    ('Netherlands', 'Netherlands'),
    ('New Zealand', 'New Zealand'),
    ('Nicaragua', 'Nicaragua'),
    ('Niger', 'Niger'),
    ('Nigeria', 'Nigeria'),
    ('North Korea', 'North Korea'),
    ('North Macedonia', 'North Macedonia'),
    ('Norway', 'Norway'),
    ('Oman', 'Oman'),
    ('Pakistan', 'Pakistan'),
    ('Palau', 'Palau'),
    ('Palestine', 'Palestine'),
    ('Panama', 'Panama'),
    ('Papua New Guinea', 'Papua New Guinea'),
    ('Paraguay', 'Paraguay'),
    ('Peru', 'Peru'),
    ('Philippines', 'Philippines'),
    ('Poland', 'Poland'),
    ('Portugal', 'Portugal'),
    ('Qatar', 'Qatar'),
    ('Romania', 'Romania'),
    ('Russia', 'Russia'),
    ('Rwanda', 'Rwanda'),
    ('Saint Kitts and Nevis', 'Saint Kitts and Nevis'),
    ('Saint Lucia', 'Saint Lucia'),
    ('Saint Vincent and the Grenadines', 'Saint Vincent and the Grenadines'),
    ('Samoa', 'Samoa'),
    ('San Marino', 'San Marino'),
    ('Sao Tome and Principe', 'Sao Tome and Principe'),
    ('Saudi Arabia', 'Saudi Arabia'),
    ('Senegal', 'Senegal'),
    ('Serbia', 'Serbia'),
    ('Seychelles', 'Seychelles'),
    ('Sierra Leone', 'Sierra Leone'),
    ('Singapore', 'Singapore'),
    ('Slovakia', 'Slovakia'),
    ('Slovenia', 'Slovenia'),
    ('Solomon Islands', 'Solomon Islands'),
    ('Somalia', 'Somalia'),
    ('South Africa', 'South Africa'),
    ('South Korea', 'South Korea'),
    ('South Sudan', 'South Sudan'),
    ('Spain', 'Spain'),
    ('Sri Lanka', 'Sri Lanka'),
    ('Sudan', 'Sudan'),
    ('Suriname', 'Suriname'),
    ('Sweden', 'Sweden'),
    ('Switzerland', 'Switzerland'),
    ('Syria', 'Syria'),
    ('Taiwan', 'Taiwan'),
    ('Tajikistan', 'Tajikistan'),
    ('Tanzania', 'Tanzania'),
    ('Thailand', 'Thailand'),
    ('Timor-Leste', 'Timor-Leste'),
    ('Togo', 'Togo'),
    ('Tonga', 'Tonga'),
    ('Trinidad and Tobago', 'Trinidad and Tobago'),
    ('Tunisia', 'Tunisia'),
    ('Turkey', 'Turkey'),
    ('Turkmenistan', 'Turkmenistan'),
    ('Tuvalu', 'Tuvalu'),
    ('Uganda', 'Uganda'),
    ('Ukraine', 'Ukraine'),
    ('United Arab Emirates', 'United Arab Emirates'),
    ('United Kingdom', 'United Kingdom'),
    ('United States', 'United States'),
    ('Uruguay', 'Uruguay'),
    ('Uzbekistan', 'Uzbekistan'),
    ('Vanuatu', 'Vanuatu'),
    ('Vatican City', 'Vatican City'),
    ('Venezuela', 'Venezuela'),
    ('Vietnam', 'Vietnam'),
    ('Yemen', 'Yemen'),
    ('Zambia', 'Zambia'),
    ('Zimbabwe', 'Zimbabwe')
]
LANGUAGE_CHOICES = [
    ('', 'Select your native language'),
    ('Persian', 'Persian'),
    ('English', 'English'),
    ('Dutch', 'Dutch'),
    ('Spanish', 'Spanish'),
    ('French', 'French'),
    ('Chinese', 'Chinese'),
    ('Italian', 'Italian'),
    ('Turkish', 'Turkish'),
    ('Swedish', 'Swedish'),
    ('Korean', 'Korean'),
    ('Russian', 'Russian'),
    ('Japanese', 'Japanese'),
    ('Ukranian', 'Ukranian'),
    ('Arabic', 'Arabic'),
]
GENDER_CHOICES = [('female', 'Female'), ('male', 'Male'), ('transgender', 'Transgender')]


class Language(models.Model):
    name = models.CharField(max_length=20, choices=LANGUAGE_CHOICES, unique=True)

    def __str__(self):
        return self.name


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    gender = models.CharField(max_length=20, choices=GENDER_CHOICES, blank=True, null=True, default='male')
    phone = models.CharField(max_length=50, blank=True, null=True)
    country = models.CharField(max_length=100, choices=COUNTRY_CHOICES, default='Unknown')
    photo = models.ImageField(upload_to='photos/profiles/', blank=True, null=True, default='photos/default.png')
    user_type = models.CharField(max_length=20, choices=USER_TYPES, default='student',
                                 blank=False)  # Important for role distinction
    title = models.CharField(max_length=100, blank=True)
    lang_native = models.CharField(max_length=100, choices=LANGUAGE_CHOICES, default='Unknown')
    lang_speak = models.ManyToManyField(Language, blank=True)
    bio = models.TextField(max_length=350, blank=True)
    availability = models.BooleanField(blank=True, default=True)
    is_vip = models.BooleanField(blank=False, default=False)
    rating = models.FloatField(default=0.0)
    reviews_count = models.IntegerField(default=0)
    url_facebook = models.URLField(max_length=150, blank=True)
    url_insta = models.URLField(max_length=150, blank=True)
    url_twitter = models.URLField(max_length=150, blank=True)
    url_linkedin = models.URLField(max_length=150, blank=True)
    url_youtube = models.URLField(max_length=150, blank=True)
    create_date = models.DateTimeField(auto_now_add=True)  # Use auto_now_add
    last_modified = models.DateTimeField(default=timezone.now, blank=True)

    def __str__(self):
        return self.user.username

    def save(self, *args, **kwargs):
        user_type_choices = ['student', 'admin', 'tutor', 'staff']
        if self.user_type not in user_type_choices:
            raise ValueError(f"Invalid user_type: {self.user_type}")

        # Ensure user group is consistent with user_type (get user_type if exist and create if not exist!)
        user_group, created = Group.objects.get_or_create(name=self.user_type)
        self.user.groups.add(user_group)

        if not self.photo:
            self.photo = 'photos/default.png'
        self.last_modified = timezone.now()
        super().save(*args, **kwargs)



