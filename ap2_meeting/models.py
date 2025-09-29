import pytz
from datetime import time, datetime, date, timedelta
from django.db import models
from django.db.models import Avg
from shortuuid import ShortUUID
from shortuuid.django_fields import ShortUUIDField
from django.contrib.auth.models import User
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
SESSION_TYPES = [('private', 'Private'), ('group', 'Group'), ('trial', 'Trial'), ('interview', 'Interview')]
# TIMEZONE_CHOICES = zip(pytz.all_timezones, pytz.all_timezones)
TIMEZONE_CHOICES = [(tz, tz) for tz in pytz.all_timezones]
AVAILABLE_STATUS_CHOICES = [('free', 'Free'), ('booked', 'Booked'), ('reserving', 'Reserving')]
REVIEW_STATUS_CHOICES = [('pending', 'Pending'), ('published', 'Published'), ('archived', 'Archived')]
RATING = [(1, '1'), (2, '2'), (3, '3'), (4, '4'), (5, '5')]


class AppointmentSetting(models.Model):
    # you need to restrict this to 'tutor', 'admin', 'interviewer'
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="appointment_settings",
                                null=True, blank=True, default=None)
    timezone = models.CharField(max_length=50, choices=TIMEZONE_CHOICES, default="UTC")
    week_start = models.CharField(max_length=10, choices=WEEK_DAYS, default="0")
    session_length = models.CharField(max_length=10, choices=SESSION_LENGTH, default="2")
    session_type = models.CharField(max_length=10, choices=SESSION_TYPES, default='private', blank=False)

    def __str__(self):
        return f"{self.user.username}, Timezone: {self.timezone}, Session Length: {self.session_length}, Start day of week: {self.week_start}."


class Availability(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="availabilities")
    start_time_utc = models.DateTimeField()
    end_time_utc = models.DateTimeField()
    status = models.CharField(max_length=20, choices=AVAILABLE_STATUS_CHOICES, default='free')
    is_available = models.BooleanField(default=True)  # Can be used to mark unavailable times

    def __str__(self):
        return f"{self.user.username} available from {self.start_time_utc} to {self.end_time_utc}."

    def clean(self):
        super().clean()

        # Ensure start_time_utc is before end_time_utc
        if self.start_time_utc >= self.end_time_utc:
            raise ValidationError("The session start time must be before the end time.")

        # Check for overlapping sessions for the same provider (tutor)
        overlapping_availabilities = Availability.objects.filter(
            user=self.user,
            start_time_utc__lt=self.end_time_utc,
            end_time_utc__gt=self.start_time_utc,
        ).exclude(id=self.id)  # Exclude the current session when updating

        if overlapping_availabilities.exists():
            raise ValidationError("This session overlaps with another session for the same user.")

    def save(self, *args, **kwargs):
        # Call the clean method to ensure validations are checked before saving
        self.clean()
        super().save(*args, **kwargs)


class AvailableRule(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="available_rules")
    weekday = models.CharField(max_length=10, choices=WEEK_DAYS)
    start_time_utc = models.TimeField()
    end_time_utc = models.TimeField()
    status = models.CharField(max_length=20, choices=AVAILABLE_STATUS_CHOICES, default='free')
    is_available = models.BooleanField(default=True)  # Can be used to mark unavailable times
    is_full_day = models.BooleanField(default=False)  # Track full-day slots

    def __str__(self):
        return f"{self.user.username} available in {self.get_weekday_display()} from {self.start_time_utc} to {self.end_time_utc}."

    def clean(self):
        super().clean()

        # Handle full-day slots specially
        if self.is_full_day:
            self.start_time_utc = time(0, 0, 0)
            self.end_time_utc = time(23, 59, 59)
            return

        if self.start_time_utc >= self.end_time_utc:
            raise ValidationError("The session start time must be before the end time.")

        overlapping_available_rule = AvailableRule.objects.filter(
            user=self.user,
            weekday=self.weekday,
            start_time_utc__lt=self.end_time_utc,
            end_time_utc__gt=self.start_time_utc,
        ).exclude(id=self.id)

        if overlapping_available_rule.exists():
            raise ValidationError("This session overlaps with another session for the same user.")

    def save(self, *args, **kwargs):
        self.clean()
        super().save(*args, **kwargs)


class Session(models.Model):
    appointment_id = models.CharField(max_length=10, unique=True, blank=True, editable=False)
    provider = models.ForeignKey(User, on_delete=models.CASCADE, related_name="provider_sessions", default=None,
                                 blank=False)
    # students = models.ManyToManyField(Student, related_name="students_sessions", blank=False)
    clients = models.ManyToManyField(User, related_name="client_sessions", blank=False)
    # reviews = models.ManyToManyField('ap2_meeting.Review', related_name="reviews_sessions", blank=True)
    subject = models.CharField(max_length=100, blank=False)
    session_type = models.CharField(max_length=10, choices=SESSION_TYPES, default='private', blank=False)
    cost = models.DecimalField(max_digits=10, decimal_places=2, default=0.00, )
    start_session_utc = models.DateTimeField(default=timezone.now)
    end_session_utc = models.DateTimeField(default=timezone.now)
    status = models.CharField(max_length=20, choices=SESSION_STATUS_CHOICES, default='pending')
    rating = models.DecimalField(max_digits=3, decimal_places=2, null=True, blank=True)
    video_call_link = models.URLField(blank=True, null=True,
                                      help_text="Optional: paste Zoom, Google Meet, or other link.")
    is_sent_link = models.BooleanField(default=False)
    is_sent_reminder_1h = models.BooleanField(default=False)
    is_sent_reminder_10m = models.BooleanField(default=False)
    is_rescheduled = models.BooleanField(default=False)
    rescheduled_at = models.DateTimeField(null=True, blank=True)
    rescheduled_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True,
                                       related_name='rescheduled_sessions')

    def __str__(self):
        # return f"{self.subject} session , ID: {self.appointment_id} by {self.provider.profile.user.username} at {self.start_session_utc} - cost: {self.cost}"
        return f"{self.subject} session , ID: {self.appointment_id} by {self.provider.username} at {self.start_session_utc} - cost: {self.cost}"

    def clean(self):
        super().clean()

        # Ensure start_session_utc is before end_session
        if self.start_session_utc >= self.end_session_utc:
            raise ValidationError("The session start time must be before the end time.")

        # Check for overlapping sessions for the same provider (tutor)
        overlapping_sessions = Session.objects.filter(
            provider=self.provider,
            start_session_utc__lt=self.end_session_utc,
            end_session_utc__gt=self.start_session_utc,
        ).exclude(id=self.id)  # Exclude the current session when updating

        if overlapping_sessions.exists():
            raise ValidationError("This session overlaps with another session for the same provider.")

        # if self.rescheduled_start and self.rescheduled_start <= self.start_session_utc:
        #     raise ValidationError("Rescheduled start time must be after the original start time.")

    def generate_unique_appointment_id(self):
        """Try to generate a unique appointment_id."""
        alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        suid = ShortUUID(alphabet=alphabet)
        while True:
            new_id = suid.random(length=8)
            if not Session.objects.filter(appointment_id=new_id).exists():
                return new_id

    def save(self, *args, **kwargs):
        # Call the clean method to ensure validations are checked before saving
        if not self.appointment_id:
            self.appointment_id = self.generate_unique_appointment_id()
            print(f"UUID: {self.appointment_id}")
        self.clean()
        super().save(*args, **kwargs)

    # is_tutor
    def is_tutor(self, user):
        """Check if the given user is the provider for this session."""
        # return user == self.tutor.profile.user
        return user.profile.user_type == 'tutor'

    def is_interview(self):
        return self.session_type == 'interview'

    def average_rating(self):
        """Calculate the average rating for this session based on reviews."""
        reviews = self.reviews.all()
        if reviews.exists():
            return reviews.aggregate(Avg('rating'))['rating__avg']
        return None


class Review(models.Model):
    # student , student_reviews
    # client = models.ForeignKey(Student, on_delete=models.CASCADE, related_name="client_reviews")
    client = models.ForeignKey(User, on_delete=models.CASCADE, related_name="client_reviews")
    # tutor , tutor_reviews
    provider = models.ForeignKey(User, on_delete=models.CASCADE, related_name="provider_reviews")
    session = models.ForeignKey(Session, on_delete=models.CASCADE, related_name="reviews", null=True,
                                blank=True, )  # ForeignKey for flexibility
    # rate_tutor
    rate_provider = models.IntegerField(choices=RATING, null=True, blank=False)
    rate_session = models.IntegerField(choices=RATING, null=True, blank=False)
    like_count = models.PositiveIntegerField(null=True, blank=True, default=0)
    dislike_count = models.PositiveIntegerField(null=True, blank=True, default=0)
    message = models.TextField(blank=True, max_length=300)
    status = models.CharField(max_length=20, choices=REVIEW_STATUS_CHOICES, default='pending')
    is_published = models.BooleanField(default=False)
    create_date = models.DateTimeField(auto_now_add=True)
    last_modified = models.DateTimeField(default=timezone.now, blank=True)

    def __str__(self):
        # return f"Review by {self.client.profile.user.username} for {self.provider.profile.user.username}"
        return f"Review by {self.client.username} for {self.provider.username}"

    class Meta:
        unique_together = ('client', 'session')  # Ensure a student can only review a session once

    def save(self, *args, **kwargs):
        # Automatically update status to 'published' if 'is_published' is True
        if self.is_published:
            self.status = 'published'
        else:
            self.status = 'pending'

        is_new = self.pk is None  # Check if this is a new review

        # Call the original save method first
        super().save(*args, **kwargs)

        # Update provider's rating after saving
        self.update_provider_rating()

    def delete(self, *args, **kwargs):
        # Store provider reference before deletion
        provider = self.provider

        # Delete the review
        super().delete(*args, **kwargs)

        # Update provider's rating after deletion
        if provider:
            self._update_provider_rating(provider)

    def update_provider_rating(self):
        """Update the provider's average rating"""
        self._update_provider_rating(self.provider)

    @staticmethod
    def _update_provider_rating(provider):
        """Static method to update rating for a given provider"""
        from django.db.models import Avg, Count

        # Get all published reviews for this provider
        reviews = Review.objects.filter(provider=provider, is_published=True)

        # Calculate new average rating and count
        rating_data = reviews.aggregate(
            avg_rating=Avg('rate_provider'),
            total_reviews=Count('id')
        )

        # Update the provider's profile
        provider_profile = provider.profile
        provider_profile.rating = rating_data['avg_rating'] or 0.0
        provider_profile.reviews_count = rating_data['total_reviews'] or 0
        provider_profile.save()


class InterviewSessionInfo(models.Model):
    session = models.OneToOneField(Session, on_delete=models.CASCADE, related_name="interview_info")
    interviewer_notes = models.TextField(blank=True, null=True)
    candidate_experience = models.TextField(blank=True, null=True)
