# Generated by Django 3.2.25 on 2025-06-21 23:12

import django.core.validators
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ap2_tutor', '0002_auto_20250622_0106'),
    ]

    operations = [
        migrations.AddField(
            model_name='teachingcertificate',
            name='completion_date',
            field=models.PositiveIntegerField(blank=True, null=True, validators=[django.core.validators.MinValueValidator(1950), django.core.validators.MaxValueValidator(2025)]),
        ),
    ]
