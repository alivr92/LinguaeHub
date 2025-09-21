from celery import shared_task
from django.apps import apps
from django.utils import timezone
from datetime import timedelta
from django.conf import settings
from utils.email import send_dual_email
from utils.converters import utc_to_local


@shared_task  # ← Decorator that makes this function a Celery task
def update_application_statuses():
    # Lazy-load models to avoid circular imports
    ProviderApplication = apps.get_model('ap2_tutor', 'ProviderApplication')
    Session = apps.get_model('ap2_meeting', 'Session')

    # Get only scheduled applicants
    scheduled_applicants = ProviderApplication.objects.filter(status='scheduled')

    for applicant in scheduled_applicants:
        session = Session.objects.filter(
            clients=applicant.user,
            session_type='interview'
        ).first()
        if session and timezone.now() > session.end_session_utc:
            applicant.status = 'decision'
            applicant.save()


@shared_task
def send_reminder_email_task():
    ProviderApplication = apps.get_model('ap2_tutor', 'ProviderApplication')
    Session = apps.get_model('ap2_meeting', 'Session')
    # Note: Settings TZ = 'UTC'
    now = timezone.now()
    print(f'now: {now}')
    scheduled_applicants = ProviderApplication.objects.filter(status='scheduled')

    for applicant in scheduled_applicants:
        session = Session.objects.filter(
            clients=applicant.user,
            session_type='interview'
        ).first()

        if not session:
            continue

        full_name = f"{applicant.first_name} {applicant.last_name}"
        to_email = [applicant.email]
        session_start_local = utc_to_local(session.start_session_utc, str(applicant.timezone))

        # Reminder 1 hour before
        if (
                not session.is_sent_reminder_1h and
                now >= session.start_session_utc - timedelta(hours=1)
        ):
            subject = '⏰ Interview Reminder – Your session starts in 1 hour'
            template_name = 'emails/interview/reminder_1h'
            context = {
                'full_name': full_name,
                'session_start_time': session_start_local,
                'timezone': applicant.timezone,
                'video_call_link': session.video_call_link,
                'site_name': settings.SITE_NAME,
            }
            send_dual_email(subject, template_name, context, to_email)
            session.is_sent_reminder_1h = True
            session.save(update_fields=['is_sent_reminder_1h'])

        # Reminder 10 minutes before
        if (
                not session.is_sent_reminder_10m and
                now >= session.start_session_utc - timedelta(minutes=10)
        ):
            subject = '🚨 Your interview starts in 10 minutes!'
            template_name = 'emails/interview/reminder_10m'
            context = {
                'full_name': full_name,
                'video_call_link': session.video_call_link,
                'site_name': settings.SITE_NAME,
            }
            send_dual_email(subject, template_name, context, to_email)
            session.is_sent_reminder_10m = True
            session.save(update_fields=['is_sent_reminder_10m'])
