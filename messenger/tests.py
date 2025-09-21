from django.test import TestCase, Client
from django.contrib.auth import get_user_model
from django.urls import reverse
from .models import Thread, Message, UserMessageSettings

User = get_user_model()


class MessagingTests(TestCase):
    def setUp(self):
        self.client = Client()

        # Create test users
        self.user1 = User.objects.create_user(
            username='user1',
            email='user1@example.com',
            password='testpass123'
        )

        self.user2 = User.objects.create_user(
            username='user2',
            email='user2@example.com',
            password='testpass123'
        )

        # Create message settings
        UserMessageSettings.objects.create(user=self.user1)
        UserMessageSettings.objects.create(user=self.user2)

        # Create a thread
        self.thread = Thread.objects.create()
        self.thread.participants.add(self.user1, self.user2)

        # Create a message
        self.message = Message.objects.create(
            thread=self.thread,
            sender=self.user1,
            recipient=self.user2,
            content="Test message"
        )

    def test_inbox_view(self):
        self.client.force_login(self.user1)
        response = self.client.get(reverse('messaging:inbox'))
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Messages")
        self.assertContains(response, "user2")

    def test_thread_detail_view(self):
        self.client.force_login(self.user1)
        response = self.client.get(
            reverse('messaging:thread_detail', args=[self.thread.id])
        )
        self.assertEqual(response.status_code, 200)
        self.assertContains(response, "Test message")

    def test_new_message_view(self):
        self.client.force_login(self.user1)

        # GET request
        response = self.client.get(reverse('messaging:new_message'))
        self.assertEqual(response.status_code, 200)

        # POST request
        response = self.client.post(
            reverse('messaging:new_message'),
            {'recipient_username': 'user2', 'content': 'New test message'}
        )
        self.assertEqual(response.status_code, 302)
        self.assertEqual(Message.objects.count(), 2)

    def test_check_username_endpoint(self):
        self.client.force_login(self.user1)
        response = self.client.post(
            reverse('messaging:check_username'),
            {'recipient_username': 'user2'},
            HTTP_X_REQUESTED_WITH='XMLHttpRequest'
        )
        self.assertEqual(response.status_code, 200)
        self.assertJSONEqual(
            response.content,
            {'valid': True, 'message': 'Found user: user2'}
        )

    def test_message_permissions(self):
        # Create a third user
        user3 = User.objects.create_user(
            username='user3',
            email='user3@example.com',
            password='testpass123'
        )
        UserMessageSettings.objects.create(user=user3)

        # user3 shouldn't be able to see user1 and user2's thread
        self.client.force_login(user3)
        response = self.client.get(
            reverse('messaging:thread_detail', args=[self.thread.id])
        )
        self.assertEqual(response.status_code, 404)

    def test_cannot_message_self(self):
        self.client.force_login(self.user1)
        response = self.client.post(
            reverse('messaging:new_message'),
            {'recipient_username': 'user1', 'content': 'Message to myself'}
        )
        self.assertEqual(response.status_code, 200)
        self.assertFormError(
            response, 'form', 'recipient_username',
            'You cannot message yourself'
        )

    def test_blocked_user_cannot_message(self):
        # user2 blocks user1
        self.user2.message_settings.blocked_users.add(self.user1)

        self.client.force_login(self.user1)
        response = self.client.post(
            reverse('messaging:new_message'),
            {'recipient_username': 'user2', 'content': 'Blocked message'}
        )
        self.assertEqual(response.status_code, 200)
        self.assertFormError(
            response, 'form', 'recipient_username',
            'This user cannot receive messages from you'
        )
