# Generated by Django 3.2.25 on 2025-06-26 20:04

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('app_accounts', '0012_auto_20250625_1843'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='userprofile',
            name='url_facebook',
        ),
        migrations.RemoveField(
            model_name='userprofile',
            name='url_insta',
        ),
        migrations.RemoveField(
            model_name='userprofile',
            name='url_linkedin',
        ),
        migrations.RemoveField(
            model_name='userprofile',
            name='url_twitter',
        ),
        migrations.RemoveField(
            model_name='userprofile',
            name='url_youtube',
        ),
        migrations.AddField(
            model_name='userprofile',
            name='agreed_to_terms',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='userprofile',
            name='email_consent',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='userprofile',
            name='email_consent_date',
            field=models.DateTimeField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='userprofile',
            name='terms_agreement_date',
            field=models.DateTimeField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='usereducation',
            name='description',
            field=models.TextField(blank=True, max_length=500),
        ),
        migrations.CreateModel(
            name='UserSocial',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('url_facebook', models.URLField(blank=True, max_length=150)),
                ('url_insta', models.URLField(blank=True, max_length=150)),
                ('url_twitter', models.URLField(blank=True, max_length=150)),
                ('url_linkedin', models.URLField(blank=True, max_length=150)),
                ('url_youtube', models.URLField(blank=True, max_length=150)),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='socials', to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
