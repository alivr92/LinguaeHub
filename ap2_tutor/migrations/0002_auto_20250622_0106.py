# Generated by Django 3.2.25 on 2025-06-21 20:36

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('ap2_tutor', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='TeachingCategory',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100, unique=True)),
            ],
        ),
        migrations.RenameField(
            model_name='providerapplication',
            old_name='reviewer_comment',
            new_name='reviewer_comment',
        ),
        migrations.AddField(
            model_name='tutor',
            name='years_experience',
            field=models.PositiveSmallIntegerField(blank=True, choices=[('', 'Select a period'), (0, 'Less than 1 year'), (1, '1-2 years'), (2, '3-5 years'), (3, '6-10 years'), (4, 'More than 10 years')], null=True),
        ),
        migrations.AlterField(
            model_name='providerapplication',
            name='status',
            field=models.CharField(choices=[('pending', 'Pending'), ('invited', 'Invited'), ('registered', 'Registered'), ('completed_profile', 'Completed Profile'), ('added_skills', 'Added Skills'), ('added_edu', 'Added Education'), ('decision', 'Decision'), ('accepted', 'Accepted'), ('rejected', 'Rejected')], default='pending', max_length=20),
        ),
        migrations.CreateModel(
            name='TeachingSubCategory',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100, unique=True)),
                ('category', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='teaching_sub_categories', to='ap2_tutor.teachingcategory')),
            ],
        ),
        migrations.CreateModel(
            name='TeachingCertificate',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(choices=[('', 'Select a certificate'), ('toefl', 'TOEFL'), ('ielts', 'IELTS'), ('cambridge_a2', 'Cambridge English A2 Key'), ('cambridge_b1', 'Cambridge English B1 Preliminary'), ('cambridge_b2', 'Cambridge English B2 First'), ('cambridge_c1', 'Cambridge English C1 Advanced'), ('cambridge_c2', 'Cambridge English C2 Proficiency'), ('pte_academic', 'PTE Academic'), ('duolingo', 'Duolingo English Test'), ('toeic', 'TOEIC'), ('oxford', 'Oxford Test of English'), ('trinity_gese', 'Trinity College London GESE'), ('trinity_ise', 'Trinity College London ISE'), ('michigan_met', 'Michigan Tests MET'), ('michigan_ecce', 'Michigan Tests ECCE'), ('michigan_ecpe', 'Michigan Tests ECPE'), ('delf_dalf', 'DELF / DALF'), ('tcf', 'TCF'), ('tef', 'TEF'), ('dfp', 'DFP'), ('dele', 'DELE'), ('siele', 'SIELE'), ('celu', 'CELU'), ('goethe', 'Goethe-Zertifikat'), ('testdaf', 'TestDaF'), ('telc_deutsch', 'telc Deutsch'), ('dsh', 'DSH'), ('osd', 'ÖSD'), ('celi', 'CELI'), ('cils', 'CILS'), ('plida', 'PLIDA'), ('ail', 'AIL'), ('caple', 'CAPLE'), ('celpe_bras', 'CELPE-Bras'), ('torfl', 'TORFL'), ('cnavt', 'CNaVT'), ('nt2', 'NT2'), ('tisus', 'TISUS'), ('sfi', 'SFI tests'), ('yki', 'YKI'), ('norskprove', 'Norskprøve'), ('bergenstest', 'Bergenstest'), ('prove_dansk_1_2_3', 'Prøve i Dansk 1, 2, 3'), ('studieproven', 'Studieprøven'), ('islandic_test', 'Íslenskupróf fyrir útlendinga'), ('polish_certificate', 'Państwowy Egzamin Certyfikatowy z Języka Polskiego'), ('greek_certificate', 'ΚΠγ'), ('czech_cce', 'CCE'), ('czech_cce_foreigners', 'CCE – Czech for Foreigners'), ('hungarian_ecl', 'ECL Hungarian'), ('hungarian_origo', 'Origó'), ('romanian_ecl', 'ECL Romanian'), ('romanian_certificate', 'Romanian Language Proficiency Certificate'), ('bulgarian_certificate', 'Bulgarian Language Proficiency Exam')], max_length=100)),
                ('issuing_organization', models.CharField(max_length=150)),
                ('certificate_file', models.FileField(blank=True, null=True, upload_to='educations/certificates/')),
                ('is_verified', models.BooleanField(default=False)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='certificates', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'ordering': ['-completion_date'],
            },
        ),
        migrations.AddField(
            model_name='tutor',
            name='teaching_tags',
            field=models.ManyToManyField(blank=True, to='ap2_tutor.TeachingCategory'),
        ),
    ]
