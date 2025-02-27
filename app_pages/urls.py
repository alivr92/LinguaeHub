from django.urls import path, include
from app_pages import views

app_name = 'app_pages'

urlpatterns = [
    path('', views.home, name='home'),
    path('tutors/', include('ap2_tutor.urls')),
    # path('about/', views.about, name='about'),
    # path('services/', views.services, name='services'),
    # path('blog/', views.blog, name='blog'),
    # path('dashboard/', views.dashboard, name='dashboard'),

]