from django.db import models
from django.contrib.auth import get_user_model

User = get_user_model()


class Referral(models.Model):
    referrer = models.CharField(max_length=100)  # Just store the code
    referee = models.ForeignKey(User, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    source = models.CharField(max_length=50, default='web')
