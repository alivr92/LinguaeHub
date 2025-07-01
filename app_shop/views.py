from django.shortcuts import render
from django.views.generic import TemplateView, FormView, ListView, DetailView


class ProductList(TemplateView):
    template_name = 'app_shop/shop.html'


class ProductDetail(TemplateView):
    template_name = 'app_shop/shop-product-detail.html'


class Cart(TemplateView):
    template_name = 'app_shop/cart.html'


class Checkout(TemplateView):
    template_name = 'app_shop/checkout.html'
