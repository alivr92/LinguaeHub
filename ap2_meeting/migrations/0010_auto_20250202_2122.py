# Generated by Django 3.2.25 on 2025-02-02 17:52

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ap2_meeting', '0009_auto_20250202_2114'),
    ]

    operations = [
        migrations.RenameField(
            model_name='session',
            old_name='end_session',
            new_name='end_session_utc',
        ),
        migrations.RenameField(
            model_name='session',
            old_name='start_session',
            new_name='start_session_utc',
        ),
    ]
