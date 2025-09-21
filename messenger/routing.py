from django.urls import re_path
from . import consumers  # Import your WebSocket consumers

websocket_urlpatterns = [
    re_path(
        r'ws/messenger/thread/(?P<thread_id>\d+)/$',
        consumers.ChatConsumer.as_asgi()
    ),
]
