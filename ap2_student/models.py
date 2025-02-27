from django.db import models


class Subject(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name


class Student(models.Model):
    profile = models.OneToOneField('app_accounts.UserProfile', on_delete=models.CASCADE, related_name='student_profile',
                                   limit_choices_to={'user_type': 'student'}, unique=True,
                                   )
    major = models.CharField(max_length=100, blank=True, null=True)
    session_count = models.IntegerField(default=0)
    tutor_count = models.IntegerField(default=0)
    interests = models.ManyToManyField('Subject', blank=True)

    def __str__(self):
        return self.profile.user.username


