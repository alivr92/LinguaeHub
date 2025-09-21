# notifications/services.py
from django.db import transaction
from django.core.cache import cache
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync


class NotificationService:
    @staticmethod
    def create_notification(user_id, title, message, notification_type, metadata=None):
        from .models import Notification

        notification = Notification.objects.create(
            user_id=user_id,
            title=title,
            message=message,
            type=notification_type,
            metadata=metadata or {}
        )

        # Send real-time update
        channel_layer = get_channel_layer()
        async_to_sync(channel_layer.group_send)(
            f"notifications_{user_id}",
            {
                "type": "notification.message",
                "notification": {
                    "id": str(notification.id),
                    "title": title,
                    "message": message,
                    "type": notification_type,
                    "created_at": notification.created_at.isoformat(),
                    "is_read": False,
                    "metadata": metadata or {}
                }
            }
        )

        return notification

    @staticmethod
    def mark_as_read(user_id, notification_id):
        from .models import Notification

        with transaction.atomic():
            notification = Notification.objects.filter(
                user_id=user_id,
                id=notification_id
            ).select_for_update().first()

            if notification and not notification.is_read:
                notification.is_read = True
                notification.save()

                # Update unread count cache
                cache_key = f"unread_count_{user_id}"
                current_count = cache.get(cache_key, 0)
                if current_count > 0:
                    cache.decr(cache_key)

                return True
        return False

    @staticmethod
    def get_unread_count(user_id):
        cache_key = f"unread_count_{user_id}"
        count = cache.get(cache_key)

        if count is None:
            from .models import Notification
            count = Notification.objects.filter(
                user_id=user_id,
                is_read=False
            ).count()
            cache.set(cache_key, count, timeout=60 * 5)  # 5 minute cache

        return count
