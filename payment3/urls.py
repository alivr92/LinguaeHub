from django.urls import path
from . import views

app_name = 'payment3'

urlpatterns = [
    path('wallet/main/', views.wallet_dashboard, name='wallet_dashboard'),
    path('wallet/transactions/', views.wallet_transactions, name='wallet_transactions'),
    path('wallet/deposit/', views.wallet_deposit, name='wallet_deposit'),
    # path('wallet/deposit/success/', views.wallet_deposit_success, name='wallet_deposit_success'),
    path('wallet/withdraw/', views.wallet_withdraw, name='wallet_withdraw'),
    path('wallet/report/', views.ReportView.as_view(), name='wallet_report'),
]