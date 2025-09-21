from django.db import models
from django.contrib.auth import get_user_model
from django.utils.translation import gettext_lazy as _
import uuid

User = get_user_model()


class Notification(models.Model):
    class NotificationType(models.TextChoices):
        SYSTEM = 'system', _('System Notification')
        MESSAGE = 'message', _('New Message')
        FRIEND_REQUEST = 'friend_request', _('Friend Request')
        COURSE_UPDATE = 'course_update', _('Course Update')
        PAYMENT = 'payment', _('Payment Notification')
        OTHER = 'other', _('Other')

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='notifications'
    )
    title = models.CharField(max_length=255)
    message = models.TextField()
    notification_type = models.CharField(
        max_length=20,
        choices=NotificationType.choices,
        default=NotificationType.SYSTEM
    )
    is_read = models.BooleanField(default=False)
    metadata = models.JSONField(default=dict, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['user', 'is_read']),
            models.Index(fields=['created_at']),
        ]

    def __str__(self):
        return f"{self.title} - {self.user}"


class NotificationPreferences(models.Model):
    class DigestFrequency(models.TextChoices):
        DISABLED = 'disabled', _('Disabled')
        DAILY = 'daily', _('Daily')
        WEEKLY = 'weekly', _('Weekly')

    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='notification_preferences'
    )
    email_enabled = models.BooleanField(default=True)
    push_enabled = models.BooleanField(default=True)
    in_app_enabled = models.BooleanField(default=True)
    digest_frequency = models.CharField(
        max_length=10,
        choices=DigestFrequency.choices,
        default=DigestFrequency.DAILY
    )

    def __str__(self):
        return f"Preferences for {self.user}"
