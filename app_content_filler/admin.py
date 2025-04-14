from django.contrib import admin
from app_content_filler.models import (CFChar, CFText, CFRichText, CFURL, CFBoolean, CFImage, CFFloat, CFDecimal,
                                       CFFile,
                                       CFDateTime, CFInteger, CFEmail)


@admin.register(CFChar)
class CFCharAdmin(admin.ModelAdmin):
    list_display = ('key', 'value')
    search_fields = ('key', 'value')


@admin.register(CFText)
class CFTextAdmin(admin.ModelAdmin):
    list_display = ('key', 'value')
    search_fields = ('key', 'value')


@admin.register(CFRichText)
class CFRichTextAdmin(admin.ModelAdmin):
    list_display = ('key', )  # 'value'
    search_fields = ('key',)  # 'value'


@admin.register(CFEmail)
class CFEmailAdmin(admin.ModelAdmin):
    list_display = ('key', 'value')
    search_fields = ('key', 'value')


@admin.register(CFURL)
class CFURLAdmin(admin.ModelAdmin):
    list_display = ('key', 'value')
    search_fields = ('key', 'value')


@admin.register(CFImage)
class CFImageAdmin(admin.ModelAdmin):
    list_display = ('key', 'value')
    search_fields = ('key', 'value')


@admin.register(CFInteger)
class CFIntegerAdmin(admin.ModelAdmin):
    list_display = ('key', 'value')
    search_fields = ('key', 'value')


@admin.register(CFFloat)
class CFFloatAdmin(admin.ModelAdmin):
    list_display = ('key', 'value')
    search_fields = ('key', 'value')


@admin.register(CFDecimal)
class CFDecimalAdmin(admin.ModelAdmin):
    list_display = ('key', 'value')
    search_fields = ('key', 'value')


@admin.register(CFFile)
class CFFileAdmin(admin.ModelAdmin):
    list_display = ('key', 'value')
    search_fields = ('key', 'value')


@admin.register(CFDateTime)
class CFDateTimeAdmin(admin.ModelAdmin):
    list_display = ('key', 'value')
    search_fields = ('key', 'value')


@admin.register(CFBoolean)
class CFBooleanAdmin(admin.ModelAdmin):
    list_display = ('key', 'value')
    search_fields = ('key', 'value')
