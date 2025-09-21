from django.db import models
from app_accounts.models import UserProfile


STAFF_POSITIONS = [('data_entry', 'Data Entry'), ('marketer', 'Marketer'), ('content_producer', 'Content Producer')]


class Staff(models.Model):
    profile = models.OneToOneField(UserProfile, on_delete=models.CASCADE, primary_key=True, related_name='staff_profile')
    position = models.CharField(max_length=100, blank=True, null=True, choices=STAFF_POSITIONS)
    # ... other staff-specific fields

    def __str__(self):
        return self.profile.user.username
