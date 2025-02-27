from django.urls import path
from app_accounts import views

app_name = 'accounts'

urlpatterns = [
    # AUTH
    # path('sign-in/', views.sign_in, name='sign_in'),
    path('sign-in/', views.SignInView.as_view(), name='sign_in'),
    path('sign-up/', views.UserSignUpView.as_view(), name='sign_up'),
    path('sign-out/', views.sign_out, name='sign_out'),

    # DASHBOARD
    path('dashboard/', views.dashboard, name='dashboard'),
    path('dashboard/edit/', views.dashboardEdit, name='d_edit'),

    # TUTORS
    path('dashboard/t/panel/', views.DTHomeView.as_view(), name='dt_home'),
    # path('dashboard/t/manage-course/', views.dt_manage_course, name='dt_manage_course'),
    # path('dashboard/t/quiz/', views.dt_quiz, name='dt_quiz'),
    # path('dashboard/t/earning/', views.dt_earning, name='dt_earning'),

    path('dashboard/t/studentlist/', views.DTStudentList.as_view(), name='dt_student_list'),
    # path('dashboard/t/order/', views.dt_order, name='dt_order'),
    # path('dashboard/t/review/', views.dt_review, name='dt_review'),
    path('dashboard/t/edit-profile/<int:pk>/', views.DTEditView.as_view(), name='dt_edit'),
    # path('dashboard/t/payout/', views.dt_payout, name='dt_payout'),
    path('dashboard/t/setting/', views.DTSettingView.as_view(), name='dt_settings'),
    # path('dashboard/t/delete-account/', views.dt_delete_account, name='dt_delete_account'),

    # STUDENTS
    path('dashboard/s/panel/', views.DSHomeView.as_view(), name='ds_home'),
    # path('dashboard/s/subscription/', views.DSSubscriptionView.as_view(), name='ds_subscription'),
    path('dashboard/s/class-list/', views.DSClassListView.as_view(), name='ds_class_list'),
    # path('dashboard/s/class-list/review-save/', views.ds_review_save, name='ds_review_save'),
    path('dashboard/s/course-resume/', views.DSCourseResumeView.as_view(), name='ds_course_resume'),
    # path('dashboard/s/quiz/', views.DSQuizView.as_view(), name='ds_quiz'),
    # path('dashboard/s/payment-info/', views.DSPaymentInfoView.as_view(), name='ds_payment_info'),
    # path('dashboard/s/bookmark/', views.DSBookmarkView.as_view(), name='ds_bookmark'),
    path('dashboard/s/edit-profile/', views.DSEditView.as_view(), name='ds_edit'),
    # path('dashboard/s/payout/', views.DSPayoutView.as_view(), name='ds_payout'),
    # path('dashboard/s/setting/', views.DSSettingView.as_view(), name='ds_setting'),
    # path('dashboard/s/delete-account/', views.DSDeleteAccountView.as_view(), name='ds_delete_account'),

    # STAFF
    # path('dashboard/stf/panel/', views.DStaffHomeView.as_view(), name='dstf_home'),

    # SUPERUSER
    path('dashboard/a/panel/', views.DAHomeView.as_view(), name='da_home'),
    # path('dashboard/admin/course-category/', views.da_course_category, name='da_course_category'),
    # path('dashboard/admin/course-list/', views.da_course_list, name='da_course_list'),
    # path('dashboard/admin/course-detail/', views.da_course_detail, name='da_course_detail'),
    # path('dashboard/admin/student-list/', views.da_student_list, name='da_student_list'),
    # path('dashboard/admin/instructor-list/', views.da_instructor_list, name='da_instructor_list'),
    # path('dashboard/admin/instructor-detail/', views.da_instructor_detail, name='da_instructor_detail'),
    # path('dashboard/admin/instructor-request/', views.da_instructor_request, name='da_instructor_request'),
    # path('dashboard/admin/review/', views.da_review, name='da_review'),
    # path('dashboard/admin/earning/', views.da_earning, name='da_earning'),
    path('dashboard/admin/settings/', views.DASettings.as_view(), name='da_settings'),
    # path('dashboard/admin/course/', views.da_course, name='da_course'),
]