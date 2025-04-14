from django.contrib import admin
from .models import Comment, Post, Tag, Category


@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ('wp_post_id', 'wp_post_title', 'name', 'user', 'message', 'create_date', 'is_published')
    list_display_links = ('name', 'user')
    search_fields = ('wp_post_id', 'user', 'wp_post_title', 'name', 'email', 'message')
    list_filter = ('wp_post_id', 'wp_post_title', 'name', 'email', 'create_date', 'is_published',)
    list_editable = ('is_published',)


@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display = ('title', 'status', 'date_create',)
    list_display_links = ('title',)
    # list_editable = ('tag', 'cat',)
    list_filter = ('status',)
    search_fields = ('title', 'content')
    prepopulated_fields = {'slug': ('title',)}


@admin.register(Tag)
class TagAdmin(admin.ModelAdmin):
    list_display = ('name',)


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('name',)
