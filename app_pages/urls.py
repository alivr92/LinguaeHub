from django.urls import path, include
from app_pages import views

app_name = 'app_pages'

urlpatterns = [
    path('', views.Home.as_view(), name='home'),
    path('tutors/', include('ap2_tutor.urls')),
    path('about/', views.About.as_view(), name='about'),
    path('contact-us/', views.ContactUs.as_view(), name='contact_us'),
    # path('contact-us/', views.saveContactUs, name='save_contact_us'),
    path('blog/', views.Blog.as_view(), name='blog'),
    path('FAQ/', views.FAQ.as_view(), name='faq'),
    path('agb/', views.AGB.as_view(), name='agb'),
    path('become-tutor/', views.BecomeTutor.as_view(), name='become_tutor'),
    path('help-center/', views.HelpCenter.as_view(), name='help_center'),
    path('coming-soon/', views.ComingSoon.as_view(), name='coming_soon'),
    # path('services/', views.services, name='services'),
    # path('dashboard/', views.dashboard, name='dashboard'),

]