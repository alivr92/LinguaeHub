# signals.py
from django.db.models.signals import post_delete, post_save
from django.dispatch import receiver
from .models import Review


@receiver(post_delete, sender=Review)
def update_provider_rating_on_delete(sender, instance, **kwargs):
    """
    Signal receiver function that runs after ANY Review is deleted
    - Works for single deletes: review.delete()
    - Works for bulk deletes: Review.objects.filter(...).delete()
    - Works for admin deletes
    """
    if instance.provider:  # Safety check: ensure the review had a provider
        Review._update_provider_rating(instance.provider)  # Call your static method


@receiver(post_save, sender=Review)
def update_provider_rating_on_save(sender, instance, created, **kwargs):
    """
    Signal receiver for saves - handles bulk creates/updates
    - created: True if this is a new object, False if it's an update
    """
    if instance.provider:
        Review._update_provider_rating(instance.provider)
