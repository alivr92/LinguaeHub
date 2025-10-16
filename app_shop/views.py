from django.shortcuts import render
from django.views.generic import TemplateView, FormView, ListView, DetailView

# test for stripe :
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
import stripe
from .models import Book, Cart, CartItem, Order, OrderItem
from django.conf import settings


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


# class Cart(TemplateView):
#     template_name = 'app_shop/cart.html'


class Checkout(TemplateView):
    template_name = 'app_shop/checkout.html'


# Test for stirpe
stripe.api_key = settings.STRIPE_SECRET_KEY

def book_detail(request, book_id):
    book = get_object_or_404(Book, id=book_id)
    return render(request, 'book_detail.html', {'book': book})

@login_required
def add_to_cart(request, book_id):
    book = get_object_or_404(Book, id=book_id)
    cart, created = Cart.objects.get_or_create(user=request.user)

    cart_item, created = CartItem.objects.get_or_create(
        cart=cart,
        book=book,
        defaults={'quantity': 1}
    )

    if not created:
        cart_item.quantity += 1
        cart_item.save()

    return redirect('cart_view')

@login_required
def cart_view(request):
    cart, created = Cart.objects.get_or_create(user=request.user)
    total = sum(item.total_price() for item in cart.items.all())
    return render(request, 'app_shop/cart2.html', {'cart': cart, 'total': total})



# Initialize Stripe
stripe.api_key = settings.STRIPE_SECRET_KEY

def create_checkout_session(request):
    if request.method == 'POST':
        try:
            # Get cart items from session or database
            cart_items = [
                {
                    'name': 'Book: HTML and CSS',
                    'amount': 2150,  # $21.50 in cents
                    'quantity': 1
                }
            ]

            checkout_session = stripe.checkout.Session.create(
                payment_method_types=['card'],
                line_items=cart_items,
                mode='payment',
                success_url=request.build_absolute_uri('/payment-success/'),
                cancel_url=request.build_absolute_uri('/payment-cancelled/'),
                metadata={
                    'user_id': request.user.id if request.user.is_authenticated else 'anonymous'
                }
            )

            return JsonResponse({'sessionId': checkout_session.id})

        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)

def payment_success(request):
    return render(request, 'payment3/success.html')

def payment_cancelled(request):
    return render(request, 'payment3/cancelled.html')

@csrf_exempt
def stripe_webhook(request):
    payload = request.body
    sig_header = request.META['HTTP_STRIPE_SIGNATURE']

    try:
        event = stripe.Webhook.construct_event(
            payload, sig_header, settings.STRIPE_WEBHOOK_SECRET
        )
    except ValueError as e:
        # Invalid payload
        return JsonResponse({'error': 'Invalid payload'}, status=400)
    except stripe.error.SignatureVerificationError as e:
        # Invalid signature
        return JsonResponse({'error': 'Invalid signature'}, status=400)

    # Handle the checkout.session.completed event
    if event['type'] == 'checkout.session.completed':
        session = event['data']['object']

        # Handle successful payment here
        # Update order status, send email, etc.
        print(f"Payment successful for session: {session.id}")

    return JsonResponse({'status': 'success'})