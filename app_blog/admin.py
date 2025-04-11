from django.contrib import admin
from .models import Comment


@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ('wp_post_id', 'wp_post_title', 'name', 'user', 'message', 'create_date', 'is_published')
    list_display_links = ('name', 'user')
    search_fields = ('wp_post_id', 'user', 'wp_post_title', 'name', 'email', 'message')
    list_filter = ('wp_post_id', 'wp_post_title', 'name', 'email', 'create_date', 'is_published',)
    list_editable = ('is_published',)
