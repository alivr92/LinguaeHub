from django.urls import path
from app_accounts import views

app_name = 'accounts'

urlpatterns = [
    # AUTH
    # path('sign-in/', views.sign_in, name='sign_in'),
    path('sign-in/', views.SignInView.as_view(), name='sign_in'),
    path('sign-up/', views.UserSignUpView.as_view(), name='sign_up'),
    path('sign-out/', views.sign_out, name='sign_out'),

    # ---------------------- DASHBOARD
    path('dashboard/', views.dashboard, name='dashboard'),
    path('dashboard/edit/<int:pk>/', views.dashboardEdit, name='d_edit'),

]