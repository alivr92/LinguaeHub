from django.db import models
from django.contrib.auth.models import User  # Assuming you're using Django's built-in user model
from datetime import datetime
from ckeditor.fields import RichTextField


class Tutor(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)  # Link to Django's User model
    tutor_image = models.ImageField(upload_to='media/tutor_profiles/')
    bio = models.TextField()
    availability = models.CharField(max_length=255, blank=True)
    # rating star
    rating = models.FloatField(default=0.0)
    reviews_count = models.IntegerField(default=0)
    # Add other relevant fields like experience, teaching style, etc.

    # location: city, state, country

    # skills: Teaching Math, Teaching Piano, Teaching Languages: Arabic, Spanish, ...

    # Languages: languages which the tutors can speak
    languages = models.CharField(max_length=255, blank=True)  # Store languages as a comma-separated string




    def __str__(self):
        return f"{self.user.first_name} {self.user.last_name}"


class TutorVideo(models.Model):
    tutor = models.ForeignKey(Tutor, on_delete=models.CASCADE)
    video_url = models.URLField()  # Store video URL (e.g., YouTube, Vimeo)