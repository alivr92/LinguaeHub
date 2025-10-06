from django.db import models
from ap2_tutor.models import Tutor

# Create a URL shortener app
class ShortURL(models.Model):
    short_code = models.CharField(max_length=10, unique=True)
    destination_url = models.URLField()
    tutor = models.ForeignKey(Tutor, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)

    @classmethod
    def create_provider_short_url(cls, tutor):
        short_code = generate_short_code()  # Your short code logic
        destination = tutor.get_seo_url()
        return cls.objects.create(
            short_code=short_code,
            destination_url=destination,
            tutor=tutor
        )

# Then provide: your-lms.com/j4kS8 (redirects to full SEO URL)
