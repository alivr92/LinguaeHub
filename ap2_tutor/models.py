from django.db import models
from django.db.models import Avg
from django.core.validators import MaxValueValidator, MinValueValidator, FileExtensionValidator
from django.contrib.auth.models import User
from .validators import validate_max_size
from ap2_meeting.models import TIMEZONE_CHOICES
from django.urls import reverse
from django.utils import timezone
from app_accounts.models import LANGUAGE_CHOICES

RATING = [(1, '1'), (2, '2'), (3, '3'), (4, '4'), (5, '5')]
NOTIFICATION_TYPE = [
    ('new_appointment', 'New Appointment'),
    ('appointment_cancelled', 'Appointment Cancelled'),
]
ALLOWED_EXTENSIONS_VIDEO = ['mp4', 'ts', 'avi', 'mpeg']


class Tutor(models.Model):
    profile = models.OneToOneField('app_accounts.UserProfile', on_delete=models.CASCADE, related_name='tutor_profile',
                                   limit_choices_to={'user_type': 'tutor'}, unique=True, )
    video_url = models.URLField(blank=True)  # Store the URL of the video hosted on a third-party platform
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
    create_date = models.DateTimeField(auto_now_add=True)  # Use auto_now_add
    # rating = models.DecimalField(max_digits=3, decimal_places=2, null=True, blank=True)
    # create_date = models.DateTimeField(default=datetime.now) # Use auto_now_add
    last_modified = models.DateTimeField(default=timezone.now, blank=True)
    discount_deadline = models.DateTimeField(blank=True, null=True)
    discount = models.IntegerField(
        default=0,
        validators=[
            MinValueValidator(0),  # Minimum discount is 0%
            MaxValueValidator(100)  # Maximum discount is 100%
        ],
        help_text="Enter a discount percentage between 0 and 100."
    )

    def __str__(self):
        return f"{self.profile.user.username}"

    def save(self, *args, **kwargs):
        self.last_modified = timezone.now()
        super().save(*args, **kwargs)

    # def get_absolute_url(self):
    #     return reverse('app_accounts:dt_edit', kwargs={'pk': self.pk})

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


class ProviderApplication(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('invited', 'Invited'),
        ('registered', 'Registered'),
        ('completed_profile', 'Completed Profile'),
        ('added_skills', 'Added Skills'),
        ('scheduled', 'Scheduled'),
        ('decision', 'Decision'),
        ('accepted', 'Accepted'),
        ('rejected', 'Rejected'),
    ]
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
    reviewer_comment = models.TextField(max_length=500, blank=True)
    video_url = models.URLField(null=True, blank=True)
    timezone = models.CharField(max_length=50, choices=TIMEZONE_CHOICES, default="UTC")
    location_ip = models.CharField(max_length=50, blank=True, null=True, )
    date_submitted = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    invitation_token = models.CharField(max_length=100, blank=True, null=True, unique=True)
    token_expiry = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.first_name} {self.last_name} - {self.status}"

    # class Meta:
    #     constraints = [
    #         models.UniqueConstraint(
    #             fields=['email'],
    #             name='unique_applicant_email'
    #         )
    #     ]
