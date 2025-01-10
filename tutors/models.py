from django.db import models
from django.contrib.auth.models import User  # Assuming you're using Django's built-in user model
from datetime import datetime
from ckeditor.fields import RichTextField


class Tutor(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)  # Link to Django's User model
    profile_picture = models.ImageField(upload_to='tutor_profiles/')
    bio = models.TextField()
    availability = models.CharField(max_length=255, blank=True)
    languages = models.CharField(max_length=255, blank=True)  # Store languages as a comma-separated string
    rating = models.FloatField(default=0.0)
    reviews_count = models.IntegerField(default=0)
    # Add other relevant fields like experience, teaching style, etc.

    def __str__(self):
        return f"{self.user.first_name} {self.user.last_name}"


class TutorVideo(models.Model):
    tutor = models.ForeignKey(Tutor, on_delete=models.CASCADE)
    video_url = models.URLField()  # Store video URL (e.g., YouTube, Vimeo)