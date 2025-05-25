# project/celery.py
import os
from celery import Celery
from celery.schedules import crontab

# Set the default Django settings module
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'LinguaeHub.settings')  # Replace with your settings module

app = Celery('LinguaeHub')  # ← Creates Celery app instance. 'project' = your Django project name
app.config_from_object('django.conf:settings', namespace='CELERY')  # ← Loads settings from Django
app.autodiscover_tasks()
# Schedule periodic tasks
# Run every 1 minute
app.conf.beat_schedule = {  # ← Dictionary of scheduled tasks
    'update-applicants-status': {  # ← Unique name for the task
        'task': 'ap2_tutor.tasks.update_application_statuses',  # ← Path to your task
        'schedule': crontab(minute='*/2'),  # ← Runs every 2 minute
    },
    'send-reminder-email': {
        'task': 'ap2_tutor.tasks.send_reminder_email_task',
        'schedule': crontab(minute='*/1')
    },
}
