from django.db import models
from django_quill.fields import QuillField


# --------------------------------- CF = Content Filler
class CFChar(models.Model):
    key = models.CharField(max_length=255, unique=True)
    value = models.CharField(max_length=255, blank=True, null=True)

    def __str__(self):
        return self.key


class CFText(models.Model):
    key = models.CharField(max_length=255, unique=True)
    value = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.key


class CFRichText(models.Model):
    key = models.CharField(max_length=255, unique=True)
    value = QuillField(blank=True, null=True)

    def __str__(self):
        return self.key


class CFURL(models.Model):
    key = models.CharField(max_length=255, unique=True)
    value = models.URLField(blank=True, null=True)

    def __str__(self):
        return self.key


class CFEmail(models.Model):
    key = models.CharField(max_length=255, unique=True)
    value = models.EmailField(blank=True, null=True)

    def __str__(self):
        return self.key


class CFImage(models.Model):
    key = models.CharField(max_length=255, unique=True)  # Unique key for each image
    value = models.ImageField(upload_to='content_images/', blank=True, null=True)  # Image file

    def __str__(self):
        return self.key


class CFInteger(models.Model):
    key = models.CharField(max_length=255, unique=True)
    value = models.IntegerField(null=True, blank=True)

    def __str__(self):
        return self.key


class CFFloat(models.Model):
    key = models.CharField(max_length=255, unique=True)
    value = models.FloatField(null=True, blank=True)

    def __str__(self):
        return self.key


class CFDecimal(models.Model):
    key = models.CharField(max_length=255, unique=True)
    value = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)

    def __str__(self):
        return self.key


class CFFile(models.Model):
    key = models.CharField(max_length=255, unique=True)
    value = models.FileField(blank=True, null=True)

    def __str__(self):
        return self.key


class CFBoolean(models.Model):
    key = models.CharField(max_length=255, unique=True)  # Unique key for each boolean
    value = models.BooleanField(default=False)  # Boolean value

    def __str__(self):
        return self.key


class CFDateTime(models.Model):
    key = models.CharField(max_length=255, unique=True)
    value = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return self.key
