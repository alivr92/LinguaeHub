from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone


class InPersonService(models.Model):
    SERVICE_CATEGORIES = [
        ('individual', 'Individual Classes'),
        ('group', 'Group Classes'),
        ('business', 'Business & Corporate Training'),
        ('exam', 'Exam Preparation (IELTS, TOEFL, etc.)'),
        ('conversation', 'Conversation Practice'),
        ('kids_teens', 'For Kids & Teens'),
        ('academic', 'Academic Writing & Support'),
        ('specialized', 'Specialized English (Medical, Legal, etc.)'),
    ]

    name = models.CharField(max_length=100)  # e.g., "One-on-One General English"
    category = models.CharField(max_length=20, choices=SERVICE_CATEGORIES)
    description = models.TextField(blank=True)

    # Pricing Structure (What the STUDENT pays Lingocept)
    student_price_per_hour = models.DecimalField(max_digits=6, decimal_places=2)

    # Payout Structure (What Lingocept pays the TUTOR)
    tutor_payout_per_hour = models.DecimalField(max_digits=6, decimal_places=2)

    # Implicit commission rate can be calculated: (student_price - tutor_payout) / student_price
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return f"{self.name} (Student: €{self.student_price_per_hour}/h, Tutor: €{self.tutor_payout_per_hour}/h)"

    class Meta:
        verbose_name = "In-Person Service & Pricing"


class InPersonRequest(models.Model):
    STATUS_CHOICES = [
        ('searching', 'Searching for Tutor'),
        ('offer_sent', 'Offers Sent to Tutors'),
        ('accepted', 'Accepted by Tutor'),
        ('confirmed', 'Confirmed by Student'),
        ('completed', 'Completed'),
        ('cancelled', 'Cancelled'),
    ]
    STUDENT_CURRENT_LEVEL = [
        ('a1', 'A1 (Beginner)'),
        ('a2', 'A2 (Elementary)'),
        ('b1', 'B1 (Intermediate)'),
        ('b2', 'B2 (Upper-Intermediate)'),
        ('c1', 'C1 (Advanced)'),
        ('c2', 'C2 (Proficient)'),
        ('native', 'Native (Fluent as a first language)'),
    ]

    # Who is requesting?
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='in_person_requests',
                             verbose_name='Student')
    # What service do they want?
    service = models.ForeignKey(InPersonService, on_delete=models.PROTECT, related_name='requests')
    # Specific details
    student_notes = models.TextField(blank=True, help_text="Specific learning goals or requirements")
    current_level = models.TextField(blank=True, choices=STUDENT_CURRENT_LEVEL, help_text="Student current level")
    preferred_start_date = models.DateField()
    number_of_sessions = models.PositiveIntegerField(default=1)
    session_duration_hours = models.DecimalField(max_digits=4, decimal_places=1, default=1.5,
                                                 verbose_name='duration')  # e.g., 1.5 hours
    # Status & Lifecycle
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='searching')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    # This will be set once a tutor accepts
    accepted_offer = models.OneToOneField(
        'InPersonOffer',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='accepted_request'
    )

    def __str__(self):
        return f"Request #{self.id} by {self.user.username} for {self.service.name}"

    @property
    def total_student_value(self):
        return self.number_of_sessions * self.session_duration_hours * self.service.student_price_per_hour

    @property
    def total_tutor_payout(self):
        return self.number_of_sessions * self.session_duration_hours * self.service.tutor_payout_per_hour


class InPersonOffer(models.Model):
    STATUS_CHOICES = [
        ('sent', 'Offer Sent'),
        ('accepted', 'Accepted by Tutor'),
        ('declined', 'Declined by Tutor'),
        ('expired', 'Offer Expired'),
    ]

    # Link to the original request
    request = models.ForeignKey(InPersonRequest, on_delete=models.CASCADE, related_name='offers')
    # Who is this offer for?
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='in_person_offers',
                             verbose_name='Tutor')

    # Offer Details (copied from request at time of creation for record-keeping)
    service_name = models.CharField(max_length=100)
    tutor_payout_per_hour = models.DecimalField(max_digits=6, decimal_places=2)
    number_of_sessions = models.PositiveIntegerField()
    session_duration_hours = models.DecimalField(max_digits=4, decimal_places=1)
    total_payout = models.DecimalField(max_digits=8, decimal_places=2)  # calculated: sessions * duration * payout

    # Status & Lifecycle
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='sent')
    sent_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()  # e.g., sent_at + 48 hours
    responded_at = models.DateTimeField(null=True, blank=True)

    # Unique token for secure links in emails
    accept_token = models.CharField(max_length=50, unique=True)
    decline_token = models.CharField(max_length=50, unique=True)

    class Meta:
        unique_together = ['request', 'user']  # Prevent sending the same offer twice

    def save(self, *args, **kwargs):
        if not self.pk:  # If this is a new offer being created
            import secrets
            self.accept_token = secrets.token_urlsafe(25)
            self.decline_token = secrets.token_urlsafe(25)
        super().save(*args, **kwargs)

    def is_expired(self):
        # Check if expires_at is None or if the current time is past the expiration
        if self.expires_at is None:
            return False  # Or True, depending on your business logic. False is safer.
        return timezone.now() > self.expires_at

    def __str__(self):
        return f"Offer for {self.user.username} on Request #{self.request.id}"
