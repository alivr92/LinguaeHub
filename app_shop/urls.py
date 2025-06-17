from django.urls import path
from . import views

app_name = 'shop'

urlpatterns = [
    path('products/', views.ProductList.as_view(), name='products'),
    path('product-detail/<int:pk>/', views.ProductDetail.as_view(), name='product_detail'),
    path('cart/', views.Cart.as_view(), name='cart'),
    path('checkout/', views.Checkout.as_view(), name='checkout'),

]
