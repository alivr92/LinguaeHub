from django.urls import path
from . import views

app_name = 'client'

urlpatterns = [

    # ---------------------- STUDENT DASHBOARD
    path('dashboard/panel/', views.DCHome.as_view(), name='dc_home'),
    path('dashboard/activation-required/', views.ActivationRequiredView.as_view(), name='activation_required'),
    path('dashboard/resend-activation/', views.ResendActivationView.as_view(), name='resend_activation'),

    path('dashboard/subscription/', views.DCSubscription.as_view(), name='dc_subscription'),
    path('dashboard/class-list/', views.DCClassList.as_view(), name='dc_class_list'),
    # path('dashboard/class-list/review-save/', views.ds_review_save, name='dc_review_save'),
    path('dashboard/course-resume/', views.DCCourseResume.as_view(), name='dc_course_resume'),
    path('dashboard/quiz/', views.DCQuiz.as_view(), name='dc_quiz'),
    path('dashboard/payment-info/', views.DCPaymentInfo.as_view(), name='dc_payment_info'),
    path('dashboard/bookmark/', views.DCBookmark.as_view(), name='dc_bookmark'),

    path('dashboard/edit/<int:pk>', views.DCEdit.as_view(), name='dc_edit'),
    path('dashboard/setting/', views.DCSetting.as_view(), name='dc_setting'),
    path('dashboard/in-person/', views.DCInPerson.as_view(), name='dc_in_person'),
    path('dashboard/delete-account/<int:pk>/', views.DCDeleteAccount.as_view(), name='dc_delete_account'),

    path('dashboard/resend-verification/', views.resend_verification, name='resend_verification'),
    # path('dashboard/save-location/', views.save_location, name='dc_save_location'),

    # path('wishlist/toggle/', views.toggle_wishlist, name='toggle_wishlist'),
]
