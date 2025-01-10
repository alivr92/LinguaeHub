from django.urls import path
from pages import views

app_name = 'pages'

urlpatterns = [
    path('', views.home, name='home'),
    path('teachers/', views.teachers, name='teachers'),
    path('about/', views.about, name='about'),
    path('services/', views.services, name='services'),
    path('blog/', views.blog, name='blog'),

]