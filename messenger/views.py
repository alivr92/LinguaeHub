from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages as django_messages
from django.http import JsonResponse, HttpResponseBadRequest, HttpResponse
from django.utils import timezone
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
from django.db import transaction
from django.contrib.auth import get_user_model
from django.core.exceptions import PermissionDenied

from messenger.decorators import rate_limit_messages
from .models import Thread, Message, UserMessageSettings
from .forms import NewMessageForm, ReplyMessageForm


User = get_user_model()


@login_required
def inbox(request):
    threads = Thread.objects.filter(
        participants=request.user,
        is_active=True
    ).prefetch_related(
        'participants',
        'messages'
    ).order_by('-updated_at')

    return render(request, 'messenger/inbox.html', {
        'threads': threads,
        'unread_count': Message.objects.filter(
            recipient=request.user,
            is_read=False
        ).count()
    })


@rate_limit_messages
@login_required
def thread_detail(request, thread_id):
    thread = get_object_or_404(
        Thread.objects.prefetch_related('participants', 'messages'),
        id=thread_id,
        participants=request.user,
        is_active=True
    )

    if request.method == 'POST':
        form = ReplyMessageForm(request.POST)
        if form.is_valid():
            with transaction.atomic():
                message = form.save(commit=False)
                message.thread = thread
                message.sender = request.user
                message.recipient = thread.get_other_participant(request.user)
                message.save()

                # Update thread's updated_at
                thread.save()

                django_messages.success(request, "Message sent successfully")
                return redirect('messaging:thread_detail', thread_id=thread.id)
    else:
        form = ReplyMessageForm()

        # Mark messages as read when viewing thread
        Message.objects.filter(
            thread=thread,
            recipient=request.user,
            is_read=False
        ).update(is_read=True, read_at=timezone.now())

    return render(request, 'messenger/thread_detail.html', {
        'thread': thread,
        'form': form,
        'other_user': thread.get_other_participant(request.user)
    })


@rate_limit_messages
@login_required
def new_message(request):
    if request.method == 'POST':
        form = NewMessageForm(request.POST, sender=request.user)
        if form.is_valid():
            recipient = form.cleaned_data['recipient_username']
            content = form.cleaned_data['content']

            with transaction.atomic():
                # Find or create thread
                thread, created = Thread.objects.get_or_create_for_users(
                    request.user, recipient
                )

                # Create message
                Message.objects.create(
                    thread=thread,
                    sender=request.user,
                    recipient=recipient,
                    content=content
                )

                django_messages.success(request, "Message sent successfully")
                return redirect('messaging:inbox')
    else:
        form = NewMessageForm(sender=request.user)

    return render(request, 'messenger/new_message.html', {
        'form': form
    })


@login_required
@require_http_methods(["POST"])
def check_username(request):
    username = request.POST.get('recipient_username', '').strip()
    if not username:
        return HttpResponseBadRequest("Username is required")

    try:
        user = User.objects.get(username=username)
    except User.DoesNotExist:
        return JsonResponse({
            'valid': False,
            'message': 'User not found'
        })

    if user == request.user:
        return JsonResponse({
            'valid': False,
            'message': 'You cannot message yourself'
        })

    if not user.message_settings.can_receive_message_from(request.user):
        return JsonResponse({
            'valid': False,
            'message': 'This user cannot receive messages from you'
        })

    return JsonResponse({
        'valid': True,
        'message': f'Found user: {user.get_full_name() or user.username}'
    })


@login_required
def delete_thread(request, thread_id):
    thread = get_object_or_404(
        Thread,
        id=thread_id,
        participants=request.user
    )

    if request.method == 'POST':
        # For 1:1 chats, we can deactivate the thread
        if thread.participants.count() == 2:
            thread.is_active = False
            thread.save()
        else:
            # For group chats, remove the user from participants
            thread.participants.remove(request.user)

        django_messages.success(request, "Conversation deleted")
        return redirect('messaging:inbox')

    return render(request, 'messenger/confirm_delete.html', {
        'thread': thread
    })


# Add these methods to Thread model
@classmethod
def get_or_create_for_users(cls, user1, user2):
    """
    Find or create a thread between two users.
    Ensures there's only one active thread between any two users.
    """
    threads = cls.objects.filter(participants=user1).filter(participants=user2).filter(is_active=True)
    if threads.exists():
        return threads.first(), False

    with transaction.atomic():
        thread = cls.objects.create()
        thread.participants.add(user1, user2)
        return thread, True


@csrf_exempt
def email_tracker(request, message_id):
    Message.objects.filter(id=message_id).update(opened_at=timezone.now())
    # Return 1x1 transparent pixel
    pixel = b'\x47\x49\x46\x38\x39\x61\x01\x00\x01\x00\x80\x00\x00\xff\xff\xff\x00\x00\x00\x21\xf9\x04\x01\x00\x00\x00\x00\x2c\x00\x00\x00\x00\x01\x00\x01\x00\x00\x02\x02\x44\x01\x00\x3b'
    return HttpResponse(pixel, content_type='image/gif')