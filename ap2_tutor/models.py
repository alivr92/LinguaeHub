from datetime import timedelta

from django.db import models
from django.db.models import Avg
from django.core.validators import MaxValueValidator, MinValueValidator, FileExtensionValidator
from django.contrib.auth.models import User
from .validators import validate_max_size
from ap2_meeting.models import TIMEZONE_CHOICES
from django.urls import reverse
from django.utils import timezone
from app_accounts.models import LANGUAGE_CHOICES
from django.conf import settings

RATING = [(1, '1'), (2, '2'), (3, '3'), (4, '4'), (5, '5')]
NOTIFICATION_TYPE = [
    ('new_appointment', 'New Appointment'),
    ('appointment_cancelled', 'Appointment Cancelled'),
]
ALLOWED_EXTENSIONS_VIDEO = ['mp4', 'ts', 'avi', 'mpeg']
# STATUS_INTERVIEW = [
#         ('pending', 'Pending'),
#         ('invited', 'Invited'),
#         ('registered', 'Registered'),
#         ('completed_profile', 'Completed Profile'),
#         ('added_skills', 'Added Skills'),
#         ('scheduled', 'Scheduled'),
#         ('decision', 'Decision'),
#         ('accepted', 'Accepted'),
#         ('rejected', 'Rejected'),
#     ]
STATUS_WIZARD = [
    ('pending', 'Pending'),
    ('invited', 'Invited'),
    ('registered', 'Registered'),
    ('email_verified', 'Email Verified'),
    ('completed_profile', 'Completed Profile'),
    ('added_skills', 'Added Skills'),
    ('added_method', 'Added Method'),
    ('added_edu', 'Added Education'),
    ('added_availability', 'Added Availability'),
    ('added_pricing', 'Added Pricing'),
    ('review', 'Review'),
    ('decision', 'Decision'),
    ('accepted', 'Accepted'),
    ('rejected', 'Rejected'),
]

TEACHING_CERTIFICATES = [
    ('', 'Select certificate'),
    # 🇬🇧 English Language Proficiency
    ('toefl', 'TOEFL'),
    ('ielts', 'IELTS'),
    ('tesol', 'TESOL'),
    ('tefl', 'TEFL'),
    ('cambridge_a2', 'Cambridge English A2 Key'),
    ('cambridge_b1', 'Cambridge English B1 Preliminary'),
    ('cambridge_b2', 'Cambridge English B2 First'),
    ('cambridge_c1', 'Cambridge English C1 Advanced'),
    ('cambridge_c2', 'Cambridge English C2 Proficiency'),
    ('pte_academic', 'PTE Academic'),
    ('duolingo', 'Duolingo English Test'),
    ('toeic', 'TOEIC'),
    ('oxford', 'Oxford Test of English'),
    ('trinity_gese', 'Trinity College London GESE'),
    ('trinity_ise', 'Trinity College London ISE'),
    ('michigan_met', 'Michigan Tests MET'),
    ('michigan_ecce', 'Michigan Tests ECCE'),
    ('michigan_ecpe', 'Michigan Tests ECPE'),

    # 🇫🇷 French Language Proficiency
    ('delf_dalf', 'DELF / DALF'),
    ('tcf', 'TCF'),
    ('tef', 'TEF'),
    ('dfp', 'DFP'),

    # 🇪🇸 Spanish Language Proficiency
    ('dele', 'DELE'),
    ('siele', 'SIELE'),
    ('celu', 'CELU'),

    # 🇩🇪 German Language Proficiency
    ('goethe', 'Goethe-Zertifikat'),
    ('testdaf', 'TestDaF'),
    ('telc_deutsch', 'telc Deutsch'),
    ('dsh', 'DSH'),
    ('osd', 'ÖSD'),

    # 🇮🇹 Italian Language Proficiency
    ('celi', 'CELI'),
    ('cils', 'CILS'),
    ('plida', 'PLIDA'),
    ('ail', 'AIL'),

    # 🇵🇹 Portuguese Language Proficiency
    ('caple', 'CAPLE'),
    ('celpe_bras', 'CELPE-Bras'),

    # 🇷🇺 Russian Language Proficiency
    ('torfl', 'TORFL'),

    # 🇳🇱 Dutch Language Proficiency
    ('cnavt', 'CNaVT'),
    ('nt2', 'NT2'),

    # 🇸🇪 Swedish Language Proficiency
    ('tisus', 'TISUS'),
    ('sfi', 'SFI tests'),

    # 🇫🇮 Finnish Language Proficiency
    ('yki', 'YKI'),

    # 🇳🇴 Norwegian Language Proficiency
    ('norskprove', 'Norskprøve'),
    ('bergenstest', 'Bergenstest'),

    # 🇩🇰 Danish Language Proficiency
    ('prove_dansk_1_2_3', 'Prøve i Dansk 1, 2, 3'),
    ('studieproven', 'Studieprøven'),

    # 🇮🇸 Icelandic Language Proficiency
    ('islandic_test', 'Íslenskupróf fyrir útlendinga'),

    # 🇵🇱 Polish Language Proficiency
    ('polish_certificate', 'Państwowy Egzamin Certyfikatowy z Języka Polskiego'),

    # 🇬🇷 Greek Language Proficiency
    ('greek_certificate', 'ΚΠγ'),

    # 🇨🇿 Czech Language Proficiency
    ('czech_cce', 'CCE'),
    ('czech_cce_foreigners', 'CCE – Czech for Foreigners'),

    # 🇭🇺 Hungarian Language Proficiency
    ('hungarian_ecl', 'ECL Hungarian'),
    ('hungarian_origo', 'Origó'),

    # 🇷🇴 Romanian Language Proficiency
    ('romanian_ecl', 'ECL Romanian'),
    ('romanian_certificate', 'Romanian Language Proficiency Certificate'),

    # 🇧🇬 Bulgarian Language Proficiency
    ('bulgarian_certificate', 'Bulgarian Language Proficiency Exam'),

    # Other
    ('other', 'Other'),
]
TEACHING_YEARS = [
    ('', 'Select period'),
    (0, 'Less than 1 year'),
    (1, '1-2 years'),
    (2, '3-5 years'),
    (3, '6-10 years'),
    (4, 'More than 10 years')
]


class TeachingCategory(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name


# Detailed Teaching Categories
class TeachingSubCategory(models.Model):
    category = models.ForeignKey(TeachingCategory, on_delete=models.CASCADE, related_name="teaching_sub_categories")
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return f"{self.category.name} → {self.name}"


class Tutor(models.Model):
    profile = models.OneToOneField('app_accounts.UserProfile', on_delete=models.CASCADE, related_name='tutor_profile',
                                   limit_choices_to={'user_type': 'tutor'}, unique=True, )
    video_url = models.URLField(null=True, blank=True) # Store the URL of the video hosted on a third-party platform
    video_intro = models.FileField(
        upload_to='videos/%Y/%m/%d/',
        # upload_to=lambda instance, filename: f"videos/{instance.user.username}_video.{filename.split('.')[-1]}",
        blank=True,
        validators=[
            FileExtensionValidator(allowed_extensions=ALLOWED_EXTENSIONS_VIDEO),  # Allowed formats
            # validate_max_size(2 * 1024 * 1024)  # 2MB limit
        ], )  # Allow video uploads
    cost_trial = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    cost_hourly = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    session_count = models.IntegerField(default=0)
    student_count = models.IntegerField(default=0)
    course_count = models.IntegerField(default=0)
    years_experience = models.PositiveSmallIntegerField(null=True, blank=True, choices=TEACHING_YEARS)
    teaching_tags = models.ManyToManyField(TeachingCategory, blank=True)
    create_date = models.DateTimeField(auto_now_add=True)  # Use auto_now_add
    # rating = models.DecimalField(max_digits=3, decimal_places=2, null=True, blank=True)
    # create_date = models.DateTimeField(default=datetime.now) # Use auto_now_add
    last_modified = models.DateTimeField(default=timezone.now, blank=True)
    discount_deadline = models.DateTimeField(blank=True, null=True)
    discount = models.IntegerField(default=0,
                                   validators=[
                                       MinValueValidator(0),  # Minimum discount is 0%
                                       MaxValueValidator(100)  # Maximum discount is 100%
                                   ],
                                   help_text="Enter a discount percentage between 0 and 100."
                                   )
    status = models.CharField(max_length=20, choices=STATUS_WIZARD, default='pending')
    reviewer_comment = models.TextField(max_length=500, blank=True)

    lifetime_hours = models.PositiveIntegerField(default=0)  # the whole time which tutor teaches!
    commission_rate = models.DecimalField(max_digits=5, decimal_places=2, default=100.00,
                                          validators=[MinValueValidator(0), MaxValueValidator(100)])

    def __str__(self):
        return f"{self.profile.user.username}"

    def save(self, *args, **kwargs):
        # Ensure profile is a tutor
        if self.profile.user_type != 'tutor':
            raise ValueError("Tutor profile must have user_type='tutor'")

        # Validate discount
        if self.discount and not self.discount_deadline:
            self.discount_deadline = timezone.now() + timedelta(days=30)  # Default 30-day discount

        self.last_modified = timezone.now()
        super().save(*args, **kwargs)

    # def get_absolute_url(self):
    #     return reverse('app_accounts:dp_edit', kwargs={'pk': self.pk})

    def average_rating(self):
        """Calculate the average rating for this tutor across all sessions."""
        reviews = self.reviews_received.all()  # Use the related_name to access reviews
        if reviews.exists():
            return reviews.aggregate(Avg('rating'))['rating__avg']
        return None

    def is_discount_active(self):
        """Check if the discount is still valid."""
        if self.discount_deadline:
            return timezone.now() <= self.discount_deadline  # Compare current time with deadline
        return True  # No deadline means the discount is always active

    def get_commission_rate(self):
        """Calculate commission rate based on lifetime hours"""
        if self.lifetime_hours >= 200:
            return 0.15  # 15%
        elif self.lifetime_hours >= 100:
            return 0.19  # 19%
        elif self.lifetime_hours >= 50:
            return 0.22  # 22%
        elif self.lifetime_hours >= 20:
            return 0.25  # 25%
        else:
            return 0.30  # 30%

    def get_performance_bonus(self):
        """Calculate performance bonus based on rating and completion rate"""
        bonus = 0
        if self.profile.rating and self.profile.rating >= 4.8:
            bonus += 0.02  # 2% bonus for high ratings
        if self.completion_rate >= 95:
            bonus += 0.01  # 1% bonus for high completion rate
        return bonus

    def get_final_commission_rate(self):
        """Calculate final commission rate with performance adjustments"""
        base_rate = self.get_commission_rate()
        performance_bonus = self.get_performance_bonus()
        return max(0.10, base_rate - performance_bonus)  # Never more than 10% minimum commission


class ProviderApplication(models.Model):
    user = models.OneToOneField(User, on_delete=models.SET_NULL, null=True, blank=True,
                                related_name='provider_application')
    photo = models.ImageField(upload_to='applicants/photos/%Y/%m/%d/', blank=True, null=True,
                              default='photos/default.png', validators=[
            FileExtensionValidator(allowed_extensions=['jpg', 'png', 'svg']),  # Allowed formats
            # validate_max_size(2 * 1024 * 1024)  # 2MB limit
        ], )
    resume = models.FileField(upload_to='applicants/resume/%Y/%m/%d/', null=True, blank=True, validators=[
        FileExtensionValidator(allowed_extensions=['pdf', 'doc', 'docx']),  # Allowed formats
        # validate_max_size(2 * 1024 * 1024)  # 2MB limit
    ], )
    first_name = models.CharField(max_length=50, blank=False, null=False, default='NA')
    last_name = models.CharField(max_length=50, blank=False, null=False, default='NA')
    email = models.EmailField(blank=False, null=False, unique=False)
    phone = models.CharField(max_length=50, blank=False, null=False)
    lang_native = models.CharField(max_length=100, choices=LANGUAGE_CHOICES, default='Unknown')
    skills = models.ManyToManyField('app_accounts.Skill', blank=False)
    bio = models.TextField(max_length=500, blank=False)
    video_url = models.URLField(null=True, blank=True)
    timezone = models.CharField(max_length=50, choices=TIMEZONE_CHOICES, default="UTC")
    location_ip = models.CharField(max_length=50, blank=True, null=True, )
    date_submitted = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=20, choices=STATUS_WIZARD, default='pending')
    reviewer_comment = models.TextField(max_length=500, blank=True)

    invitation_token = models.CharField(max_length=100, blank=True, null=True, unique=True)
    token_expiry = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.first_name} {self.last_name} - {self.status}"

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['email'],
                name='unique_applicant_email'
            )
        ]


# Provider Notification
class PNotification(models.Model):
    provider = models.ForeignKey(Tutor, on_delete=models.SET_NULL, null=True, blank=True)
    appointment = models.ForeignKey('ap2_meeting.Session', on_delete=models.CASCADE, null=True, blank=True,
                                    related_name='tutor_appointment_notification')
    type = models.CharField(max_length=50, choices=NOTIFICATION_TYPE)
    seen = models.BooleanField(default=False)
    date = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name_plural = 'Notification'

    def __str__(self):
        return f'Tutor: {self.provider.profile.user.first_name} {self.provider.profile.user.last_name} Notification'


# ---------------------------------------------------------------------


# class Education(models.Model):
#     """Tutor's formal education entries"""
#     user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='educations')
#     degree = models.ForeignKey(DegreeLevel, on_delete=models.PROTECT)
#     field_of_study = models.CharField(max_length=100)
#     institution = models.CharField(max_length=150)
#     start_year = models.PositiveIntegerField(
#         validators=[MinValueValidator(1950), MaxValueValidator(2100)],
#         null=True,
#         blank=True
#     )
#     end_year = models.PositiveIntegerField(
#         validators=[MinValueValidator(1950), MaxValueValidator(2100)],
#         null=True,
#         blank=True
#     )
#     description = models.TextField(blank=True)
#     diploma = models.FileField(
#         upload_to='educations/diplomas/',
#         null=True,
#         blank=True,
#         help_text="Upload diploma or certificate"
#     )
#     is_verified = models.BooleanField(default=False)
#     created_at = models.DateTimeField(auto_now_add=True)
#     updated_at = models.DateTimeField(auto_now=True)
#
#     class Meta:
#         ordering = ['-end_year']
#         verbose_name_plural = 'Education Entries'
#
#     def __str__(self):
#         return f"{self.degree} in {self.field_of_study} at {self.institution}"


class TeachingCertificate(models.Model):
    """Tutor's teaching certifications (TEFL, TESOL, etc.)"""
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='certificates')
    name = models.CharField(max_length=100, choices=TEACHING_CERTIFICATES, blank=False)
    issuing_organization = models.CharField(max_length=150)
    completion_date = models.PositiveIntegerField(
        validators=[MinValueValidator(1950), MaxValueValidator(timezone.now().year)],
        null=True,
        blank=True
    )
    document = models.FileField(
        upload_to='applicants/certificates/%Y/%m/%d/',
        null=True,
        blank=True
    )
    is_certified = models.BooleanField(default=False)
    verified_by = models.ForeignKey(User, on_delete=models.SET_NULL, related_name='cert_verifyed_by',
                                    null=True, blank=True, )
    verified_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-completion_date']

    def __str__(self):
        return f"{self.name} from {self.issuing_organization}"
