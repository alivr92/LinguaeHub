from django.db import models
from django.contrib.auth.models import User
from django.core.validators import MinValueValidator
from decimal import Decimal
import uuid
from django.utils import timezone


class Wallet(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    balance = models.DecimalField(max_digits=15, decimal_places=2, default=0)
    currency = models.CharField(max_length=3, default='USD')
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.user.username}'s Wallet"


class Transaction(models.Model):
    TRANSACTION_TYPES = (
        ('deposit', 'Deposit'),
        ('withdrawal', 'Withdrawal'),
        ('purchase', 'Purchase'),
        ('refund', 'Refund'),
        ('transfer', 'Transfer'),
        ('commission', 'Commission'),
        ('bonus', 'Bonus'),
    )

    TRANSACTION_STATUS = (
        ('pending', 'Pending'),
        ('completed', 'Completed'),
        ('failed', 'Failed'),
        ('cancelled', 'Cancelled'),
    )

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    wallet = models.ForeignKey(Wallet, on_delete=models.CASCADE, related_name='transactions')
    amount = models.DecimalField(max_digits=15, decimal_places=2)
    transaction_type = models.CharField(max_length=20, choices=TRANSACTION_TYPES)
    status = models.CharField(max_length=20, choices=TRANSACTION_STATUS, default='pending')
    description = models.TextField()
    reference_id = models.CharField(max_length=100, blank=True)
    stripe_payment_intent_id = models.CharField(max_length=100, blank=True)
    metadata = models.JSONField(default=dict, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    processed_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['wallet', 'created_at']),
            models.Index(fields=['reference_id']),
            models.Index(fields=['status']),
        ]

    def save(self, *args, **kwargs):
        if self.status == 'completed' and not self.processed_at:
            self.processed_at = timezone.now()

            # Update wallet balance for completed transactions
            if not hasattr(self, '_balance_updated'):
                if self.transaction_type in ['deposit', 'refund', 'bonus']:
                    self.wallet.balance += self.amount
                elif self.transaction_type in ['withdrawal', 'purchase', 'transfer']:
                    self.wallet.balance -= self.amount
                self.wallet.save()
                self._balance_updated = True

        super().save(*args, **kwargs)


class WithdrawalRequest(models.Model):
    WITHDRAWAL_STATUS = (
        ('pending', 'Pending'),
        ('approved', 'Approved'),
        ('processing', 'Processing'),
        ('completed', 'Completed'),
        ('rejected', 'Rejected'),
    )

    WITHDRAWAL_METHODS = (
        ('bank_transfer', 'Bank Transfer'),
        ('paypal', 'PayPal'),
        ('stripe', 'Stripe Connect'),
    )

    wallet = models.ForeignKey(Wallet, on_delete=models.CASCADE)
    amount = models.DecimalField(max_digits=15, decimal_places=2)
    method = models.CharField(max_length=20, choices=WITHDRAWAL_METHODS)
    status = models.CharField(max_length=20, choices=WITHDRAWAL_STATUS, default='pending')
    account_details = models.JSONField(default=dict)  # Store bank/PayPal details securely
    notes = models.TextField(blank=True)
    admin_notes = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    processed_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        ordering = ['-created_at']


class WalletSecurity(models.Model):
    wallet = models.OneToOneField(Wallet, on_delete=models.CASCADE)
    two_factor_enabled = models.BooleanField(default=False)
    withdrawal_limit_daily = models.DecimalField(max_digits=15, decimal_places=2, default=5000)
    last_withdrawal_date = models.DateField(null=True, blank=True)
    daily_withdrawal_total = models.DecimalField(max_digits=15, decimal_places=2, default=0)
    require_approval_for_large_transfers = models.BooleanField(default=True)
    large_transfer_threshold = models.DecimalField(max_digits=15, decimal_places=2, default=1000)
