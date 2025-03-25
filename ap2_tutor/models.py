from django.db import models
from django.db.models import Avg
from django.core.validators import MaxValueValidator, MinValueValidator
from django.urls import reverse
from django.utils import timezone

# from ap2_meeting.models import Review

LEVEL_CHOICES = [
    ('A1', 'A1'),
    ('A2', 'A2'),
    ('B1', 'B1'),
    ('B2', 'B2'),
    ('C1', 'C1'),
    ('C2', 'C2'),
]
SKILL_CHOICES = [
    ('Persian', 'Teaching Persian'),
    ('English', 'Teaching English'),
    ('German', 'Teaching German'),
    ('Spanish', 'Teaching Spanish'),
    ('French', 'Teaching French'),
    ('Chinese', 'Teaching Chinese'),
    ('Italian', 'Teaching Italian'),
    ('Turkish', 'Teaching Turkish'),
    ('Swedish', 'Teaching Swedish'),
    ('Korean', 'Teaching Korean'),
    ('Hindi', 'Teaching Hindi'),
    ('Russian', 'Teaching Russian'),
    ('Japanese', 'Teaching Japanese'),
    ('Ukrainian', 'Teaching Ukrainian'),
    ('Arabic', 'Teaching Arabic'),
    ('Math', 'Teaching Math'),
    ('Physics', 'Teaching Physics'),
    ('Piano', 'Teaching Piano'),
]
RATING = [(1, '1'), (2, '2'), (3, '3'), (4, '4'), (5, '5')]
NOTIFICATION_TYPE = [
    ('new_appointment', 'New Appointment'),
    ('appointment_cancelled', 'Appointment Cancelled'),
]


class SkillLevel(models.Model):
    name = models.CharField(max_length=2, choices=LEVEL_CHOICES, unique=True)

    class Meta:
        ordering = ['name']  # Ensure skill levels are ordered alphabetically

    def __str__(self):
        return self.name


class Skill(models.Model):
    name = models.CharField(max_length=20, choices=SKILL_CHOICES, unique=True)

    def __str__(self):
        return self.name


class Tutor(models.Model):
    profile = models.OneToOneField('app_accounts.UserProfile', on_delete=models.CASCADE, related_name='tutor_profile',
                                   limit_choices_to={'user_type': 'tutor'}, unique=True,
                                   )
    video_url = models.URLField(blank=True)  # Store the URL of the video hosted on a third-party platform
    # video_intro = models.FileField(upload_to='videos/%Y/%m/%d/', blank=True)  # Allow video uploads
    skills = models.ManyToManyField(Skill, blank=True)
    skill_level = models.ManyToManyField(SkillLevel)
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

