# Generated by Django 3.2.25 on 2025-02-16 17:20

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('ap2_tutor', '0001_initial'),
        ('ap2_meeting', '0015_auto_20250216_2038'),
    ]

    operations = [
        migrations.AlterField(
            model_name='appointmentsettings',
            name='tutor',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='appointment_settings', to='ap2_tutor.tutor', unique=True),
        ),
    ]
