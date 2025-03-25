from django.urls import path
from . import views

app_name = 'tutor'

urlpatterns = [
    path('', views.TutorListView.as_view(), name='tutor_list'),
    path('tutor-detail/instructor_<int:pk>/', views.TutorDetailView.as_view(), name='tutor_detail'),
    path('tutor-reserve/instructor_<int:pk>/', views.TutorReserveView.as_view(), name='tutor_reserve'),

    # ---------------------- TUTOR DASHBOARD
    path('dashboard/panel/', views.DTHome.as_view(), name='dt_home'),
    path('dashboard/manage-course/', views.DTManageCourse.as_view(), name='dt_manage_course'),
    path('dashboard/quiz/', views.DTQuiz.as_view(), name='dt_quiz'),
    path('dashboard/earning/', views.DTEarning.as_view(), name='dt_earning'),
    path('dashboard/student-list/', views.DTStudentList.as_view(), name='dt_student_list'),
    path('dashboard/order/', views.DTOrder.as_view(), name='dt_order'),
    path('dashboard/review/', views.DTReviews.as_view(), name='dt_reviews'),
    path('dashboard/edit-profile/<int:pk>/', views.DTEditProfile.as_view(), name='dt_edit'),
    path('dashboard/payout/', views.DTPayout.as_view(), name='dt_payout'),
    path('dashboard/setting/', views.DTSetting.as_view(), name='dt_setting'),
    path('dashboard/delete-account/<int:pk>/', views.DTDeleteAccount.as_view(), name='dt_delete_account'),

]