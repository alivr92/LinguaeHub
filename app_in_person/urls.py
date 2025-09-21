from django.urls import path
from . import views

app_name = 'in_person'

urlpatterns = [
    # Admin action URL (typically used in admin interface)
    path('send-email-tutor/<int:user_id>/', views.inp_send_email_tutor, name='inp_send_email_tutor'),

    # Public-facing URLs for tutors to respond to offers (using token authentication)
    path('offer/accept/<str:token>/', views.accept_offer, name='inp_accept_offer'),
    path('offer/decline/<str:token>/', views.decline_offer, name='inp_decline_offer'),

    # path('tutor/appointments/', views.tutor_appointments, name='tutor_appointments'),
    path('tutor/appointments/stats/', views.tutor_appointments_stats, name='tutor_appointments_stats'),
    # path('appointments/<int:appointment_id>/complete/', views.complete_session, name='complete_session'),
    # path('appointments/<int:appointment_id>/reschedule/', views.reschedule_session, name='reschedule_session'),

]