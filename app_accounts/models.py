from django.db import models
from django.contrib.auth.models import User, Group
from django.utils import timezone
from django.core.validators import MaxValueValidator, MinValueValidator, FileExtensionValidator

USER_TYPES = [('student', 'Student'), ('tutor', 'Tutor'), ('admin', 'Admin'), ('staff', 'Staff'),
              ('interviewer', 'Interviewer')]
GENDER_CHOICES = [('female', 'Female'), ('male', 'Male'), ('transgender', 'Transgender')]
ALLOWED_EXTENSIONS_VIDEO = ['mp4', 'ts']
ALLOWED_EXTENSIONS_CERTIFICATE = ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg']
SKILL_STATUS_CHOICES = [
    ('pending', 'Pending'),
    ('need_interview', 'Need Interview'),
    ('approved', 'Approved'),
    ('rejected', 'Rejected'),
]

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
    ('', 'Select a language'),
    ('English', 'English'),
    ('Spanish', 'Spanish'),
    ('French', 'French'),
    ('German', 'German'),
    ('Italian', 'Italian'),
    ('Portuguese', 'Portuguese'),
    ('Russian', 'Russian'),
    ('Chinese', 'Chinese (Simplified)'),
    ('Japanese', 'Japanese'),
    ('Korean', 'Korean'),
    ('Arabic', 'Arabic'),
    ('Hindi', 'Hindi'),
    ('Bengali', 'Bengali'),
    ('Turkish', 'Turkish'),
    ('Dutch', 'Dutch'),
    ('Polish', 'Polish'),
    ('Ukrainian', 'Ukrainian'),
    ('Vietnamese', 'Vietnamese'),
    ('Thai', 'Thai'),
    ('Persian', 'Persian (Farsi)'),
    ('Swedish', 'Swedish'),
    ('Finnish', 'Finnish'),
    ('Norwegian', 'Norwegian'),
    ('Danish', 'Danish'),
    ('Greek', 'Greek'),
    ('Hebrew', 'Hebrew'),
    ('Indonesian', 'Indonesian'),
    ('Malay', 'Malay'),
    ('Romanian', 'Romanian'),
    ('Czech', 'Czech'),
    ('Hungarian', 'Hungarian'),
]
LANGUAGE_CHOICES_EXTENDED = [
    ('', 'Select your preferred language'),
    # Top 20 Most Spoken Languages
    ('English', 'English'),
    ('Chinese', 'Chinese (Simplified)'),
    ('Hindi', 'Hindi'),
    ('Spanish', 'Spanish'),
    ('French', 'French'),
    ('Arabic', 'Arabic'),
    ('Bengali', 'Bengali'),
    ('Russian', 'Russian'),
    ('Portuguese', 'Portuguese'),
    ('Indonesian', 'Indonesian'),
    ('Urdu', 'Urdu'),
    ('German', 'German'),
    ('Japanese', 'Japanese'),
    ('Swahili', 'Swahili'),
    ('Marathi', 'Marathi'),
    ('Telugu', 'Telugu'),
    ('Turkish', 'Turkish'),
    ('Tamil', 'Tamil'),
    ('Korean', 'Korean'),
    ('Vietnamese', 'Vietnamese'),
    # European Languages
    ('Italian', 'Italian'),
    ('Dutch', 'Dutch'),
    ('Polish', 'Polish'),
    ('Ukrainian', 'Ukrainian'),
    ('Romanian', 'Romanian'),
    ('Greek', 'Greek'),
    ('Czech', 'Czech'),
    ('Swedish', 'Swedish'),
    ('Hungarian', 'Hungarian'),
    ('Danish', 'Danish'),
    ('Finnish', 'Finnish'),
    ('Norwegian', 'Norwegian'),
    # Other Key Languages
    ('Persian', 'Persian (Farsi)'),
    ('Thai', 'Thai'),
    ('Hebrew', 'Hebrew'),
    ('Malay', 'Malay'),
    ('Filipino', 'Filipino'),
    ('Punjabi', 'Punjabi'),
    ('Burmese', 'Burmese'),
    ('Khmer', 'Khmer'),
    ('Lao', 'Lao'),
    ('Nepali', 'Nepali'),
    ('Sinhala', 'Sinhala'),
    ('Kazakh', 'Kazakh'),
    ('Uzbek', 'Uzbek'),
    ('Azerbaijani', 'Azerbaijani'),
    ('Armenian', 'Armenian'),
    ('Georgian', 'Georgian'),
    # African Languages
    ('Yoruba', 'Yoruba'),
    ('Igbo', 'Igbo'),
    ('Hausa', 'Hausa'),
    ('Amharic', 'Amharic'),
    ('Zulu', 'Zulu'),
    ('Xhosa', 'Xhosa'),
    ('Afrikaans', 'Afrikaans'),
]
SCIENCES = [
    # Science
    ('mathematics', 'Mathematics'),
    ('physics', 'Physics'),
    ('chemistry', 'Chemistry'),
]
LANGUAGE_CHOICES_TOP50 = [
    # Tier 1: Global Powerhouses (15)
    ('English', 'English'),
    ('Spanish', 'Spanish'),
    ('French', 'French'),
    ('German', 'German'),
    ('Chinese (Mandarin)', 'Chinese'),
    ('Japanese', 'Japanese'),
    ('Portuguese', 'Portuguese'),
    ('Arabic', 'Arabic'),
    ('Russian', 'Russian'),
    ('Italian', 'Italian'),
    ('Korean', 'Korean'),
    ('Hindi', 'Hindi'),
    ('Turkish', 'Turkish'),
    ('Dutch', 'Dutch'),
    ('Swedish', 'Swedish'),

    # Tier 2: High-Regional-Demand (15)
    ('Polish', 'Polish'),
    ('Indonesian', 'Indonesian'),
    ('Vietnamese', 'Vietnamese'),
    ('Thai', 'Thai'),
    ('Hebrew', 'Hebrew'),
    ('Danish', 'Danish'),
    ('Norwegian', 'Norwegian'),
    ('Finnish', 'Finnish'),
    ('Greek', 'Greek'),
    ('Czech', 'Czech'),
    ('Hungarian', 'Hungarian'),
    ('Romanian', 'Romanian'),
    ('Ukrainian', 'Ukrainian'),
    ('Persian', 'Persian (Farsi)'),
    ('Malay', 'Malay'),

    # Tier 3: Emerging/Niche (20)
    ('Bengali', 'Bengali'),
    ('Punjabi', 'Punjabi'),
    ('Urdu', 'Urdu'),
    ('Filipino', 'Filipino'),
    ('Swahili', 'Swahili'),
    ('Bulgarian', 'Bulgarian'),
    ('Croatian', 'Croatian'),
    ('Slovak', 'Slovak'),
    ('Serbian', 'Serbian'),
    ('Lithuanian', 'Lithuanian'),
    ('Latvian', 'Latvian'),
    ('Estonian', 'Estonian'),
    ('Icelandic', 'Icelandic'),
    ('Catalan', 'Catalan'),
    ('Slovenian', 'Slovenian'),
    ('Afrikaans', 'Afrikaans'),
    ('Georgian', 'Georgian'),
    ('Armenian', 'Armenian'),
    ('Nepali', 'Nepali'),
    ('Khmer', 'Khmer'),
]
# CEFR LEVELS
LEVEL_CHOICES = [
    ('a1', 'A1 (Beginner)'),
    ('a2', 'A2 (Elementary)'),
    ('b1', 'B1 (Intermediate)'),
    ('b2', 'B2 (Upper-Intermediate)'),
    ('c1', 'C1 (Advanced)'),
    ('c2', 'C2 (Proficient)'),
    ('native', 'Native (Fluent as a first language)'),
]
SPECIALIZATION_CHOICES = [
    ('toefl', 'TOEFL'),
    ('ielts', 'IELTS'),
    ('tesol', 'TESOL'),
    ('duolingo', 'DUOLINGO'),
    ('exams', 'Exams'),
    ('speaking', 'Speaking'),
    ('writing', 'Writing'),
    ('reading', 'Reading'),
    ('listening', 'Listening'),
    ('business', 'Business'),
]
TEACHING_SKILLS_1 = [
    # Tech & IT
    ('AI & Deep Learning', 'AI & Deep Learning'),
    ('DevOps', 'DevOps'),
    ('Software Testing', 'Software Testing'),
    ('AR/VR Development', 'AR/VR Development'),
    ('IoT (Internet of Things)', 'IoT (Internet of Things)'),
    ('Embedded Systems', 'Embedded Systems'),
    # Business & Marketing
    ('Social Media Marketing', 'Social Media Marketing'),
    ('SEO (Search Engine Optimization)', 'SEO'),
    ('Copywriting', 'Copywriting'),
    ('E-commerce', 'E-commerce'),
    ('Project Management', 'Project Management'),
    ('Sales Training', 'Sales Training'),
    # Creative Arts
    ('Digital Painting', 'Digital Painting'),
    ('Film Making', 'Film Making'),
    ('Podcasting', 'Podcasting'),
    ('Voice Acting', 'Voice Acting'),
    ('Fashion Design', 'Fashion Design'),
    # Health & Wellness
    ('Nutrition & Dietetics', 'Nutrition & Dietetics'),
    ('Mental Health Counseling', 'Mental Health Counseling'),
    ('Physical Therapy', 'Physical Therapy'),
    # Languages
    ('English as a Second Language (ESL)', 'ESL Teaching'),
    ('TOEFL/IELTS Coaching', 'TOEFL/IELTS Coaching'),
    ('Conversational Language Teaching', 'Conversational Language Teaching'),
    # Other Professional Skills
    ('Resume & Career Coaching', 'Resume & Career Coaching'),
    ('Freelancing & Remote Work', 'Freelancing & Remote Work'),
    ('Investing & Stock Trading', 'Investing & Stock Trading'),
    ('Real Estate', 'Real Estate'),
    ('Interior Design', 'Interior Design'),
]
TEACHING_SKILLS_GENERAL = [
    ('', 'Select your teaching skill'),
    ('Programming', 'Programming'),
    ('Web Development', 'Web Development'),
    ('Data Science', 'Data Science'),
    ('Machine Learning', 'Machine Learning'),
    ('Graphic Design', 'Graphic Design'),
    ('Digital Marketing', 'Digital Marketing'),
    ('Video Editing', 'Video Editing'),
    ('Photography', 'Photography'),
    ('Music Production', 'Music Production'),
    ('Creative Writing', 'Creative Writing'),
    ('Business & Entrepreneurship', 'Business & Entrepreneurship'),
    ('Finance & Accounting', 'Finance & Accounting'),
    ('Personal Development', 'Personal Development'),
    ('Language Teaching', 'Language Teaching'),
    ('Math & Science', 'Math & Science'),
    ('Test Prep (SAT, IELTS, etc.)', 'Test Prep (SAT, IELTS, etc.)'),
    ('Public Speaking', 'Public Speaking'),
    ('Leadership & Management', 'Leadership & Management'),
    ('Health & Fitness', 'Health & Fitness'),
    ('Yoga & Meditation', 'Yoga & Meditation'),
    ('Cooking & Baking', 'Cooking & Baking'),
    ('Art & Illustration', 'Art & Illustration'),
    ('Game Development', 'Game Development'),
    ('Mobile App Development', 'Mobile App Development'),
    ('Cybersecurity', 'Cybersecurity'),
    ('Blockchain & Crypto', 'Blockchain & Crypto'),
    ('UI/UX Design', 'UI/UX Design'),
    ('3D Modeling & Animation', '3D Modeling & Animation'),
    ('Cloud Computing', 'Cloud Computing'),
]
TEACHING_SKILLS_LANG = [
    ('', 'Select your teaching specialty'),
    # Teaching Methods
    ('Conversational Practice', 'Conversational Practice'),
    ('Grammar & Writing', 'Grammar & Writing'),
    ('Pronunciation Coaching', 'Pronunciation Coaching'),
    ('Business Language', 'Business Language'),
    ('Exam Preparation (TOEFL, IELTS, DELE)', 'Exam Preparation'),
    ('Academic Writing', 'Academic Writing'),
    ('Kids & Beginners', 'Kids & Beginners'),
    ('Advanced Fluency', 'Advanced Fluency'),
    # Language-Specific Skills (avoid listing all languages again)
    ('Phonetics Correction', 'Phonetics Correction'),
    ('Slang & Idioms', 'Slang & Idioms'),
    ('Translation Techniques', 'Translation Techniques'),
    ('Accent Reduction', 'Accent Reduction'),
]
CATEGORY_CHOICES = [
    ('science', 'Science'),
    ('language', 'Language'),
    ('instrument', 'Instrument'),
]
SKILL_CHOICES = LANGUAGE_CHOICES_EXTENDED + SCIENCES


class Language(models.Model):
    name = models.CharField(max_length=50, choices=LANGUAGE_CHOICES, unique=True)

    def __str__(self):
        return self.name


class SkillCategory(models.Model):
    name = models.CharField(max_length=50, choices=CATEGORY_CHOICES, unique=True, default='language')

    class Meta:
        ordering = ['name']

    def __str__(self):
        return self.name


class Skill(models.Model):
    category = models.ForeignKey(SkillCategory, on_delete=models.CASCADE, related_name='skills')
    name = models.CharField(max_length=20, choices=SKILL_CHOICES, unique=True)

    class Meta:
        ordering = ['category__name', 'name']

    def __str__(self):
        return f"{self.category.name} – {self.get_name_display()}"


class Level(models.Model):
    name = models.CharField(max_length=10, choices=LEVEL_CHOICES, unique=True)

    class Meta:
        ordering = ['name']

    def __str__(self):
        return self.get_name_display()


class Specialization(models.Model):
    name = models.CharField(max_length=20, choices=SPECIALIZATION_CHOICES, unique=True)

    class Meta:
        ordering = ['name']  # Ensure skill levels are ordered alphabetically

    def __str__(self):
        return self.name


class UserSkill(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=False, blank=False, related_name='user_skill')
    skill = models.ForeignKey(Skill, on_delete=models.CASCADE)
    level = models.ForeignKey(Level, on_delete=models.CASCADE)
    certificate = models.FileField(upload_to='applicants/skills/cert/%Y/%m/%d/', null=True, blank=True, validators=[
        FileExtensionValidator(allowed_extensions=ALLOWED_EXTENSIONS_CERTIFICATE),
        # validate_max_size(2 * 1024 * 1024)  # 2MB limit
    ], )
    video = models.FileField(upload_to='applicants/skills/video/%Y/%m/%d/', null=True, blank=True, validators=[
        FileExtensionValidator(allowed_extensions=ALLOWED_EXTENSIONS_VIDEO),
        # validate_max_size(2 * 1024 * 1024)  # 2MB limit
    ], )
    is_certified = models.BooleanField(default=False)
    is_notified = models.BooleanField(default=False)
    status = models.CharField(max_length=20, choices=SKILL_STATUS_CHOICES, default='pending')
    verified_by = models.ForeignKey(User, on_delete=models.SET_NULL, related_name='verifyed_by',
                                    null=True, blank=True, )
    verified_at = models.DateTimeField(null=True, blank=True)
    needs_interview = models.BooleanField(default=False)

    class Meta:
        unique_together = ('user', 'skill')  # Prevent duplicates

    def __str__(self):
        return f'{self.user.username} - {self.skill.name} [up to {self.level}]'


class UserSpecialization(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=False, blank=False, related_name='specializations')
    specialization = models.ForeignKey(Specialization, on_delete=models.CASCADE)
    certificate = models.FileField(upload_to='specializations/%Y/%m/%d/', null=True, blank=True, validators=[
        FileExtensionValidator(allowed_extensions=['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg']),  # Allowed formats
        # validate_max_size(2 * 1024 * 1024)  # 2MB limit
    ], )
    is_certified = models.BooleanField(default=False)

    class Meta:
        unique_together = ('user', 'specialization')  # Prevent duplicates

    def __str__(self):
        return f'{self.user.username} - {self.specialization.name}'


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
    bio = models.TextField(max_length=500, blank=True)
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
    is_active = models.BooleanField(default=False)  # show on frontend only if active

    def __str__(self):
        return self.user.username

    def save(self, *args, **kwargs):
        user_type_choices = ['student', 'admin', 'tutor', 'staff', 'interviewer']
        if self.user_type not in user_type_choices:
            raise ValueError(f"Invalid user_type: {self.user_type}")

        # Ensure user group is consistent with user_type (get user_type if exist and create if not exist!)
        user_group, created = Group.objects.get_or_create(name=self.user_type)
        self.user.groups.add(user_group)

        if not self.photo:
            self.photo = 'photos/default.png'
        self.last_modified = timezone.now()
        super().save(*args, **kwargs)
