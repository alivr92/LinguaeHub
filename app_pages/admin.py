from django.contrib import admin
from django import forms
from .models import ContentFiller, ContactUs, Page
from django_quill.forms import QuillFormField


@admin.register(ContentFiller)
class ContentFillerAdmin(admin.ModelAdmin):
    list_display = ('id', 'data_title', 'name', 'site_slogan_1', 'site_description_1',)
    list_editable = ('site_slogan_1', 'site_description_1',)
    list_display_links = ('name',)


@admin.register(ContactUs)
class ContactUsAdmin(admin.ModelAdmin):
    list_display = ('name', 'email', 'phone', 'message', 'create_date', 'is_read')
    list_display_links = ('name', 'email')
    search_fields = ('name', 'email', 'phone', 'message')
    list_filter = ('name', 'email', 'phone', 'create_date')
    list_editable = ('is_read',)


class PageAdminForm(forms.ModelForm):
    content = QuillFormField()

    class Meta:
        model = Page
        fields = '__all__'

@admin.register(Page)
class PageAdmin(admin.ModelAdmin):
    form = PageAdminForm
    list_display = ('page_type',)