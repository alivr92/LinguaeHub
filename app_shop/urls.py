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
    path('cart/', views.Cart.as_view(), name='cart'),
    path('checkout/', views.Checkout.as_view(), name='checkout'),

]
