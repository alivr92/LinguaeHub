from django.urls import path
from ap2_tutor import views

app_name = 'tutor'

urlpatterns = [
    path('', views.TutorListView.as_view(), name='tutor_list'),
    path('tutor-detail/instructor_<int:pk>/', views.TutorDetailView.as_view(), name='tutor_detail'),
    path('tutor-reserve/instructor_<int:pk>/', views.TutorReserveView.as_view(), name='tutor_reserve'),

]