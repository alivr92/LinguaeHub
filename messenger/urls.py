from django.urls import path
from messenger import views

app_name = 'messenger'

urlpatterns = [
    path('', views.inbox, name='inbox'),
    path('new/', views.new_message, name='new_message'),
    path('thread/<int:thread_id>/', views.thread_detail, name='thread_detail'),
    path('thread/<int:thread_id>/delete/', views.delete_thread, name='delete_thread'),
    path('check_username/', views.check_username, name='check_username'),
    path('track/email/<int:message_id>/', views.email_tracker, name='email_tracker'),
]