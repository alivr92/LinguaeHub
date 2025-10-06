from django.urls import path
from . import views

app_name = 'staff'

urlpatterns = [

    # ---------------------- STAFF DASHBOARD
    path('dashboard/panel/', views.DSTFHome.as_view(), name='dstf_home'),
    path('dashboard/edit/<int:pk>', views.DSTFEdit.as_view(), name='dstf_edit'),
    path('dashboard/course-category/', views.DSTFCourseCategory.as_view(), name='dstf_course_category'),
    path('dashboard/course-list/', views.DSTFCourseList.as_view(), name='dstf_course_list'),
    path('dashboard/course-detail/<int:course_id>/', views.DSTFCourseDetail.as_view(), name='dstf_course_detail'),
    path('dashboard/student-list/', views.DSTFStudentList.as_view(), name='dstf_student_list'),
    path('dashboard/tutor-list/', views.DSTFTutorList.as_view(), name='dstf_tutor_list'),
    path('dashboard/tutor-detail/<int:tutor_id>/', views.DSTFTutorDetail.as_view(), name='dstf_provider_detail'),
    path('dashboard/tutor-request/', views.DSTFTutorRequest.as_view(), name='dstf_tutor_request'),
    path('dashboard/review/', views.DSTFReview.as_view(), name='dstf_review'),

]
