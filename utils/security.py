from django.core.cache import cache
import logging
from utils.trackers import get_client_ip
from app_accounts.models import SecurityEvent

logger = logging.getLogger(__name__)


def log_security_event(request, event_type, details=None):
    """Universal security event logger using the consolidated model"""
    event = SecurityEvent.objects.create(
        event_type=event_type,
        user=getattr(request, 'user', None),
        ip_address=get_client_ip(request),
        user_agent=request.META.get('HTTP_USER_AGENT', ''),
        path=request.path,
        details=details or {},
        reason=details.get('reason', '') if details else ''
    )

    logger.warning(
        f"Security event: {event_type}",
        extra={
            'ip': event.ip_address,
            'user': event.user_id,
            'path': event.path
        }
    )
    return event
