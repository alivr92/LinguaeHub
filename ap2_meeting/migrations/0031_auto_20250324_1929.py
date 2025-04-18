# Generated by Django 3.2.25 on 2025-03-24 14:59

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('ap2_tutor', '0011_alter_skilllevel_options'),
        ('ap2_student', '0005_wishlist'),
        ('ap2_meeting', '0030_auto_20250322_0329'),
    ]

    operations = [
        migrations.AlterField(
            model_name='review',
            name='session',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='session_reviews', to='ap2_meeting.session'),
        ),
        migrations.AlterField(
            model_name='review',
            name='status',
            field=models.CharField(choices=[('pending', 'Pending'), ('published', 'Published'), ('archived', 'Archived')], default='free', max_length=20),
        ),
        migrations.AlterField(
            model_name='review',
            name='student',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='student_reviews', to='ap2_student.student'),
        ),
        migrations.AlterField(
            model_name='review',
            name='tutor',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='tutor_reviews', to='ap2_tutor.tutor'),
        ),
        migrations.AlterField(
            model_name='session',
            name='students',
            field=models.ManyToManyField(related_name='students_sessions', to='ap2_student.Student'),
        ),
        migrations.AlterField(
            model_name='session',
            name='tutor',
            field=models.ForeignKey(default=None, on_delete=django.db.models.deletion.CASCADE, related_name='tutor_sessions', to='ap2_tutor.tutor'),
        ),
    ]
