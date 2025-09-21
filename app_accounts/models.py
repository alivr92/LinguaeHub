from django.db import models
from django.contrib.auth.models import User, Group
from django.utils import timezone
from django.core.validators import MaxValueValidator, MinValueValidator, FileExtensionValidator
from django.core.exceptions import ValidationError
from datetime import timedelta
import random
from utils.email import send_dual_email
from django.conf import settings
from django.urls import reverse
# --------------- GPT -------------------
from django.db.models import F, FloatField, Value
from django.db.models.functions import Radians, Sin, Cos, Sqrt, ATan2, Cast, Power
from math import radians

# --------------- Deepseek -------------------
# from django.contrib.gis.db.models.functions import Distance
# from django.contrib.gis.geos import Point
# from django.contrib.gis.measure import D

# from django.contrib.auth import get_user_model
# User = get_user_model()

USER_TYPES = [('student', 'Student'), ('tutor', 'Tutor'), ('admin', 'Admin'), ('staff', 'Staff'),
              ('interviewer', 'Interviewer')]
GENDER_CHOICES = [('female', 'Female'), ('male', 'Male'),
                  ('trans', 'Transgendered'),
                  ('ambiguous', 'Ambiguous'),
                  ('neuter', 'Neuter'),
                  ]
ALLOWED_EXTENSIONS_VIDEO = ['mp4', 'ts']
ALLOWED_EXTENSIONS_CERTIFICATE = ['pdf', 'doc', 'docx', 'png', 'jpg', 'jpeg']
ALLOWED_EXTENSIONS_IMAGE = ['png', 'jpg', 'jpeg']
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
LEVEL_PERCENTAGES = {
    'a1': 15,
    'a2': 25,
    'b1': 40,
    'b2': 60,
    'c1': 80,
    'c2': 95,
    'native': 100,
}

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
DEGREE_LEVELS = [
    ('', 'Select degree'),
    ('high_school', 'High School Diploma'),
    ('associate', 'Associate Degree'),
    ('bachelor', "Bachelor's Degree"),
    ('master', "Master's Degree"),
    ('phd', 'PhD/Doctorate'),
    ('professional', 'Professional Degree'),
    ('other', 'Other'),
]
MEETING_METHOD_CHOICES = [
    ('online', 'Online Only'),
    ('hybrid', 'Online + In-Person'),
    ('in_person', 'In-Person Only'),
]
MEETING_LOCATION_CHOICES = [
    ('any', 'Any suitable location in my area'),
    ('my_location', 'Only at my specified location'),
    ('formal_institution', 'Educational institutions (schools, universities)'),
    ('public', 'Public spaces (cafés, libraries, co-working spaces)'),
]

IN_PERSON_AIM_CHOICES = [
    ('english_for_business', 'English for business'),
    ('daily_conversation', 'Daily Conversation'),
    ('free_discussion', 'Free Discussion'),
    ('formal_exams', 'Educational Exams (schools, universities)'),
    ('formal_tests', 'Formal Tests (TOEFL, IELTS, ...)'),
    ('networking', 'Networking (Find new language partners)'),
]


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
        # return f"{self.category.name} – {self.get_name_display()}"
        return f"{self.get_name_display()}"


class Level(models.Model):
    name = models.CharField(max_length=10, choices=LEVEL_CHOICES, unique=True)

    class Meta:
        ordering = ['name']

    def __str__(self):
        return self.get_name_display()


class DegreeLevel(models.Model):
    """Predefined degree levels (BA, BSc, MA, MSc, PhD, etc.)"""
    name = models.CharField(max_length=50, choices=DEGREE_LEVELS)
    order = models.PositiveSmallIntegerField(help_text="For sorting purposes")

    class Meta:
        ordering = ['order']

    def __str__(self):
        return self.get_name_display()


class Specialization(models.Model):
    name = models.CharField(max_length=20, choices=SPECIALIZATION_CHOICES, unique=True)

    class Meta:
        ordering = ['name']  # Ensure skill levels are ordered alphabetically

    def __str__(self):
        return self.name


class UserSkill(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=False, blank=False, related_name='skills')
    skill = models.ForeignKey(Skill, on_delete=models.CASCADE)
    level = models.ForeignKey(Level, on_delete=models.CASCADE)
    certificate = models.FileField(upload_to='applicants/skills/cert/%Y/%m/%d/', null=True, blank=True, validators=[
        FileExtensionValidator(allowed_extensions=ALLOWED_EXTENSIONS_CERTIFICATE),
        # validate_max_size(2 * 1024 * 1024)  # 2MB limit
    ], )
    video = models.FileField(upload_to='applicants/skills/video/%Y/%m/%d/', null=True, blank=False, validators=[
        FileExtensionValidator(allowed_extensions=ALLOWED_EXTENSIONS_VIDEO),
        # validate_max_size(2 * 1024 * 1024)  # 2MB limit
    ], )
    thumbnail = models.FileField(upload_to='applicants/skills/thumbnail/%Y/%m/%d/', null=True, blank=True, validators=[
        FileExtensionValidator(allowed_extensions=ALLOWED_EXTENSIONS_IMAGE),
        # validate_max_size(2 * 1024 * 1024)  # 2MB limit
    ], )
    is_certified = models.BooleanField(default=False)
    is_notified = models.BooleanField(default=False)
    status = models.CharField(max_length=20, choices=SKILL_STATUS_CHOICES, default='pending')
    verified_by = models.ForeignKey(User, on_delete=models.SET_NULL, related_name='skill_verifyed_by',
                                    null=True, blank=True, )
    verified_at = models.DateTimeField(null=True, blank=True)
    needs_interview = models.BooleanField(default=False)

    class Meta:
        unique_together = ('user', 'skill')  # Prevent duplicates

    def __str__(self):
        return f'{self.user.username} - {self.skill.name} [up to {self.level}]'

    def progress_percent(self):
        mapping = {
            'a1': 10, 'a2': 25, 'b1': 40, 'b2': 60, 'c1': 80, 'c2': 95, 'native': 100
        }
        return mapping.get(self.level.name, 0)

    def progress_color(self):
        colors = {
            'a1': '#FF6347',  # Tomato Red
            'a2': '#FFA500',  # Orange
            'b1': '#FFD700',  # Gold
            'b2': '#00CED1',  # Turquoise
            'c1': '#1E90FF',  # Dodger Blue
            'c2': '#8A2BE2',  # Electric Violet
            'native': '#228B22',  # Forest Green
        }
        return colors.get(self.level.name, '#ccc')  # fallback


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


class UserEducation(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='educations')
    degree = models.ForeignKey(DegreeLevel, on_delete=models.PROTECT)
    field_of_study = models.CharField(max_length=100)  # e.g., Linguistics, English
    institution = models.CharField(max_length=200)
    start_year = models.PositiveIntegerField(
        validators=[MinValueValidator(1900), MaxValueValidator(timezone.now().year)],
        null=True,
        blank=True
    )
    # graduation_year
    end_year = models.PositiveIntegerField(
        validators=[MinValueValidator(1900), MaxValueValidator(timezone.now().year)])
    document = models.FileField(
        upload_to='applicants/education/%Y/%m/%d/',
        null=True,
        blank=True,
        validators=[FileExtensionValidator(allowed_extensions=ALLOWED_EXTENSIONS_CERTIFICATE)],
    )
    description = models.TextField(blank=True, max_length=500)
    is_certified = models.BooleanField(default=False)
    is_notified = models.BooleanField(default=False)
    status = models.CharField(max_length=20, choices=SKILL_STATUS_CHOICES, default='pending')
    verified_by = models.ForeignKey(User, on_delete=models.SET_NULL, related_name='edu_verifyed_by',
                                    null=True, blank=True, )
    verified_at = models.DateTimeField(null=True, blank=True)
    needs_interview = models.BooleanField(default=False)

    class Meta:
        ordering = ['-end_year']
        verbose_name = 'Education Record'
        verbose_name_plural = 'Education Records'

    def __str__(self):
        return f"{self.user.username} – {self.degree} in {self.field_of_study} ({self.end_year})"


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    gender = models.CharField(max_length=20, choices=GENDER_CHOICES, blank=True, null=True, default='male')
    photo = models.ImageField(upload_to='profiles/photos/%Y/%m/%d/', blank=True, null=True,
                              default='photos/default.png',
                              validators=[FileExtensionValidator(allowed_extensions=['jpg', 'png', 'svg']),
                                          # validate_max_size(2 * 1024 * 1024)  # 2MB limit
                                          ], )
    user_type = models.CharField(max_length=20, choices=USER_TYPES, default='student',
                                 blank=False)  # Important for role distinction
    title = models.CharField(max_length=100, blank=True)
    lang_native = models.CharField(max_length=100, choices=LANGUAGE_CHOICES, default='Unknown')
    lang_speak = models.ManyToManyField(Language, blank=True)
    bio = models.TextField(max_length=500, blank=True)
    rating = models.FloatField(default=0.0)
    reviews_count = models.IntegerField(default=0)
    # Phone
    phone_country_code = models.CharField(max_length=5, blank=True, null=True)  # e.g. "+1"
    phone_number = models.CharField(max_length=20, blank=True, null=True)  # Raw digits only
    phone_verified = models.BooleanField(default=False)
    phone_verification_sent_at = models.DateTimeField(null=True, blank=True)

    # In-Person Meeting Fields
    meeting_method = models.CharField(max_length=10, choices=MEETING_METHOD_CHOICES, default='online',
                                      verbose_name="Meeting Method")
    country = models.CharField(max_length=100, choices=COUNTRY_CHOICES, default='Unknown')
    city = models.CharField(max_length=100, blank=True, default='', verbose_name="city area",
                            help_text="Primary city area for in-person classes")
    latitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    longitude = models.DecimalField(max_digits=9, decimal_places=6, null=True, blank=True)
    meeting_radius = models.PositiveSmallIntegerField(blank=True, null=True, default=10,
                                                      validators=[MinValueValidator(0), MaxValueValidator(100)],
                                                      verbose_name="Maximum travel distance (km)",
                                                      help_text="How far the user will travel for sessions (0-100 km)"
                                                      )
    meeting_location = models.CharField(max_length=50, choices=MEETING_LOCATION_CHOICES, blank=True, null=True,
                                        default='any')
    inp_aim = models.CharField(max_length=50, choices=IN_PERSON_AIM_CHOICES, blank=True, null=True, )
    inp_start = models.DateField(blank=True, null=True)

    resume = models.FileField(upload_to='profiles/resume/%Y/%m/%d/', null=True, blank=True, validators=[
        FileExtensionValidator(allowed_extensions=['pdf', 'doc', 'docx']),  # Allowed formats
        # validate_max_size(2 * 1024 * 1024)  # 2MB limit
    ], )

    availability = models.BooleanField(blank=True, default=True)
    is_vip = models.BooleanField(blank=False, default=False)
    is_active = models.BooleanField(default=False)  # show on frontend only if active
    is_email_verified = models.BooleanField(default=False)

    terms_agreed = models.BooleanField(default=False)
    terms_agreed_date = models.DateTimeField(null=True, blank=True)
    email_consent = models.BooleanField(default=False)
    email_consent_date = models.DateTimeField(null=True, blank=True)

    email_verification_token = models.CharField(max_length=100, blank=True, null=True, unique=True)
    email_token_expiry = models.DateTimeField(blank=True, null=True)

    activation_token = models.CharField(max_length=100, blank=True, null=True, unique=True)
    token_expiry = models.DateTimeField(blank=True, null=True)

    password_reset_token = models.CharField(max_length=100, blank=True, null=True, unique=True)
    pss_token_expiry = models.DateTimeField(blank=True, null=True)

    create_date = models.DateTimeField(auto_now_add=True)  # Use auto_now_add
    last_modified = models.DateTimeField(default=timezone.now, blank=True)

    class Meta:
        indexes = [
            models.Index(fields=['phone_country_code', 'phone_number']),
            models.Index(fields=['user_type']),
            models.Index(fields=['meeting_method']),
            models.Index(fields=['latitude', 'longitude']),  # Important for geospatial queries
            models.Index(fields=['city', 'country']),
        ]

    def __str__(self):
        return self.user.username

    def clean(self):
        super().clean()
        # Only validate in-person fields if method requires them
        if self.meeting_method in ['hybrid', 'in_person']:
            if not self.city:
                raise ValidationError({'city': 'City is required for in-person teaching'})
            if self.meeting_radius is None:
                raise ValidationError({'meeting_radius': 'Please specify maximum travel distance'})
            if not self.latitude or not self.longitude:
                raise ValidationError('Please set your location on the map')

    def save(self, *args, **kwargs):
        # Validate user_type
        if self.user_type not in dict(USER_TYPES):
            raise ValueError(f"Invalid user_type: {self.user_type}")

        # Set default photo if none provided
        if not self.photo:
            self.photo = 'photos/default.png'

        # Normalize phone number
        if self.phone_number:
            self.phone_number = ''.join(c for c in self.phone_number if c.isdigit())

        # Update timestamps
        if not self.pk:  # New instance
            self.create_date = timezone.now()
        self.last_modified = timezone.now()

        # Clear location data if online-only (not offering in-person)
        if self.meeting_method == 'online':
            self.city = ''
            self.latitude = None
            self.longitude = None
            self.meeting_radius = None
            self.meeting_location = None

        super().save(*args, **kwargs)

        # Sync user group
        self._sync_user_group()

    def _sync_user_group(self):
        """Ensure user is in the correct group matching their user_type"""
        group, _ = Group.objects.get_or_create(name=self.user_type)
        self.user.groups.add(group)
        # Remove from other role groups
        self.user.groups.exclude(name=self.user_type).delete()

    @property
    def full_phone(self):
        """Get formatted phone number with country code"""
        if self.phone_country_code and self.phone_number:
            return f"{self.phone_country_code}-{self.phone_number}"
        return None

    def generate_verification_token(self):
        """Generate and save a new verification token"""
        self.phone_verification_token = str(random.randint(100000, 999999))
        self.phone_verification_sent_at = timezone.now()
        self.save()
        return self.phone_verification_token

    def verify_phone(self, token):
        """Verify phone with the provided token"""
        if (self.phone_verification_token == token and
                self.phone_verification_sent_at and
                timezone.now() < self.phone_verification_sent_at + timedelta(minutes=15)):
            self.phone_verified = True
            self.phone_verification_token = None
            self.save()
            return True
        return False

    def can_resend_verification(self):
        """Check if verification can be resent (not too frequent)"""
        if not self.phone_verification_sent_at:
            return True
        return timezone.now() > self.phone_verification_sent_at + timedelta(minutes=1)

    @property
    def requires_location(self):
        """Helper property to check if location fields are needed"""
        return self.meeting_method in ['hybrid', 'in_person']

    def get_meeting_method_display(self):
        """Formatted meeting method information"""
        methods = {
            'online': 'Online only',
            'hybrid': 'Hybrid',
            'in_person': 'In-Person only'
        }
        return methods.get(self.meeting_method, 'Not specified')

    def get_nearby_users(self, user_type):
        """Generic helper: Find users of a given type within meeting radius."""
        if not (self.latitude and self.longitude and self.meeting_radius):
            return UserProfile.objects.none()

        lat_r = float(self.latitude) * (3.141592653589793 / 180)  # radians in Python for constants
        lng_r = float(self.longitude) * (3.141592653589793 / 180)
        radius = float(self.meeting_radius)

        profiles = UserProfile.objects.filter(
            user_type=user_type,
            meeting_method__in=['hybrid', 'in_person'],
            latitude__isnull=False,
            longitude__isnull=False
        ).annotate(
            lat_float=Cast('latitude', FloatField()),
            lng_float=Cast('longitude', FloatField())
        ).annotate(
            distance=Value(12742.0, output_field=FloatField()) * ATan2(
                Sqrt(
                    Power(
                        Sin(
                            (Radians(F('lat_float')) - Value(lat_r, output_field=FloatField())) /
                            Value(2.0, output_field=FloatField())
                        ),
                        Value(2.0, output_field=FloatField())
                    ) +
                    Cos(Value(lat_r, output_field=FloatField())) *
                    Cos(Radians(F('lat_float'))) *
                    Power(
                        Sin(
                            (Radians(F('lng_float')) - Value(lng_r, output_field=FloatField())) /
                            Value(2.0, output_field=FloatField())
                        ),
                        Value(2.0, output_field=FloatField())
                    )
                ),
                Sqrt(
                    Value(1.0, output_field=FloatField()) - (
                            Power(
                                Sin(
                                    (Radians(F('lat_float')) - Value(lat_r, output_field=FloatField())) /
                                    Value(2.0, output_field=FloatField())
                                ),
                                Value(2.0, output_field=FloatField())
                            ) +
                            Cos(Value(lat_r, output_field=FloatField())) *
                            Cos(Radians(F('lat_float'))) *
                            Power(
                                Sin(
                                    (Radians(F('lng_float')) - Value(lng_r, output_field=FloatField())) /
                                    Value(2.0, output_field=FloatField())
                                ),
                                Value(2.0, output_field=FloatField())
                            )
                    )
                )
            )
        ).filter(distance__lte=radius).exclude(id=self.id).order_by('distance')

        return profiles

    def nearby_students(self):
        """Get nearby students for tutors"""
        if self.user_type != 'tutor':
            return UserProfile.objects.none()  # to ensure they return querysets
        return self.get_nearby_users(user_type='student')

    def nearby_tutors(self):
        """Get nearby tutors for students"""
        if self.user_type != 'student':
            return UserProfile.objects.none()  # to ensure they return querysets
        return self.get_nearby_users(user_type='tutor')

    def notify_new_message(self, message):
        """
        Send notifications about a new message
        """
        if self.user.message_settings.email_notifications:
            self._send_email_notification(message)

        if self.user.message_settings.push_notifications:
            self._send_push_notification(message)

    def _send_email_notification(self, message):

        context = {
            'sender': message.sender,
            'recipient': self.user,
            'message': message,
            'site_name': settings.SITE_NAME,
            'site_logo_url': settings.SITE_LOGO_URL,
            'message_url': settings.SITE_DOMAIN + reverse('messenger:thread_detail', args=[message.thread.id]),
            # 'settings_url': settings.SITE_DOMAIN + reverse('account:settings'),
            'privacy_url': settings.SITE_DOMAIN + reverse('app_pages:privacy_policy'),
            'terms_url': settings.SITE_DOMAIN + reverse('app_pages:terms'),
            'tracking_pixel_url': f"{settings.SITE_DOMAIN}/track/email/{message.id}/",
        }

        send_dual_email(
            subject=f"New message from {message.sender.username}",
            template_name='messenger/emails/new_message',
            context=context,
            to_email=self.user.email
        )

    def _send_push_notification(self, message):
        # Implement with your push notification service (Firebase, APNs, etc.)
        pass


class UserSocial(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='socials')
    url_facebook = models.URLField(max_length=150, blank=True)
    url_insta = models.URLField(max_length=150, blank=True)
    url_twitter = models.URLField(max_length=150, blank=True)
    url_linkedin = models.URLField(max_length=150, blank=True)
    url_youtube = models.URLField(max_length=150, blank=True)

    def __str__(self):
        return self.user.username


class UserConsentLog(models.Model):
    CONSENT_TYPE_CHOICES = [
        ('terms', 'Terms of Service'),
        ('privacy', 'Privacy Policy'),
        ('nda', 'Instructor NDA'),
    ]

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='consent_logs')
    consent_type = models.CharField(max_length=20, choices=CONSENT_TYPE_CHOICES)
    consent_version = models.CharField(max_length=20, help_text="Version ID of legal document (e.g. v1.2)")
    agreed = models.BooleanField(default=False)
    timestamp = models.DateTimeField(auto_now_add=True)

    ip_address = models.GenericIPAddressField()
    user_agent = models.TextField(blank=True, null=True)
    location_city = models.CharField(max_length=100, blank=True, null=True)
    location_country = models.CharField(max_length=100, blank=True, null=True)

    class Meta:
        ordering = ['-timestamp']
        verbose_name = "User Consent Log"
        verbose_name_plural = "User Consent Logs"

    def __str__(self):
        return f"{self.user} | {self.consent_type} | {self.consent_version} | {self.timestamp}"


class LoginIPLog(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='loginIPLogs')
    ip_address = models.GenericIPAddressField()
    user_agent = models.TextField(blank=True, null=True)
    login_time = models.DateTimeField(auto_now_add=True)

    location_city = models.CharField(max_length=100, blank=True, null=True)
    location_country = models.CharField(max_length=100, blank=True, null=True)

    is_new_ip = models.BooleanField(default=False)
    is_flagged = models.BooleanField(default=False, help_text="Manually or automatically flagged as suspicious")

    class Meta:
        ordering = ['-login_time']
        verbose_name = "Login IP Log"
        verbose_name_plural = "Login IP Logs"

    def __str__(self):
        return f"{self.user} | {self.ip_address} | {self.login_time}"


class SecurityEvent(models.Model):
    EVENT_TYPES = (
        ('login_failed', 'Failed Login'),
        ('csrf', 'CSRF Attempt'),
        ('xss', 'XSS Attempt'),
        ('ratelimit', 'Rate Limit Triggered'),
        ('account_lock', 'Account Lockout'),
    )

    event_type = models.CharField(max_length=20, choices=EVENT_TYPES)
    user = models.ForeignKey(
        User,
        null=True,
        blank=True,
        on_delete=models.SET_NULL,
        related_name='security_events'
    )
    attempted_username = models.CharField(max_length=255, blank=True, db_index=True)
    ip_address = models.GenericIPAddressField(db_index=True)
    user_agent = models.TextField(blank=True)
    timestamp = models.DateTimeField(auto_now_add=True, db_index=True)
    path = models.CharField(max_length=255)
    reason = models.CharField(max_length=100)
    details = models.JSONField(default=dict, blank=True)

    class Meta:
        indexes = [
            models.Index(fields=['event_type', 'timestamp']),
            models.Index(fields=['ip_address', 'timestamp']),
        ]
        ordering = ['-timestamp']
        verbose_name = "Security Event"
        verbose_name_plural = "Security Events"

    def __str__(self):
        return f"{self.get_event_type_display()} - {self.ip_address} ({self.timestamp})"

    def save(self, *args, **kwargs):
        # Auto-fill attempted_username if user exists but field is empty
        if self.user and not self.attempted_username:
            self.attempted_username = self.user.username
        super().save(*args, **kwargs)

# Then filter by event_type when needed:
# failed_logins = SecurityEvent.objects.filter(event_type='login_failed')
