from django.urls import path
from app_accounts import views

app_name = 'accounts'

urlpatterns = [
    # AUTH
    # path('sign-in/', views.sign_in, name='sign_in'),
    path('sign-in/', views.SignInView.as_view(), name='sign_in'),
    path('sign-up/student/', views.SignUpStudent.as_view(), name='sign_up'),
    path('sign-up/tutor/', views.SignUpTutor.as_view(), name='sign_up_tutor'),
    path('sign-up/staff/', views.SignUpStaff.as_view(), name='sign_up_staff'),
    path('sign-out/', views.sign_out, name='sign_out'),
    path('verify-email/', views.VerifyEmailView.as_view(), name='verify_email'),
    path('resend-verification/', views.ResendVerificationView.as_view(), name='resend_verification'),
    # path('check-email/', views.CheckValidityView.as_view(), name='check_validity'),

    path('forgot-password/', views.ForgetPasswordView.as_view(), name='forget_password'),
    path('reset-password/', views.PasswordResetConfirmView.as_view(), name='password_reset_confirm'),

    # Add error pages
    path('error/', views.error_page, name='error_page'),
    # path('error-invalid-invite/', views.ErrorInvalidInvite.as_view(), name='error_invalid_invite'),
    # path('error-expired-invite/', views.ErrorExpiredInvite.as_view(), name='error_expired_invite'),
    # path('error-already-registered/', views.ErrorAlreadyRegistered.as_view(), name='error_already_registered'),

    # ---------------------- DASHBOARD
    path('dashboard/', views.dashboard, name='dashboard'),
    path('dashboard/edit/<int:pk>/', views.dashboardEdit, name='d_edit'),

]
