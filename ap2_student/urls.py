from django.urls import path
from . import views

app_name = 'student'

urlpatterns = [

    # ---------------------- STUDENT DASHBOARD
    path('dashboard/panel/', views.DSHome.as_view(), name='ds_home'),
    path('dashboard/activation-required/', views.ActivationRequiredView.as_view(), name='activation_required'),
    path('dashboard/resend-activation/', views.ResendActivationView.as_view(), name='resend_activation'),

    path('dashboard/subscription/', views.DSSubscription.as_view(), name='ds_subscription'),
    path('dashboard/class-list/', views.DSClassList.as_view(), name='ds_class_list'),
    # path('dashboard/class-list/review-save/', views.ds_review_save, name='ds_review_save'),
    path('dashboard/course-resume/', views.DSCourseResume.as_view(), name='ds_course_resume'),
    path('dashboard/quiz/', views.DSQuiz.as_view(), name='ds_quiz'),
    path('dashboard/payment-info/', views.DSPaymentInfo.as_view(), name='ds_payment_info'),
    path('dashboard/bookmark/', views.DSBookmark.as_view(), name='ds_bookmark'),

    path('dashboard/edit/<int:pk>', views.DSEdit.as_view(), name='ds_edit'),
    path('dashboard/setting/', views.DSSetting.as_view(), name='ds_setting'),
    path('dashboard/delete-account/<int:pk>/', views.DSDeleteAccount.as_view(), name='ds_delete_account'),

    path('dashboard/resend-verification/', views.resend_verification, name='resend_verification'),

    # path('wishlist/toggle/', views.toggle_wishlist, name='toggle_wishlist'),
]
