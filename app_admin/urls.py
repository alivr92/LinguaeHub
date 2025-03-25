from django.urls import path
from . import views

app_name = 'my_admin'

urlpatterns = [

    # ---------------------- SUPERUSER DASHBOARD
    path('dashboard/panel/', views.DAHome.as_view(), name='da_home'),
    path('dashboard/course-category/', views.DACourseCategory.as_view(), name='da_course_category'),
    path('dashboard/course-list/', views.DACourseList.as_view(), name='da_course_list'),
    path('dashboard/course-detail/<int:course_id>/', views.DACourseDetail.as_view(), name='da_course_detail'),
    path('dashboard/student-list/', views.DAStudentList.as_view(), name='da_student_list'),
    path('dashboard/tutor-list/', views.DATutorList.as_view(), name='da_tutor_list'),
    path('dashboard/tutor-detail/<int:tutor_id>/', views.DATutorDetail.as_view(), name='da_tutor_detail'),
    path('dashboard/tutor-request/', views.DATutorRequest.as_view(), name='da_tutor_request'),
    path('dashboard/review/', views.DAReview.as_view(), name='da_review'),
    path('dashboard/contact-us/', views.DAContactUs.as_view(), name='da_contact_us'),
    path('dashboard/earning/', views.DAEarning.as_view(), name='da_earning'),
    path('dashboard/settings/', views.DASettings.as_view(), name='da_settings'),
    path('dashboard/edit/<int:pk>', views.DAEdit.as_view(), name='da_edit'),

    # AJAX
    path('toggle-publish-status/', views.toggle_publish_status, name='toggle_publish_status'),
]
