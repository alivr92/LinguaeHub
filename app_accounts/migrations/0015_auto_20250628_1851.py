# Generated by Django 3.2.25 on 2025-06-28 14:21

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('app_accounts', '0014_alter_userprofile_gender'),
    ]

    operations = [
        migrations.RenameField(
            model_name='userprofile',
            old_name='agreed_to_terms',
            new_name='terms_agreed',
        ),
        migrations.RenameField(
            model_name='userprofile',
            old_name='terms_agreement_date',
            new_name='terms_agreed_date',
        ),
    ]
