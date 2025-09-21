from django.db import models
from django.contrib.auth.models import User
from django.core.exceptions import ValidationError
from django_quill.fields import QuillField
from shortuuid.django_fields import ShortUUIDField
from django.utils.text import slugify


class Tag(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name


class Category(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name


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


class Post(models.Model):
    pid = ShortUUIDField(length=6, max_length=10, alphabet="1234567890", unique=True)
    author = models.ForeignKey(User, on_delete=models.CASCADE, related_name='posts_author', blank=False, null=False)
    title = models.CharField(max_length=250, null=False, blank=False)
    slug = models.SlugField(max_length=250, unique=True, blank=True, db_index=True)
    cover = models.ImageField(upload_to='blog/posts/%Y/%m/%d/', blank=True, default='blog/default_cover.jpg')
    content = QuillField(blank=True, null=True)
    excerpt = models.TextField(blank=True, null=True, max_length=750,)
    tag = models.ManyToManyField(Tag, blank=True)
    cat = models.ManyToManyField(Category, blank=True)
    status = models.CharField(choices=[('draft', 'Draft'), ('published', 'Published')], default='draft', max_length=10,
                              db_index=True)
    comment_status = models.CharField(choices=[('open', 'Open'), ('close', 'Close')], default='close', max_length=5)
    like_count = models.PositiveIntegerField(default=0)
    visit_count = models.PositiveIntegerField(default=0)
    date_create = models.DateTimeField(auto_now_add=True)  # Only set on creation
    date_modified = models.DateTimeField(auto_now=True)  # Updates on every save

    def __str__(self):
        return f"post ID: {self.pid}, Title: {self.title}, status: {self.status}"

    def save(self, *args, **kwargs):
        # Only generate slug if this is a new post or the title changed
        if not self.slug or (self.pk and Post.objects.get(pk=self.pk).title != self.title):
            self.slug = slugify(self.title)

            # Ensure slug is unique
            original_slug = self.slug
            counter = 1
            while Post.objects.filter(slug=self.slug).exclude(pk=self.pk).exists():
                self.slug = f"{original_slug}-{counter}"
                counter += 1

        # Call the parent save method
        super().save(*args, **kwargs)
