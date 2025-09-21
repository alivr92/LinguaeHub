from django import forms
from django.contrib.auth import get_user_model
from .models import Message, Thread

User = get_user_model()


class NewMessageForm(forms.Form):
    recipient_username = forms.CharField(
        label="Recipient",
        max_length=150,
        widget=forms.TextInput(attrs={
            'placeholder': 'Enter username',
            'class': 'form-control',
            'hx-post': '/messaging/check_username/',
            'hx-trigger': 'keyup changed delay:500ms',
            'hx-target': '#username-feedback'
        })
    )
    content = forms.CharField(
        label="Message",
        widget=forms.Textarea(attrs={
            'rows': 3,
            'class': 'form-control',
            'placeholder': 'Type your message here...'
        })
    )

    def __init__(self, *args, sender=None, **kwargs):
        self.sender = sender
        super().__init__(*args, **kwargs)

    def clean_recipient_username(self):
        username = self.cleaned_data['recipient_username']
        try:
            recipient = User.objects.get(username=username)
        except User.DoesNotExist:
            raise forms.ValidationError("User with this username does not exist")

        if recipient == self.sender:
            raise forms.ValidationError("You cannot send a message to yourself")

        # Check recipient's message settings
        if not recipient.message_settings.can_receive_message_from(self.sender):
            raise forms.ValidationError("This user cannot receive messages from you")

        return recipient


class ReplyMessageForm(forms.ModelForm):
    class Meta:
        model = Message
        fields = ['content']
        widgets = {
            'content': forms.Textarea(attrs={
                'rows': 3,
                'class': 'form-control',
                'placeholder': 'Type your reply here...'
            })
        }
