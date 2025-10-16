from django.contrib import admin
from .models import Wallet, Transaction, WithdrawalRequest, WalletSecurity


@admin.register(Wallet)
class WalletAdmin(admin.ModelAdmin):
    list_display = ['user', 'balance', 'currency', 'is_active']
    search_fields = ['user', 'balance', 'currency', 'is_active']


@admin.register(Transaction)
class TransactionAdmin(admin.ModelAdmin):
    list_display = ['id', 'wallet', 'amount', 'transaction_type', 'status', 'description', 'reference_id']


@admin.register(WithdrawalRequest)
class WithdrawalRequestAdmin(admin.ModelAdmin):
    list_display = ['wallet', 'amount', 'method', 'status', 'account_details', 'notes']


@admin.register(WalletSecurity)
class WalletSecurityAdmin(admin.ModelAdmin):
    list_display = ['wallet', 'two_factor_enabled', 'withdrawal_limit_daily', 'last_withdrawal_date',
                    'daily_withdrawal_total', 'require_approval_for_large_transfers', 'large_transfer_threshold']
