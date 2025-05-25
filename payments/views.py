from django.shortcuts import render, redirect
from django.urls import reverse
from django.contrib.auth.decorators import login_required
from django.views.generic import TemplateView
import stripe
from django.conf import settings
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from .forms import PaymentForm
# from .models import Bill
from ap2_tutor.models import PNotification
from ap2_student.models import CNotification
import logging


# class Checkout(TemplateView):
#     template_name = 'payments/checkout.html'
#
#     def get_context_data(self, **kwargs):
#         context = super().get_context_data(**kwargs)
#         bill = Bill.objects.get(bill_id=self.request)
#         context['bill'] = bill
#         context['stripe_public_key'] = settings.STRIPE_PUBLISHABLE_KEY
#         context['stripe_secret_key'] = settings.STRIPE_SECRET_KEY
#         return context


def checkout(request, bill_id):
    bill = Bill.objects.get(bill_id=bill_id)
    context = {
        'bill': bill,
        'stripe_public_key': settings.STRIPE_PUBLISHABLE_KEY,
        'stripe_secret_key': settings.STRIPE_SECRET_KEY,
    }
    return render(request, 'payments/checkout2.html', context)


class Cart(TemplateView):
    template_name = 'payments/cart.html'


@csrf_exempt
def payment_view(request):
    if request.method == 'POST':
        form = PaymentForm(request.POST)
        if form.is_valid():
            stripe_token = form.cleaned_data['stripeToken']
            try:
                charge = stripe.Charge.create(
                    amount=5000,  # amount in cents
                    currency='usd',
                    description='Example charge',
                    source=stripe_token
                )
                return redirect('payments:payment_success')
            except stripe.error.StripeError:
                return redirect('payments:payment_error')
    else:
        form = PaymentForm()
    return render(request, 'payments/payment.html', {'form': form})


def payment_success(request):
    context = {}
    return render(request, 'payments/pay_success.html', context)


def payment_error(request):
    context = {}
    return render(request, 'payments/pay_error.html', context)


# def checkout(request, bill_id):
#     bill = Bill.objects.get(bill_id=bill_id)
#     context = {
#         'bill': bill,
#         'stripe_public_key': settings.STRIPE_PUBLISHABLE_KEY,
#         'stripe_secret_key': settings.STRIPE_SECRET_KEY,
#
#     }
#     return render(request, 'payments/checkout.html', context)

# views.py

stripe.api_key = settings.STRIPE_SECRET_KEY


@csrf_exempt
def create_payment_intent(request):
    if request.method == 'POST':
        try:
            # Get the amount from the request (e.g., from a form or API call)
            amount = int(request.POST.get('amount'))  # Amount in cents

            # Create a PaymentIntent
            intent = stripe.PaymentIntent.create(
                amount=amount,
                currency='usd',  # Change to your preferred currency
                metadata={'integration_check': 'accept_a_payment'},
            )

            # Return the client secret to the frontend
            return JsonResponse({'client_secret': intent.client_secret})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request method'}, status=400)


# @csrf_exempt
# def stripe_payment(request, bill_id):
#     try:
#         bill = Bill.objects.get(bill_id=bill_id)
#         stripe.api_key = settings.STRIPE_SECRET_KEY
#
#         logger.info(f"Creating checkout session for bill_id: {bill_id}")
#
#         checkout_session = stripe.checkout.Session.create(
#             customer_email=bill.client.profile.user.email,
#             payment_method_types=['card'],
#             line_items=[
#                 {
#                     'price_data': {
#                         'currency': 'USD',
#                         'product_data': {
#                             'name': bill.client.profile.user.first_name,
#                         },
#                         'unit_amount': int(bill.total * 100)
#                     },
#                     'quantity': 1
#                 }
#             ],
#             mode='payment',
#             success_url=request.build_absolute_uri(reverse('payments:stripe_payment_verify',
#                                                            args=[bill.bill_id])) + "?session_id={CHECKOUT_SESSION_ID}",
#             cancel_url=request.build_absolute_uri(reverse('payments:stripe_payment_verify', args=[bill.bill_id])) + "?session_id={CHECKOUT_SESSION_ID}"
#         )
#
#         logger.info(f"Checkout session created: {checkout_session.id}")
#
#         return JsonResponse({"sessionId": checkout_session.id})
#     except Exception as e:
#         logger.error(f"Error in stripe_payment view: {str(e)}")
#         return JsonResponse({"error": str(e)}, status=500)

# @csrf_exempt
# def stripe_payment(request, bill_id):
#     bill = Bill.objects.get(bill_id=bill_id)
#     stripe.api_key = settings.STRIPE_SECRET_KEY
#
#     checkout_session = stripe.checkout.Session.create(
#         customer_email=bill.client.profile.user.email,
#         payment_method_types=['card'],
#         line_items=[
#             {
#                 'price_data': {
#                     'currency': 'USD',
#                     'product_data': {
#                         'name': bill.client.profile.user.first_name,
#                     },
#                     'unit_amount': int(bill.total * 100)
#                 },
#                 'quantity': 1
#             }
#         ],
#         mode='payment',
#         success_url=request.build_absolute_uri(reverse('payments:stripe_payment_verify',
#                                                        args=[bill.bill_id])) + "?session_id={CHECKOUT_SESSION_ID}",
#         cancel_url=request.build_absolute_uri(reverse('payments:stripe_payment_verify', args=[bill.bill_id])) + "?session_id={CHECKOUT_SESSION_ID}"
#     )
#
#     return JsonResponse({"sessionId": checkout_session.id})


# def stripe_payment_verify(request, bill_id):
#     bill = Bill.objects.get(bill_id=bill_id)
#     session_id = request.GET.get('session_id')
#     session = stripe.checkout.Session.retrieve(session_id)
#
#     if session.payment_status == 'paid':
#         if bill.status == 'unpaid':
#             bill.status = 'paid'
#             bill.save()
#
#             bill.appointment.status = 'scheduled'
#             bill.appointment.save()
#
#             PNotification.objects.create(
#                 provider=bill.appointment.tutor,
#                 appointment=bill.appointment,
#                 type='new_appointment',
#             )
#
#             CNotification.objects.create(
#                 client=bill.appointment.students,
#                 appointment=bill.appointment,
#                 type='appointment_scheduled',
#             )
#
#             return redirect(f'payment_status/{bill.bill_id}/?payment_status=paid')
#     else:
#         return redirect(f'payment_status/{bill.bill_id}/?payment_status=failed')


# @login_required
# def payment_status(request, bill_id):
#     bill = Bill.objects.get(bill_id=bill_id)
#     payment_status = request.GET.get('payment_status')
#
#     context = {
#         'bill': bill,
#         'payment_status': payment_status,
#     }
#
#     return render(request, 'payments/payment_status.html', context)


stripe.api_key = settings.STRIPE_SECRET_KEY


@csrf_exempt
def stripe_payment(request, bill_id):
    try:
        # Create a Stripe Checkout Session
        checkout_session = stripe.checkout.Session.create(
            payment_method_types=['card'],
            line_items=[
                {
                    'price_data': {
                        'currency': 'usd',
                        'product_data': {
                            'name': 'Test Product',  # Replace with your product name
                        },
                        'unit_amount': 10000,  # Amount in cents ($100.00)
                    },
                    'quantity': 1,
                },
            ],
            mode='payment',
            success_url=request.build_absolute_uri(
                reverse('payments:stripe_payment_verify', args=[bill_id])) + "?session_id={CHECKOUT_SESSION_ID}",
            cancel_url=request.build_absolute_uri(
                reverse('payments:stripe_payment_verify', args=[bill_id])) + "?session_id={CHECKOUT_SESSION_ID}",
        )
        return JsonResponse({"sessionId": checkout_session.id})
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


def stripe_payment_verify(request, bill_id):
    session_id = request.GET.get('session_id')
    if not session_id:
        return redirect(f'payment_status/{bill_id}/?payment_status=failed')

    try:
        # Retrieve the Stripe session
        session = stripe.checkout.Session.retrieve(session_id)
        if session.payment_status == 'paid':
            # Update your database or perform other actions here
            return redirect(f'payment_status/{bill_id}/?payment_status=paid')
        else:
            return redirect(f'payment_status/{bill_id}/?payment_status=failed')
    except Exception as e:
        return redirect(f'payment_status/{bill_id}/?payment_status=failed')


@login_required
def payment_status(request, bill_id):
    payment_status = request.GET.get('payment_status')
    context = {
        'bill_id': bill_id,
        'payment_status': payment_status,
    }
    return render(request, 'payments/payment_status.html', context)


# class HomePageView(TemplateView):
#     template_name = 'payments/home.html'
#
#
# @csrf_exempt
# def stripe_config(request):
#     if request.method == 'GET':
#         stripe_config = {'publicKey': settings.STRIPE_PUBLISHABLE_KEY}
#         print(f'public_key: ', settings.STRIPE_PUBLISHABLE_KEY)
#         return JsonResponse(stripe_config, safe=False)


# @csrf_exempt
# def create_checkout_session(request):
#     if request.method == 'POST':
#         domain_url = 'http://localhost:8000/'
#         stripe.api_key = settings.STRIPE_SECRET_KEY
#         try:
#             # Create new Checkout Session for the order
#             # Other optional params include:
#             # [billing_address_collection] - to display billing address details on the page
#             # [customer] - if you have an existing Stripe Customer ID
#             # [payment_intent_data] - capture the payment later
#             # [customer_email] - prefill the email input in the form
#             # For full details see https://stripe.com/docs/api/checkout/sessions/create
#
#             # ?session_id={CHECKOUT_SESSION_ID} means the redirect will have the session ID set as a query param
#             checkout_session = stripe.checkout.Session.create(
#                 success_url=domain_url + 'success?session_id={CHECKOUT_SESSION_ID}',
#                 cancel_url=domain_url + 'cancelled/',
#                 payment_method_types=['card'],
#                 mode='payment',
#                 # line_items=[{
#                 #         'name': 'T-shirt',
#                 #         'quantity': 1,
#                 #         'currency': 'usd',
#                 #         'amount': 2000, # amount in cents
#                 #     }]
#                 line_items=[{
#                     'price_data': {
#                         'currency': 'usd',
#                         'product_data': {
#                             'name': 'T-shirt',
#                         },
#                         'unit_amount': 2000,  # amount in cents
#                     },
#                     'quantity': 1,
#                 }],
#             )
#             return JsonResponse({'sessionId': checkout_session['id']})
#         except Exception as e:
#             return JsonResponse({'error': str(e)})

#
# @csrf_exempt
# def create_checkout_session(request):
#     if request.method == 'POST':
#         domain_url = 'http://localhost:8000/'
#         stripe.api_key = settings.STRIPE_SECRET_KEY
#         try:
#             logger.info('Creating checkout session')
#             checkout_session = stripe.checkout.Session.create(
#                 success_url=domain_url + 'success?session_id={CHECKOUT_SESSION_ID}',
#                 cancel_url=domain_url + 'cancelled/',
#                 payment_method_types=['card'],
#                 mode='payment',
#                 line_items=[{
#                     'price_data': {
#                         'currency': 'usd',
#                         'product_data': {
#                             'name': 'bag',
#                         },
#                         'unit_amount': 1200,
#                     },
#                     'quantity': 1,
#                 }],
#             )
#             logger.info('Checkout session created: %s', checkout_session)
#             return JsonResponse({'sessionId': checkout_session['id']})
#         except Exception as e:
#             logger.error('Error creating checkout session: %s', e)
#             return JsonResponse({'error': str(e)})


logger = logging.getLogger(__name__)


class HomePageView(TemplateView):
    template_name = 'payments/home.html'


@csrf_exempt
def stripe_config(request):
    if request.method == 'GET':
        stripe_config = {'publicKey': settings.STRIPE_PUBLISHABLE_KEY}
        logger.info(f'Public key: {settings.STRIPE_PUBLISHABLE_KEY}')
        return JsonResponse(stripe_config, safe=False)


@csrf_exempt
def create_checkout_session(request):
    if request.method == 'POST':
        domain_url = 'http://localhost:8000/'
        stripe.api_key = settings.STRIPE_SECRET_KEY
        try:
            logger.info('Creating checkout session')
            checkout_session = stripe.checkout.Session.create(
                success_url=domain_url + 'success?session_id={CHECKOUT_SESSION_ID}',
                cancel_url=domain_url + 'cancelled/',
                payment_method_types=['card'],
                mode='payment',
                line_items=[{
                    'price_data': {
                        'currency': 'usd',
                        'product_data': {
                            'name': 'bag',  # Product name
                        },
                        'unit_amount': 1200,  # Amount in cents ($12.00)
                    },
                    'quantity': 1,
                }],
            )
            logger.info(f'Checkout session created: {checkout_session.id}')
            return JsonResponse({'sessionId': checkout_session.id})
        except stripe.error.StripeError as e:
            logger.error(f'Stripe error creating checkout session: {e}')
            return JsonResponse({'error': str(e)}, status=400)
        except Exception as e:
            logger.error(f'Unexpected error creating checkout session: {e}')
            return JsonResponse({'error': 'An unexpected error occurred'}, status=500)
