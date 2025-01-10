from django.urls import path
from tutors import views

app_name = 'tutors'

urlpatterns=[
    path('', views.tutor_list, name='tutor_list')
]