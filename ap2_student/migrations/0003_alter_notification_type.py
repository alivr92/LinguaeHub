# Generated by Django 3.2.25 on 2025-03-11 18:52

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ap2_student', '0002_notification'),
    ]

    operations = [
        migrations.AlterField(
            model_name='notification',
            name='type',
            field=models.CharField(choices=[('appointment_scheduled', 'Appointment Scheduled'), ('appointment_cancelled', 'Appointment Cancelled')], max_length=50),
        ),
    ]
