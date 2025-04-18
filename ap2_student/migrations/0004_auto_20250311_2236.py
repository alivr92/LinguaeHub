# Generated by Django 3.2.25 on 2025-03-11 19:06

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('ap2_meeting', '0028_auto_20250310_2353'),
        ('ap2_student', '0003_alter_notification_type'),
    ]

    operations = [
        migrations.CreateModel(
            name='CNotification',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('type', models.CharField(choices=[('appointment_scheduled', 'Appointment Scheduled'), ('appointment_cancelled', 'Appointment Cancelled')], max_length=50)),
                ('seen', models.BooleanField(default=False)),
                ('date', models.DateTimeField(auto_now_add=True)),
                ('appointment', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='student_appointment_notification', to='ap2_meeting.session')),
                ('client', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='ap2_student.student')),
            ],
            options={
                'verbose_name_plural': 'Notification',
            },
        ),
        migrations.DeleteModel(
            name='Notification',
        ),
    ]
