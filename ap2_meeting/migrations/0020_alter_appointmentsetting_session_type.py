# Generated by Django 3.2.25 on 2025-02-17 19:05

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ap2_meeting', '0019_alter_appointmentsetting_session_length'),
    ]

    operations = [
        migrations.AlterField(
            model_name='appointmentsetting',
            name='session_type',
            field=models.CharField(choices=[('private', 'Private'), ('group', 'Group'), ('trial', 'Trial')], default='private', max_length=10),
        ),
    ]
