from django.urls import path
from . import views

app_name = 'payments'

urlpatterns = [
    # path('checkout/', views.Checkout.as_view(), name='checkout'),
    path('checkout/<bill_id>', views.checkout, name='checkout'),
    # path('payment/', views.Payment.as_view(), name='payment'),
    path('cart/', views.Cart.as_view(), name='cart'),
    # path('payment/', views.payment_view, name='payment_view'),
    path('create-payment-intent/', views.create_payment_intent, name='create_payment_intent'),

    path('payment-error/', views.payment_error, name='payment_error'),
    path('payment-success/', views.payment_success, name='payment_success'),
    path('payment-status/<bill_id>', views.payment_status, name='payment_status'),

    path('stripe_payment/<bill_id>', views.stripe_payment, name='stripe_payment'),
    path('stripe_payment_verify/<bill_id>', views.stripe_payment_verify, name='stripe_payment_verify'),

    path('', views.HomePageView.as_view(), name='home'),
    path('config/', views.stripe_config),
    path('create-checkout-session/', views.create_checkout_session),

]