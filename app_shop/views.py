from django.shortcuts import render
from django.views.generic import TemplateView, FormView, ListView, DetailView


class ServicesList(TemplateView):
    template_name = 'app_shop/service_list.html'


class ProductList(TemplateView):
    template_name = 'app_shop/shop.html'


class EnglishConceptVoices(TemplateView):
    template_name = 'app_shop/EnglishConcept/voices.html'


class EnglishConceptActive(TemplateView):
    template_name = 'app_shop/EnglishConcept/active.html'


class EnglishConceptPassive(TemplateView):
    template_name = 'app_shop/EnglishConcept/passive.html'


class ProductDetail(TemplateView):
    template_name = 'app_shop/shop-product-detail.html'


class Cart(TemplateView):
    template_name = 'app_shop/cart.html'


class Checkout(TemplateView):
    template_name = 'app_shop/checkout.html'
