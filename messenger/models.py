from django.db import models
from django.contrib.auth import get_user_model
from django.utils import timezone
from django.core.exceptions import ValidationError

User = get_user_model()


class Thread(models.Model):
    """
    Represents a conversation thread between users.
    Uses a many-to-many relationship to support group chats in the future.
    """
    participants = models.ManyToManyField(User, related_name='threads')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=True)

    class Meta:
        ordering = ['-updated_at']
        indexes = [
            models.Index(fields=['updated_at']),
            models.Index(fields=['is_active']),
        ]

    def __str__(self):
        return f"Thread {self.id}"

    def clean(self):
        if self.participants.count() < 2:
            raise ValidationError("A thread must have at least 2 participants")

    def get_other_participant(self, user):
        """Get the other participant in a 1:1 chat"""
        if self.participants.count() != 2:
            return None
        return self.participants.exclude(id=user.id).first()

    def mark_read_for_user(self, user):
        """Mark all messages as read for a specific user"""
        self.messages.filter(recipient=user, is_read=False).update(is_read=True)


class Message(models.Model):
    """
    Represents an individual message within a thread.
    """
    thread = models.ForeignKey(Thread, on_delete=models.CASCADE, related_name='messages')
    sender = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sent_messages')
    recipient = models.ForeignKey(User, on_delete=models.CASCADE, related_name='received_messages')
    content = models.TextField()
    is_read = models.BooleanField(default=False)
    sent_at = models.DateTimeField(auto_now_add=True)
    read_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        ordering = ['sent_at']
        indexes = [
            models.Index(fields=['thread', 'sent_at']),
            models.Index(fields=['sender', 'recipient']),
            models.Index(fields=['is_read']),
            models.Index(fields=['sent_at']),
        ]

    def __str__(self):
        return f"Message {self.id} from {self.sender} to {self.recipient}"

    def save(self, *args, **kwargs):
        if self.sender == self.recipient:
            raise ValidationError("Cannot send message to yourself")

        # Ensure sender is in thread participants
        if not self.thread.participants.filter(id=self.sender.id).exists():
            raise ValidationError("Sender must be a thread participant")

        # Ensure recipient is in thread participants
        if not self.thread.participants.filter(id=self.recipient.id).exists():
            raise ValidationError("Recipient must be a thread participant")

        super().save(*args, **kwargs)

    def mark_as_read(self):
        if not self.is_read:
            self.is_read = True
            self.read_at = timezone.now()
            self.save()


class UserMessageSettings(models.Model):
    """
    Per-user messaging preferences and settings.
    """
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='message_settings')
    email_notifications = models.BooleanField(default=True)
    push_notifications = models.BooleanField(default=True)
    allow_messages_from = models.CharField(
        max_length=20,
        choices=[
            ('all', 'All Users'),
            ('verified', 'Verified Users Only'),
            ('none', 'No Messages'),
        ],
        default='all'
    )
    blocked_users = models.ManyToManyField(User, blank=True, related_name='blocked_by')

    def __str__(self):
        return f"Message settings for {self.user}"

    def can_receive_message_from(self, sender):
        """Check if this user can receive messages from the given sender"""
        if sender == self.user:
            return False
        if sender in self.blocked_users.all():
            return False
        if self.allow_messages_from == 'none':
            return False
        if self.allow_messages_from == 'verified' and not sender.profile.is_email_verified:
            return False
        return True
