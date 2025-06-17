from django.contrib import admin
from app_accounts.models import (UserProfile, Language, UserSkill, Level, SkillCategory, Skill, UserSpecialization,
                                 UserEducation)
from django.utils.html import format_html


class UserProfileAdmin(admin.ModelAdmin):
    def user_full_name(self, obj):
        return f"{obj.user.first_name} {obj.user.last_name}"

    user_full_name.short_description = 'Full Name'

    def thumbnail(self, object):
        return format_html("<img src='{}' style='width:40px; border-radius:20%;'> ".format(object.photo.url))

    thumbnail.short_description = 'Photo'

    def dipslay_lang_speak(self, obj):
        return " ,".join([lang.name for lang in obj.lang_speak.all()])

    dipslay_lang_speak.short_description = 'Spoken Languages'

    list_display = (
        'id', 'user', 'thumbnail', 'user_full_name', 'country', 'lang_native', 'dipslay_lang_speak', 'rating',
        'user_type', 'is_vip', 'is_active')
    list_display_links = ('user', 'thumbnail',)
    list_editable = ('is_active', 'is_vip',)
    list_filter = ('user_type', 'gender', 'rating', 'is_vip', 'country', 'lang_speak__name',)
    search_fields = ('user__username', 'country', 'lang_native', 'lang_speak__name', 'user_type')


@admin.register(Language)
class LanguageAdmin(admin.ModelAdmin):
    ordering = ('name',)


@admin.register(SkillCategory)
class SkillCategoryAdmin(admin.ModelAdmin):
    list_display = ['name', ]
    ordering = ('name',)


@admin.register(Skill)
class SkillAdmin(admin.ModelAdmin):
    list_display = ['category', 'name', ]
    ordering = ('category', 'name',)


@admin.register(Level)
class LevelAdmin(admin.ModelAdmin):
    list_display = ['name', ]
    ordering = ('name',)


@admin.register(UserEducation)
class UserEducationAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'degree', 'field_of_study', 'institution', 'graduation_year', 'status',
                    'is_certified', 'is_notified']
    list_display_links = ['user', ]
    list_editable = ['status', 'is_certified', 'is_notified']
    ordering = ('user',)


@admin.register(UserSkill)
class UserSkillAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'skill', 'level', 'is_certified', 'status', 'is_notified']
    list_display_links = ['user', ]
    list_editable = ['level', 'status', 'is_certified', 'is_notified']
    ordering = ('skill',)


@admin.register(UserSpecialization)
class UserSpecializationAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'specialization', 'is_certified']
    list_display_links = ['user', ]
    ordering = ('specialization',)


admin.site.register(UserProfile, UserProfileAdmin)
