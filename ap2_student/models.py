from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()

NOTIFICATION_TYPE = [
    ('appointment_scheduled', 'Appointment Scheduled'),
    ('appointment_cancelled', 'Appointment Cancelled'),
]


class Subject(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name


class Student(models.Model):
    profile = models.OneToOneField('app_accounts.UserProfile', on_delete=models.CASCADE, related_name='client_profile',
                                   limit_choices_to={'user_type': 'student'}, unique=True,
                                   )
    major = models.CharField(max_length=100, blank=True, null=True)
    session_count = models.IntegerField(default=0)
    tutor_count = models.IntegerField(default=0)
    interests = models.ManyToManyField('Subject', blank=True)

    def __str__(self):
        return self.profile.user.username

    def save(self, *args, **kwargs):
        # Ensure profile is a student
        if self.profile.user_type != 'student':
            raise ValueError("Student profile must have user_type='student'")
        super().save(*args, **kwargs)


# Client Notification
class CNotification(models.Model):
    client = models.ForeignKey(Student, on_delete=models.SET_NULL, null=True, blank=True)
    appointment = models.ForeignKey('ap2_meeting.Session', on_delete=models.CASCADE, null=True, blank=True,
                                    related_name='student_appointment_notification')
    type = models.CharField(max_length=50, choices=NOTIFICATION_TYPE)
    seen = models.BooleanField(default=False)
    date = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name_plural = 'Notification'

    def __str__(self):
        return f'Student: {self.client.profile.user.first_name} {self.client.profile.user.last_name} Notification'


class WishList(models.Model):
    student = models.ForeignKey('Student', on_delete=models.CASCADE, related_name='wishlist')
    tutor = models.ForeignKey('ap2_tutor.Tutor', on_delete=models.CASCADE, related_name='wishlisted_by')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('student', 'tutor')  # Prevent duplicates
        ordering = ['created_at']
