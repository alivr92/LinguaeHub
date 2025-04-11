from django import forms
from .models import Comment


class CommentForm(forms.ModelForm):
    name = forms.CharField(max_length=100, required=True,
                           widget=forms.TextInput(attrs={'class': 'form-control', }))
    email = forms.CharField(max_length=100, required=True,
                           widget=forms.EmailInput(attrs={'class': 'form-control',}))
    message = forms.CharField(max_length=450, required=True,
                           widget=forms.Textarea(attrs={'class': 'form-control', 'required': 'required', 'rows': 3}))

    class Meta:
        model = Comment
        fields = ['wp_post_id', 'wp_post_title', 'name', 'email', 'message']

        # widgets = {
        #     'name': forms.TextInput(attrs={'class': 'form-control', 'required': 'required', }),
        #     'email': forms.EmailInput(attrs={'class': 'form-control', 'required': 'required', }),
        #     'message': forms.Textarea(attrs={'class': 'form-control', 'required': 'required', 'rows': 3}),
        # }
