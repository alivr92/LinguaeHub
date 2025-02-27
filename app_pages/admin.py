from django.contrib import admin
from app_pages.models import ContentFiller

@admin.register(ContentFiller)
class ContentFillerAdmin(admin.ModelAdmin):
    list_display = ('id', 'data_title', 'name', 'site_slogan_1', 'site_description_1', )
    list_editable = ( 'site_slogan_1', 'site_description_1', )
    list_display_links = ('name',)
