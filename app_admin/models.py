from django.db import models
from app_accounts.models import UserProfile


class AdminProfile(models.Model):
    profile = models.OneToOneField(UserProfile, on_delete=models.CASCADE, primary_key=True, related_name='admin_profile',
                                   limit_choices_to={'user_type': 'admin'},
                                   )
    department = models.CharField(max_length=100, blank=True, null=True)
    # ... other admin-specific fields

    def __str__(self):
        return self.profile.user.username
