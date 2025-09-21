from django.contrib import admin
from django import forms
from .models import ContentFiller, ContactUs, Page, HelpCategory, HelpSection, HelpArticle
from django_quill.forms import QuillFormField
from ckeditor.widgets import CKEditorWidget
from ckeditor_uploader.widgets import CKEditorUploadingWidget  # if using uploads


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


# ----------- Help Center -----------
@admin.register(HelpCategory)
class HelpCategoryAdmin(admin.ModelAdmin):
    list_display = ('title', 'order', 'slug')
    list_editable = ('order',)
    prepopulated_fields = {'slug': ('title',)}


@admin.register(HelpSection)
class HelpSectionAdmin(admin.ModelAdmin):
    list_display = ('title', 'category', 'order', 'slug')
    list_editable = ('order',)
    list_filter = ('category',)
    prepopulated_fields = {'slug': ('title',)}
    list_select_related = ('category',)  # For better performance


class HelpArticleAdminForm(forms.ModelForm):
    # content = forms.CharField(widget=CKEditorWidget())
    content = forms.CharField(widget=CKEditorUploadingWidget())  # or CKEditorWidget if not using uploads

    class Meta:
        model = HelpArticle
        fields = '__all__'


@admin.register(HelpArticle)
class HelpArticleAdmin(admin.ModelAdmin):
    form = HelpArticleAdminForm  # Add this line
    list_display = ('title', 'section', 'is_featured', 'view_count')
    list_filter = ('section__category', 'section')
    search_fields = ('title', 'content')
    prepopulated_fields = {'slug': ('title',)}
    list_select_related = ('section', 'section__category')

    fieldsets = [
        ('Basic Information', {
            'fields': ('title', 'slug', 'section', 'is_featured'),
            'classes': ('collapse',)
        }),
        ('Content', {
            'fields': ('content',),
            'classes': ('wide',)
        }),
        ('Metadata', {
            'fields': ('view_count',),
            'classes': ('collapse',)
        }),
    ]
