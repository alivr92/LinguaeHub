# messenger/consumers.py
import json
from channels.generic.websocket import AsyncWebsocketConsumer
from django.contrib.auth.models import AnonymousUser
from asgiref.sync import sync_to_async
from .models import Thread, Message


class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.thread_id = self.scope['url_route']['kwargs']['thread_id']
        self.thread_group_name = f'thread_{self.thread_id}'

        # Verify user has access to this thread
        user = self.scope['user']
        if isinstance(user, AnonymousUser):
            await self.close()
            return

        thread = await sync_to_async(Thread.objects.filter(
            id=self.thread_id,
            participants=user,
            is_active=True
        ).first)()

        if not thread:
            await self.close()
            return

        # Join thread group
        await self.channel_layer.group_add(
            self.thread_group_name,
            self.channel_name
        )

        await self.accept()

    async def disconnect(self, close_code):
        # Leave thread group
        await self.channel_layer.group_discard(
            self.thread_group_name,
            self.channel_name
        )

    async def receive(self, text_data):
        text_data_json = json.loads(text_data)
        message = text_data_json['message']
        sender_id = text_data_json['sender_id']

        # Verify sender is part of the thread
        user = self.scope['user']
        if str(user.id) != sender_id:
            return

        # Save message to database
        thread = await sync_to_async(Thread.objects.get)(id=self.thread_id)
        recipient = await sync_to_async(thread.get_other_participant)(user)

        db_message = await sync_to_async(Message.objects.create)(
            thread=thread,
            sender=user,
            recipient=recipient,
            content=message
        )

        # Send message to thread group
        await self.channel_layer.group_send(
            self.thread_group_name,
            {
                'type': 'chat_message',
                'message': message,
                'sender_id': sender_id,
                'message_id': str(db_message.id),
                'sent_at': db_message.sent_at.isoformat()
            }
        )

    async def chat_message(self, event):
        # Send message to WebSocket
        await self.send(text_data=json.dumps({
            'message': event['message'],
            'sender_id': event['sender_id'],
            'message_id': event['message_id'],
            'sent_at': event['sent_at']
        }))
