from django.urls import path
from . import views

app_name = 'shop'

urlpatterns = [
    path('main/', views.ServicesList.as_view(), name='service_list'),
    path('products/', views.ProductList.as_view(), name='products'),
    path('products/English-Concept/voices/', views.EnglishConceptVoices.as_view(), name='english_concept_voices'),
    path('products/English-Concept/active/', views.EnglishConceptActive.as_view(), name='english_concept_active'),
    path('products/English-Concept/passive/', views.EnglishConceptPassive.as_view(), name='english_concept_passive'),
    path('product-detail/<int:pk>/', views.ProductDetail.as_view(), name='product_detail'),
    # path('cart/', views.Cart.as_view(), name='cart'),
    path('checkout/', views.Checkout.as_view(), name='checkout'),



    # SHOP stripe payment
    path('book/<int:book_id>/', views.book_detail, name='book_detail'),
    path('cart/add/<int:book_id>/', views.add_to_cart, name='add_to_cart'),
    path('cart/', views.cart_view, name='cart_view'),
    path('create-checkout-session/', views.create_checkout_session, name='create_checkout_session'),
    path('payment-success/', views.payment_success, name='payment_success'),
    path('payment-cancelled/', views.payment_cancelled, name='payment_cancelled'),

]
