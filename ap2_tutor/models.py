from django.db import models
from django.db.models import Avg

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


class SkillLevel(models.Model):
    name = models.CharField(max_length=2, choices=LEVEL_CHOICES, unique=True)

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
    video_url = models.URLField(blank=True)
    video_intro = models.FileField(upload_to='videos/%Y/%m/%d/', blank=True)  # Allow video uploads
    skills = models.ManyToManyField(Skill, blank=True)
    skill_level = models.ManyToManyField(SkillLevel)
    cost_trial = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    cost_hourly = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    session_count = models.IntegerField(default=0)
    student_count = models.IntegerField(default=0)
    course_count = models.IntegerField(default=0)
    create_date = models.DateTimeField(auto_now_add=True)  # Use auto_now_add
    rating = models.DecimalField(max_digits=3, decimal_places=2, null=True, blank=True)
    # create_date = models.DateTimeField(default=datetime.now) # Use auto_now_add
    last_modified = models.DateTimeField(default=timezone.now, blank=True)

    def __str__(self):
        return f"{self.profile.user.username}"

    def save(self, *args, **kwargs):
        self.last_modified = timezone.now()
        super().save(*args, **kwargs)

    def get_absolute_url(self):
        return reverse('app_accounts:dt_edit_profile', kwargs={'pk': self.pk})

    def average_rating(self):
        """Calculate the average rating for this tutor across all sessions."""
        reviews = self.reviews_received.all()  # Use the related_name to access reviews
        if reviews.exists():
            return reviews.aggregate(Avg('rating'))['rating__avg']
        return None
