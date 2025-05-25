from django.urls import path
from . import views
from django.conf.urls.static import static
from django.conf import settings

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
    path('dashboard/tutor-request/', views.DAProviderRequest.as_view(), name='da_tutor_request'),
    path('dashboard/review/', views.DAReview.as_view(), name='da_review'),
    path('dashboard/contact-us/', views.DAContactUs.as_view(), name='da_contact_us'),
    path('dashboard/earning/', views.DAEarning.as_view(), name='da_earning'),
    path('dashboard/settings/', views.DASettings.as_view(), name='da_settings'),
    path('dashboard/edit/<int:pk>', views.DAEdit.as_view(), name='da_edit'),

    # ---------------------- ADMIN SCHEDULE FOR INTERVIEW
    path('interview/', views.DAInterview.as_view(), name='da_interview'),

    # AJAX
    path('toggle-publish-status/', views.toggle_publish_status, name='toggle_publish_status'),
    path('update-applicant-status/<int:applicant_id>/', views.update_applicant_status, name='update_applicant_status'),
    path('set-video-call-link/<int:session_id>/', views.set_video_call_link, name='set_video_call_link'),

] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

