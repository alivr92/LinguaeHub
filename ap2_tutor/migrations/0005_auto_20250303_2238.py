# Generated by Django 3.2.25 on 2025-03-03 19:08

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('ap2_tutor', '0004_auto_20250227_2149'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='tutor',
            name='video_intro',
        ),
        migrations.AlterField(
            model_name='skill',
            name='name',
            field=models.CharField(choices=[('Persian', 'Teaching Persian'), ('English', 'Teaching English'), ('German', 'Teaching German'), ('Spanish', 'Teaching Spanish'), ('French', 'Teaching French'), ('Chinese', 'Teaching Chinese'), ('Italian', 'Teaching Italian'), ('Turkish', 'Teaching Turkish'), ('Swedish', 'Teaching Swedish'), ('Korean', 'Teaching Korean'), ('Hindi', 'Teaching Hindi'), ('Russian', 'Teaching Russian'), ('Japanese', 'Teaching Japanese'), ('Ukrainian', 'Teaching Ukrainian'), ('Arabic', 'Teaching Arabic'), ('Math', 'Teaching Math'), ('Physics', 'Teaching Physics'), ('Piano', 'Teaching Piano')], max_length=20, unique=True),
        ),
    ]
