from django.db import models
from django.urls import reverse
from datetime import datetime
from django.utils import timezone
from app_accounts.models import UserProfile
# Create your models here.

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
    ('Russian', 'Teaching Russian'),
    ('Japanese', 'Teaching Japanese'),
    ('Ukrainian', 'Teaching Ukrainian'),
    ('Arabic', 'Teaching Arabic'),
    ('Math', 'Teaching Math'),
    ('Physics', 'Teaching Physics'),
    ('Piano', 'Teaching Piano'),
]

#
class LanguageLevel2(models.Model):
    name = models.CharField(max_length=2, choices=LEVEL_CHOICES, unique=True)

    def __str__(self):
        return self.name


class Skill2(models.Model):
    name = models.CharField(max_length=20, choices=SKILL_CHOICES, unique=True)

    def __str__(self):
        return self.name

class Subject2(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name


class Student3(models.Model):
    profile = models.OneToOneField('app_accounts.UserProfile', on_delete=models.CASCADE, related_name='student3_profile',
                                   limit_choices_to={'user_type': 'student'}, unique=True,
                                   )
    major = models.CharField(max_length=100, blank=True, null=True)
    session_count = models.IntegerField(default=0)
    tutor_count = models.IntegerField(default=0)
    interests = models.ManyToManyField('Subject2', blank=True)

    def __str__(self):
        return f"{self.profile.user.username}"


# class Student3(models.Model):
#     user = models.OneToOneField(UserProfile, on_delete=models.CASCADE)
#     grade = models.CharField(max_length=100)
#
#     def __str__(self):
#         return self.user.username

# class Tutor2(models.Model):
#     profile = models.OneToOneField('app_accounts.UserProfile', on_delete=models.CASCADE,
#                                    related_name='tutor2_profile', limit_choices_to={'user_type': 'tutor'}, unique=True,
#                                    )
#     video_url = models.URLField(blank=True)
#     video_intro = models.FileField(upload_to='videos/%Y/%m/%d/', blank=True)  # Allow video uploads
#     cost_trial = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
#     cost_hourly = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
#     session_count = models.IntegerField(default=0)
#     student_count = models.IntegerField(default=0)
#     course_count = models.IntegerField(default=0)
#     create_date = models.DateTimeField(auto_now_add=True)  # Use auto_now_add
#     # create_date = models.DateTimeField(default=datetime.now) # Use auto_now_add
#     last_modified = models.DateTimeField(default=datetime.now, blank=True)
#
#     def __str__(self):
#         return f"{self.profile.user.username}"
#
#     def save(self, *args, **kwargs):
#         self.last_modified = timezone.now()
#         super().save(*args, **kwargs)
#
#     def get_absolute_url(self):
#         return reverse('app_accounts:dt_edit_profile', kwargs={'pk': self.pk})

class Tutor3(models.Model):
    profile = models.OneToOneField(UserProfile, on_delete=models.CASCADE, related_name='tutor3_profile', limit_choices_to={'user_type': 'tutor'}, unique=True)
    bio = models.TextField(blank=True)

    def __str__(self):
        return self.profile.user.username


class Session3(models.Model):
    tutor = models.ForeignKey(Tutor3, on_delete=models.CASCADE)
    students = models.ManyToManyField(Student3)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()
    subject = models.CharField(max_length=200)

    def __str__(self):
        return f"{self.subject} session with {self.tutor.profile.user.username} at {self.start_time}"

#
# class Schedule2(models.Model):
#     tutor = models.ForeignKey(Tutor2, on_delete=models.CASCADE, related_name="schedules2", null=True, blank=True)
#     student = models.ManyToManyField(Student2, blank=True, related_name="schedules2")
#     start_session = models.DateTimeField(default=datetime.now)
#     end_session = models.DateTimeField(default=datetime.now)
#
#     def __str__(self):
#         return f'Tutor: {self.tutor.profile.user.username}, Student: {self.student.profile.user.username}, At: {self.start_session} - {self.end_session}'
