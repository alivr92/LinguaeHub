# Generated by Django 3.2.25 on 2025-02-17 12:10

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ap2_tutor', '0001_initial'),
        ('ap2_meeting', '0016_alter_appointmentsettings_tutor'),
    ]

    operations = [
        migrations.RenameModel(
            old_name='AppointmentSettings',
            new_name='AppointmentSetting',
        ),
    ]
