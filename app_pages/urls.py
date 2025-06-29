from django.urls import path, include
from app_pages import views

app_name = 'app_pages'

urlpatterns = [
    path('', views.Home.as_view(), name='home'),
    path('home2/', views.Home2.as_view(), name='home2'),
    path('about/', views.About.as_view(), name='about'),
    path('contact/', views.ContactUs.as_view(), name='contact_us'),
    # path('contact-us/', views.saveContactUs, name='save_contact_us'),
    # path('blog/', views.Blog.as_view(), name='blog'),
    path('FAQ/', views.FAQ.as_view(), name='faq'),
    path('agb/', views.AGB.as_view(), name='agb'),
    path('help-center/', views.HelpCenter.as_view(), name='help_center'),
    path('coming-soon/', views.ComingSoon.as_view(), name='coming_soon'),
    path('pricing/', views.Pricing.as_view(), name='pricing'),
    # path('services/', views.services, name='services'),
    # path('dashboard/', views.dashboard, name='dashboard'),

]