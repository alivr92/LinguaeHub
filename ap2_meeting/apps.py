from django.apps import AppConfig


class Ap2MeetingConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'ap2_meeting'

    def ready(self):
        # Import and connect the signals when the app is ready
        import ap2_meeting.signals
