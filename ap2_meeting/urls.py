from django.urls import path
from ap2_meeting import views

app_name = 'meeting'

urlpatterns = [
    path('reserve-sessions/', views.reservation_single_client, name='reservation_single_client'),
    path('save-available-provider-times/', views.save_available_provider_times, name='save_available_provider_times'),
    # path('save-availability/', views.save_availability, name='save_availability'),

    # path('reserve-group-class/', views.reserve_sessions_multi_students, name='reserve_sessions_multi_students'),
    path('dashboard/', views.dashboard, name='dashboard'),
    path('success/', views.SuccessSubmitView.as_view(), name='success_submit'),
    # path('get-availability/', views.get_availability, name='get_availability'),
    path('get-available-rules/', views.get_available_rules, name='get_available_rules'),
    path('save-available-rule-times/', views.save_available_rule_times, name='save_available_rule_times'),
    path('get-booked/', views.get_booked_sessions, name='get_booked_sessions'),
    path('fetch-appointment-settings/', views.fetch_appointment_settings, name='fetch_appointment_settings'),

    path('dashboard/appointments/manual/', views.DAppointments.as_view(), name='d_appointments'),
    # path('dashboard/appointments/manual/week/<str:direction>/', views.navigate_week, name='navigate_week'),
    path('dashboard/appointments/edit/', views.DAppointmentsEdit.as_view(), name='d_appointments_edit'),
    path('dashboard/appointments/vtable/', views.DAppointmentsVTable.as_view(), name='d_appointments_vtable'),
    path('dashboard/appointments/settings/', views.DAppointmentsSettings.as_view(), name='d_appointments_settings'),

]
