from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.db.models import Sum, Q
from django.utils import timezone
from datetime import datetime, timedelta
import stripe
from .models import Wallet, Transaction, WithdrawalRequest
from decimal import Decimal
from django.views.generic import TemplateView


class ReportView(TemplateView):
    template_name = 'payment3/wallet/reports.html'


@login_required
def wallet_dashboard(request):
    wallet = get_object_or_404(Wallet, user=request.user)

    # Statistics
    today = timezone.now().date()
    month_start = today.replace(day=1)

    monthly_stats = Transaction.objects.filter(
        wallet=wallet,
        status='completed',
        created_at__gte=month_start
    ).aggregate(
        total_deposits=Sum('amount', filter=Q(transaction_type='deposit')),
        total_withdrawals=Sum('amount', filter=Q(transaction_type='withdrawal')),
        total_income=Sum('amount', filter=Q(transaction_type__in=['deposit', 'refund', 'bonus'])),
        total_expenses=Sum('amount', filter=Q(transaction_type__in=['withdrawal', 'purchase']))
    )

    # Recent transactions
    recent_transactions = Transaction.objects.filter(wallet=wallet)[:10]

    # Pending withdrawals
    pending_withdrawals = WithdrawalRequest.objects.filter(
        wallet=wallet,
        status__in=['pending', 'processing']
    )

    context = {
        'wallet': wallet,
        'monthly_stats': monthly_stats,
        'recent_transactions': recent_transactions,
        'pending_withdrawals': pending_withdrawals,
        'today': today,
    }

    return render(request, 'payment3/wallet/dashboard.html', context)

@login_required
def wallet_transactions(request):
    wallet = get_object_or_404(Wallet, user=request.user)

    # Filtering
    transaction_type = request.GET.get('type', '')
    status = request.GET.get('status', '')
    date_from = request.GET.get('date_from', '')
    date_to = request.GET.get('date_to', '')

    transactions = Transaction.objects.filter(wallet=wallet)

    if transaction_type:
        transactions = transactions.filter(transaction_type=transaction_type)
    if status:
        transactions = transactions.filter(status=status)
    if date_from:
        transactions = transactions.filter(created_at__gte=date_from)
    if date_to:
        transactions = transactions.filter(created_at__lte=date_to)

    transactions = transactions.order_by('-created_at')

    context = {
        'wallet': wallet,
        'transactions': transactions,
        'filters': {
            'type': transaction_type,
            'status': status,
            'date_from': date_from,
            'date_to': date_to,
        }
    }

    return render(request, 'payment3/wallet/transactions.html', context)

@login_required
def wallet_deposit(request):
    wallet = get_object_or_404(Wallet, user=request.user)

    if request.method == 'POST':
        amount = Decimal(request.POST.get('amount', 0))

        if amount < 1:
            return JsonResponse({'error': 'Minimum deposit amount is $1'}, status=400)

        try:
            checkout_session = stripe.checkout.Session.create(
                payment_method_types=['card'],
                line_items=[{
                    'price_data': {
                        'currency': 'usd',
                        'product_data': {
                            'name': 'Wallet Deposit',
                            'description': f'Add ${amount} to your wallet',
                        },
                        'unit_amount': int(amount * 100),
                    },
                    'quantity': 1,
                }],
                mode='payment',
                success_url=request.build_absolute_uri(
                    f'/wallet/deposit/success/?session_id={{CHECKOUT_SESSION_ID}}'
                ),
                cancel_url=request.build_absolute_uri('/wallet/deposit/'),
                metadata={
                    'user_id': request.user.id,
                    'type': 'wallet_deposit',
                    'amount': str(amount)
                }
            )

            # Create pending transaction
            Transaction.objects.create(
                wallet=wallet,
                amount=amount,
                transaction_type='deposit',
                status='pending',
                description=f'Wallet deposit of ${amount}',
                stripe_payment_intent_id=checkout_session.payment_intent,
                reference_id=checkout_session.id
            )

            return JsonResponse({'sessionId': checkout_session.id})

        except Exception as e:
            return JsonResponse({'error': str(e)}, status=400)

    return render(request, 'payment3/wallet/deposit.html', {'wallet': wallet})

@login_required
def wallet_withdraw(request):
    wallet = get_object_or_404(Wallet, user=request.user)

    if request.method == 'POST':
        amount = Decimal(request.POST.get('amount', 0))
        method = request.POST.get('method', 'bank_transfer')
        account_details = {
            'bank_name': request.POST.get('bank_name', ''),
            'account_number': request.POST.get('account_number', ''),
            'routing_number': request.POST.get('routing_number', ''),
        }

        # Validation
        if amount <= 0:
            return JsonResponse({'error': 'Invalid amount'}, status=400)

        if amount > wallet.balance:
            return JsonResponse({'error': 'Insufficient balance'}, status=400)

        # Create withdrawal request
        withdrawal = WithdrawalRequest.objects.create(
            wallet=wallet,
            amount=amount,
            method=method,
            account_details=account_details,
            notes=request.POST.get('notes', '')
        )

        # Create pending transaction
        Transaction.objects.create(
            wallet=wallet,
            amount=amount,
            transaction_type='withdrawal',
            status='pending',
            description=f'Withdrawal request #{withdrawal.id}',
            reference_id=str(withdrawal.id)
        )

        return JsonResponse({
            'success': True,
            'message': 'Withdrawal request submitted successfully',
            'withdrawal_id': withdrawal.id
        })

    return render(request, 'payment3/wallet/withdraw.html', {'wallet': wallet})