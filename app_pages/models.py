from django.db import models


class ContentFiller(models.Model):
    data_title = models.CharField(max_length=50, blank=True)
    name = models.CharField(max_length=50, blank=True)
    logo = models.ImageField(upload_to='photos/logo/', blank=True)
    url = models.URLField(max_length=100, blank=True)
    phone_1 = models.CharField(max_length=50, blank=True)
    phone_2 = models.CharField(max_length=50, blank=True)
    email_1 = models.CharField(max_length=50, blank=True)
    email_2 = models.CharField(max_length=50, blank=True)
    address_line_1 = models.CharField(max_length=150, blank=True)
    address_line_2 = models.CharField(max_length=150, blank=True)
    site_description_1 = models.CharField(max_length=300, blank=True)
    site_description_2 = models.CharField(max_length=300, blank=True)
    site_slogan_1 = models.CharField(max_length=300, blank=True)
    site_slogan_2 = models.CharField(max_length=300, blank=True)
    text_1 = models.CharField(max_length=500, blank=True)
    text_1 = models.CharField(max_length=500, blank=True)
    text_2 = models.CharField(max_length=500, blank=True)
    text_3 = models.CharField(max_length=500, blank=True)
    text_4 = models.CharField(max_length=500, blank=True)
    text_5 = models.CharField(max_length=500, blank=True)

    def __str__(self):
        return self.data_title
