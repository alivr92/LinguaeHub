from django.db import models
from django_quill.fields import QuillField  # For rich text
from django.contrib.auth import get_user_model
from ckeditor.fields import RichTextField
from ckeditor_uploader.fields import RichTextUploadingField

# from ckeditor_uploader.fields import RichTextUploadingField

User = get_user_model()


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
    text_2 = models.CharField(max_length=500, blank=True)
    text_3 = models.CharField(max_length=500, blank=True)
    text_4 = models.CharField(max_length=500, blank=True)
    text_5 = models.CharField(max_length=500, blank=True)

    def __str__(self):
        return self.data_title


class ContactUs(models.Model):
    name = models.CharField(max_length=100, blank=False, )
    phone = models.CharField(max_length=50, blank=True)
    email = models.EmailField(blank=False)
    message = models.TextField(max_length=400, blank=False)
    create_date = models.DateTimeField(auto_now_add=True)
    is_read = models.BooleanField(default=False)

    def __str__(self):
        return f'{self.name} contacted us at {self.create_date}.'


#
# class Page(models.Model):
#     title = models.CharField(max_length=100, unique=True, help_text="Page title (e.g., Home, About Us)")
#     slug = models.SlugField(max_length=100, unique=True, help_text="Unique URL identifier (e.g., home, about-us)")
#     content = QuillField(help_text="Rich-text content for this page")
#     last_updated = models.DateTimeField(auto_now=True, help_text="When this page was last updated")
#
#     def __str__(self):
#         return self.title
#
#     class Meta:
#         verbose_name = "Page"
#         verbose_name_plural = "Pages"


class Page(models.Model):
    PAGE_CHOICES = [
        ('home', 'Home'),
        ('about', 'About Us'),
        ('terms', 'Terms and Conditions'),
        ('contact', 'Contact Us'),
    ]
    page_type = models.CharField(max_length=20, choices=PAGE_CHOICES, unique=True, default='home')
    content = QuillField()

    def __str__(self):
        return self.get_page_type_display()


# HELP CENTER -----------------
class HelpCategory(models.Model):
    title = models.CharField(max_length=200)
    slug = models.SlugField(unique=True)
    description = models.TextField(blank=True)
    icon = models.CharField(max_length=50, blank=True)  # or use ImageField
    featured = models.BooleanField(default=False)
    order = models.PositiveIntegerField(default=0)

    class Meta:
        verbose_name_plural = "Help Categories"
        ordering = ['order']

    def __str__(self):
        return self.title


class HelpSection(models.Model):
    category = models.ForeignKey(HelpCategory, on_delete=models.CASCADE, related_name='sections')
    title = models.CharField(max_length=200)
    slug = models.SlugField()
    description = models.TextField(blank=True)
    order = models.PositiveIntegerField(default=0)

    class Meta:
        ordering = ['category__order', 'order']
        unique_together = ('category', 'slug')

    def get_full_name(self):
        return f"{self.category.title} > {self.title}"

    def __str__(self):
        return f"{self.category.title}-{self.title}"  # Shows "Category Name -Section Name"


class HelpArticle(models.Model):
    section = models.ForeignKey(HelpSection, on_delete=models.CASCADE, related_name='articles')
    title = models.CharField(max_length=200)
    slug = models.SlugField()
    # content = RichTextField()  # Using CKEditor for rich content
    # content = RichTextField(config_name='default')
    content = RichTextUploadingField()  # Instead of RichTextField
    featured = models.BooleanField(default=False)
    author = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    is_featured = models.BooleanField(default=False)
    view_count = models.PositiveIntegerField(default=0)
    related_articles = models.ManyToManyField('self', blank=True)
    order = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['order']
        unique_together = ('section', 'slug')

    def __str__(self):
        return self.title


class ArticleFeedback(models.Model):
    article = models.ForeignKey(HelpArticle, on_delete=models.CASCADE, related_name='feedback')
    helpful = models.BooleanField()
    comments = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    ip_address = models.GenericIPAddressField(blank=True, null=True)
