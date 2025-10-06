from django.test import TestCase
from django.urls import reverse
from ap2_tutor.models import Tutor


class TutorURLTests(TestCase):
    def setUp(self):
        self.tutor = Tutor.objects.create(
            # ... create a test tutor
        )

    def test_seo_url(self):
        url = reverse('provider:provider_detail', kwargs={'slug': self.tutor.slug})
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)

    def test_short_url_redirect(self):
        url = reverse('provider:provider_short', kwargs={'public_id': self.tutor.public_id})
        response = self.client.get(url)
        self.assertEqual(response.status_code, 301)  # Permanent redirect

    def test_legacy_url_redirect(self):
        url = reverse('provider:provider_legacy', kwargs={'pk': self.tutor.pk})
        response = self.client.get(url)
        self.assertEqual(response.status_code, 301)
