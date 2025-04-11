import pytz
from django.db import models
from django.db.models import Avg
from shortuuid.django_fields import ShortUUIDField

from django.contrib.auth.models import User
from ap2_tutor.models import Tutor
from ap2_student.models import Student
from django.utils import timezone
from django.core.exceptions import ValidationError

SESSION_STATUS_CHOICES = [
    ("pending", "Pending"),
    ("confirmed", "Confirmed"),
    ("finished", "Finished"),
    ("cancelled", "Cancelled"),
    ("scheduled", "Scheduled"),
    ("rescheduled", "Rescheduled"),
    ("partially_attended", "Partially Attended"),
]
WEEK_DAYS = [('0', 'Sunday'), ('1', 'Monday'), ('2', 'Tuesday'), ('3', 'Wednesday'), ('4', 'Thursday'), ('5', 'Friday'),
             ('6', 'Saturday')]
SESSION_LENGTH = [('1', '30 min'), ('2', '1 Hour'), ('3', '90 min'), ('4', '2 Hours'), ('6', '3 Hours')]
SESSION_TYPES = [('private', 'Private'), ('group', 'Group'), ('trial', 'Trial')]
TIMEZONE_CHOICES = zip(pytz.all_timezones, pytz.all_timezones)
AVAILABLE_STATUS_CHOICES = [('free', 'Free'), ('booked', 'Booked'), ('reserving', 'Reserving')]
REVIEW_STATUS_CHOICES = [('pending', 'Pending'), ('published', 'Published'), ('archived', 'Archived')]
RATING = [(1, '1'), (2, '2'), (3, '3'), (4, '4'), (5, '5')]


class AppointmentSetting(models.Model):
    tutor = models.OneToOneField(Tutor, on_delete=models.CASCADE, related_name="appointment_settings")
    provider_timezone = models.CharField(max_length=50, choices=TIMEZONE_CHOICES, default="UTC")
    session_length = models.CharField(max_length=10, choices=SESSION_LENGTH, default="2")
    week_start = models.CharField(max_length=10, choices=WEEK_DAYS, default="0")
    session_type = models.CharField(max_length=10, choices=SESSION_TYPES,
                                    default='private', blank=False)

    def __str__(self):
        return f"{self.tutor.profile.user.username}, Timezone: {self.provider_timezone}, Session Length: {self.session_length},  Start day of week: {self.week_start}."


class Availability(models.Model):
    tutor = models.ForeignKey(Tutor, on_delete=models.CASCADE, related_name="availabilities")
    start_time_utc = models.DateTimeField()
    end_time_utc = models.DateTimeField()
    tutor_timezone = models.CharField(max_length=50, choices=TIMEZONE_CHOICES, default="UTC")
    status = models.CharField(max_length=20, choices=AVAILABLE_STATUS_CHOICES, default='free')
    is_available = models.BooleanField(default=True)  # Can be used to mark unavailable times

    def __str__(self):
        return f"{self.tutor.profile.user.username} available from {self.start_time_utc} to {self.end_time_utc} in {self.tutor_timezone} time."


class Session(models.Model):
    appointment_id = ShortUUIDField(length=6, max_length=10, alphabet="1234567890", default=None, blank=True)
    tutor = models.ForeignKey(Tutor, on_delete=models.CASCADE, related_name="tutor_sessions", default=None, blank=False)
    students = models.ManyToManyField(Student, related_name="students_sessions", blank=False)
    # reviews = models.ManyToManyField('ap2_meeting.Review', related_name="reviews_sessions", blank=True)
    subject = models.CharField(max_length=100, blank=False)
    session_type = models.CharField(max_length=10, choices=SESSION_TYPES, default='private', blank=False)
    cost = models.DecimalField(max_digits=10, decimal_places=2, default=0.00, )
    start_session_utc = models.DateTimeField(default=timezone.now)
    end_session_utc = models.DateTimeField(default=timezone.now)
    status = models.CharField(max_length=20, choices=SESSION_STATUS_CHOICES, default='pending')
    rating = models.DecimalField(max_digits=3, decimal_places=2, null=True, blank=True)
    tutor_timezone = models.CharField(max_length=50, default="UTC")  # Store the tutor's timezone
    students_timezone = models.CharField(max_length=50, default="UTC")  # Store the students' timezone

    is_rescheduled = models.BooleanField(default=False)
    rescheduled_at = models.DateTimeField(null=True, blank=True)
    rescheduled_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True,
                                       related_name='rescheduled_sessions')

    def __str__(self):
        return f"{self.subject} session , ID: {self.appointment_id} by {self.tutor.profile.user.username} at {self.start_session_utc} - cost: {self.cost}"

    def clean(self):
        super().clean()

        # Ensure start_session_utc is before end_session
        if self.start_session_utc >= self.end_session_utc:
            raise ValidationError("The session start time must be before the end time.")

        # Check for overlapping sessions for the same tutor
        overlapping_sessions = Session.objects.filter(
            tutor=self.tutor,
            start_session_utc__lt=self.end_session_utc,
            end_session_utc__gt=self.start_session_utc,
        ).exclude(id=self.id)  # Exclude the current session when updating

        if overlapping_sessions.exists():
            raise ValidationError("This session overlaps with another session for the same tutor.")

        # if self.rescheduled_start and self.rescheduled_start <= self.start_session_utc:
        #     raise ValidationError("Rescheduled start time must be after the original start time.")

    def save(self, *args, **kwargs):
        # Call the clean method to ensure validations are checked before saving
        self.clean()
        super().save(*args, **kwargs)

    def is_tutor(self, user):
        """Check if the given user is the tutor for this session."""
        return user == self.tutor.profile.user

    def average_rating(self):
        """Calculate the average rating for this session based on reviews."""
        reviews = self.reviews.all()
        if reviews.exists():
            return reviews.aggregate(Avg('rating'))['rating__avg']
        return None


class Review(models.Model):
    student = models.ForeignKey(Student, on_delete=models.CASCADE, related_name="student_reviews")
    tutor = models.ForeignKey(Tutor, on_delete=models.CASCADE, related_name="tutor_reviews")
    session = models.ForeignKey(Session, on_delete=models.CASCADE, related_name="reviews", null=True,
                                blank=True, )  # ForeignKey for flexibility
    # session = models.ForeignKey('Session', on_delete=models.CASCADE, related_name="reviews")
    rate_tutor = models.IntegerField(choices=RATING, null=True, blank=False)
    rate_session = models.IntegerField(choices=RATING, null=True, blank=False)
    like_count = models.PositiveIntegerField(null=True, blank=True, default=0)
    dislike_count = models.PositiveIntegerField(null=True, blank=True, default=0)
    message = models.TextField(blank=True, max_length=300)
    status = models.CharField(max_length=20, choices=REVIEW_STATUS_CHOICES, default='free')
    is_published = models.BooleanField(default=False)
    create_date = models.DateTimeField(auto_now_add=True)
    last_modified = models.DateTimeField(default=timezone.now, blank=True)

    def __str__(self):
        return f"Review by {self.student.profile.user.username} for {self.tutor.profile.user.username}"

    class Meta:
        unique_together = ('student', 'session')  # Ensure a student can only review a session once

    def save(self, *args, **kwargs):
        # Automatically update status to 'published' if 'is_published' is True
        if self.is_published:
            self.status = 'published'
        else:
            self.status = 'pending'
        super().save(*args, **kwargs)
