from django.urls import path
from . import views

app_name = 'vcard'

urlpatterns = [
    path('<slug:slug>/', views.vcard_page, name='vcard_page'),
    path('<slug:slug>/qr/', views.generate_qr_code, name='generate_qr_code'),
    path('<slug:slug>/track/', views.track_interaction, name='track_interaction'),
    path('<slug:slug>/analytics/', views.analytics_dashboard, name='analytics_dashboard'),
]