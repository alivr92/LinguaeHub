# Generated by Django 3.2.25 on 2025-03-21 19:21

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ap2_tutor', '0009_tutor_discount'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='tutor',
            name='rating',
        ),
        migrations.AddField(
            model_name='tutor',
            name='discount_deadline',
            field=models.DateTimeField(blank=True, null=True),
        ),
    ]
