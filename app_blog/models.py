from django.db import models
from django.contrib.auth.models import User
from django.core.exceptions import ValidationError


class Comment(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='blog_comments', blank=True,
                             null=True)  # Registered user (nullable for guest comments)
    wp_post_id = models.IntegerField()  # Store the WordPress post ID
    wp_post_title = models.CharField(max_length=350, null=True, blank=True)
    name = models.CharField(max_length=100, null=False, blank=False)
    email = models.EmailField(blank=False, null=False)
    message = models.TextField()
    create_date = models.DateTimeField(auto_now_add=True)  # Use auto_now_add
    is_published = models.BooleanField(default=False)

    def __str__(self):
        return f"Comment by {self.name} on Post ID {self.wp_post_id}"

    def clean(self):
        if not self.user and (not self.name or not self.email):
            raise ValidationError('Guest comments require a name and email.')
