# Generated by Django 3.2.25 on 2025-02-26 22:05

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app_accounts', '0003_alter_userprofile_bio'),
    ]

    operations = [
        migrations.AddField(
            model_name='userprofile',
            name='gender',
            field=models.CharField(blank=True, choices=[('female', 'Female'), ('male', 'Male'), ('transgender', 'Transgender')], default='male', max_length=20, null=True),
        ),
    ]
