# Generated by Django 3.2.25 on 2025-01-29 09:07

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app_accounts', '0002_alter_userprofile_last_modified'),
    ]

    operations = [
        migrations.AlterField(
            model_name='userprofile',
            name='bio',
            field=models.TextField(blank=True, max_length=350),
        ),
    ]
