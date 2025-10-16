# payment3/management/commands/populate_wallet_data.py
from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from faker import Faker
from decimal import Decimal
import random
from datetime import datetime, timedelta
from django.utils import timezone

from payment3.models import Wallet, Transaction, WithdrawalRequest, WalletSecurity

class Command(BaseCommand):
    help = 'Populate the database with fake wallet data for testing'

    def add_arguments(self, parser):
        parser.add_argument(
            '--users',
            type=int,
            default=3,
            help='Number of fake users to create (default: 3)'
        )
        parser.add_argument(
            '--transactions',
            type=int,
            default=20,
            help='Number of transactions per user (default: 20)'
        )

    def handle(self, *args, **options):
        fake = Faker()

        self.stdout.write(self.style.SUCCESS('Starting to populate fake wallet data...'))

        # Get or create superuser for testing
        admin_user, created = User.objects.get_or_create(
            username='admin',
            defaults={
                'email': 'admin@example.com',
                'is_staff': True,
                'is_superuser': True
            }
        )
        if created:
            admin_user.set_password('admin123')
            admin_user.save()
            self.stdout.write(self.style.SUCCESS('Created admin user'))

        # Create fake users
        num_users = options['users']
        transactions_per_user = options['transactions']

        users = []
        for i in range(num_users):
            username = fake.user_name()
            email = fake.email()

            user, created = User.objects.get_or_create(
                username=username,
                defaults={
                    'email': email,
                    'first_name': fake.first_name(),
                    'last_name': fake.last_name(),
                }
            )
            if created:
                user.set_password('test123')
                user.save()
                users.append(user)
                self.stdout.write(self.style.SUCCESS(f'Created user: {username}'))

        # Add admin to users list
        users.append(admin_user)

        # Create wallets and transactions for each user
        transaction_types = ['deposit', 'withdrawal', 'purchase', 'refund', 'bonus', 'commission']
        status_types = ['completed', 'pending', 'failed']
        withdrawal_methods = ['bank_transfer', 'paypal', 'stripe']
        withdrawal_statuses = ['pending', 'approved', 'processing', 'completed', 'rejected']

        # Bank names for realistic data
        bank_names = ['Chase Bank', 'Bank of America', 'Wells Fargo', 'Citibank', 'US Bank', 'TD Bank', 'Capital One']

        for user in users:
            self.stdout.write(f'Processing user: {user.username}')

            # Create or get wallet
            wallet, created = Wallet.objects.get_or_create(user=user)
            if created:
                self.stdout.write(f'Created wallet for {user.username}')

            # Create wallet security
            wallet_security, created = WalletSecurity.objects.get_or_create(wallet=wallet)

            # Generate transactions
            transactions_created = 0
            balance = Decimal('0')

            for i in range(transactions_per_user):
                # Random date within last 90 days
                days_ago = random.randint(0, 90)
                transaction_date = timezone.now() - timedelta(days=days_ago, hours=random.randint(0, 23))

                # Random amount based on transaction type
                transaction_type = random.choice(transaction_types)

                if transaction_type in ['deposit', 'bonus', 'commission']:
                    amount = Decimal(str(round(random.uniform(10, 500), 2)))
                elif transaction_type == 'refund':
                    amount = Decimal(str(round(random.uniform(5, 200), 2)))
                else:  # withdrawal, purchase
                    amount = Decimal(str(round(random.uniform(5, 300), 2)))

                # Ensure we don't go negative for withdrawals/purchases
                if transaction_type in ['withdrawal', 'purchase'] and balance < amount:
                    continue

                status = random.choice(status_types)

                # Create description based on type (using correct Faker methods)
                descriptions = {
                    'deposit': [
                        f"Wallet deposit via Credit Card",
                        f"Bank transfer deposit",
                        f"Credit card top-up",
                        f"PayPal deposit",
                        f"Stripe payment received",
                        f"Direct deposit from {fake.company()}",
                        f"Mobile payment deposit"
                    ],
                    'withdrawal': [
                        f"Withdrawal to {random.choice(bank_names)}",
                        f"PayPal transfer",
                        f"Bank account payout",
                        f"Funds transfer",
                        f"Withdrawal request #{random.randint(1000, 9999)}",
                        f"ATM withdrawal",
                        f"Online banking transfer"
                    ],
                    'purchase': [
                        f"Purchase: {fake.catch_phrase()}",
                        f"Course payment: {fake.bs()}",
                        f"Book purchase: {fake.catch_phrase()}",
                        f"Subscription: {fake.company()}",
                        f"Service fee: {fake.bs()}",
                        f"Online shopping: {fake.domain_name()}",
                        f"Digital product purchase"
                    ],
                    'refund': [
                        f"Refund for order #{random.randint(1000, 9999)}",
                        f"Course refund: {fake.catch_phrase()}",
                        f"Payment reversal",
                        f"Failed transaction refund",
                        f"Customer refund",
                        f"Product return refund",
                        f"Service cancellation refund"
                    ],
                    'bonus': [
                        f"Welcome bonus",
                        f"Referral bonus",
                        f"Loyalty reward",
                        f"Promotional credit",
                        f"Special offer",
                        f"Sign-up bonus",
                        f"Monthly reward"
                    ],
                    'commission': [
                        f"Affiliate commission",
                        f"Sales commission",
                        f"Partner earnings",
                        f"Revenue share",
                        f"Performance bonus",
                        f"Referral earnings",
                        f"Partnership commission"
                    ]
                }

                description = random.choice(descriptions[transaction_type])

                # Create transaction
                transaction = Transaction.objects.create(
                    wallet=wallet,
                    amount=amount,
                    transaction_type=transaction_type,
                    status=status,
                    description=description,
                    reference_id=f"REF{random.randint(100000, 999999)}",
                    stripe_payment_intent_id=f"pi_{fake.sha1()}" if status == 'completed' else "",
                    metadata={
                        'source': fake.domain_word(),
                        'ip_address': fake.ipv4(),
                        'device': random.choice(['web', 'mobile', 'api'])
                    },
                    created_at=transaction_date
                )

                # Update balance for completed transactions
                if status == 'completed':
                    if transaction_type in ['deposit', 'refund', 'bonus', 'commission']:
                        balance += amount
                    else:
                        balance -= amount

                transactions_created += 1

                # Randomly create some processed_at dates for completed transactions
                if status == 'completed' and random.choice([True, False]):
                    transaction.processed_at = transaction_date + timedelta(hours=random.randint(1, 24))
                    transaction.save()

            # Update wallet balance
            wallet.balance = balance
            wallet.save()

            self.stdout.write(self.style.SUCCESS(
                f'Created {transactions_created} transactions for {user.username}. Final balance: ${balance}'
            ))

            # Create withdrawal requests for users with sufficient balance
            if balance > Decimal('50'):
                num_withdrawals = random.randint(1, 3)

                for i in range(num_withdrawals):
                    withdrawal_amount = Decimal(str(round(random.uniform(20, min(float(balance), 200)), 2)))
                    method = random.choice(withdrawal_methods)
                    status = random.choice(withdrawal_statuses)

                    # Create account details based on method
                    if method == 'bank_transfer':
                        account_details = {
                            'bank_name': random.choice(bank_names),
                            'account_holder': f"{user.first_name} {user.last_name}",
                            'account_number': ''.join([str(random.randint(0, 9)) for _ in range(10)]),
                            'routing_number': ''.join([str(random.randint(0, 9)) for _ in range(9)])
                        }
                    elif method == 'paypal':
                        account_details = {
                            'paypal_email': user.email,
                            'account_holder': f"{user.first_name} {user.last_name}"
                        }
                    else:  # stripe
                        account_details = {
                            'stripe_account_id': f"acct_{''.join(random.choices('abcdefghijklmnopqrstuvwxyz0123456789', k=24))}",
                            'account_holder': f"{user.first_name} {user.last_name}"
                        }

                    withdrawal_date = timezone.now() - timedelta(days=random.randint(1, 30))

                    withdrawal = WithdrawalRequest.objects.create(
                        wallet=wallet,
                        amount=withdrawal_amount,
                        method=method,
                        status=status,
                        account_details=account_details,
                        notes=random.choice([
                            "Regular withdrawal",
                            "Need funds for expenses",
                            "Monthly payout",
                            "",
                            "Business expenses",
                            "Personal use",
                            "Investment funds"
                        ]),
                        created_at=withdrawal_date
                    )

                    # Set processed date for completed/rejected withdrawals
                    if status in ['completed', 'rejected']:
                        withdrawal.processed_at = withdrawal_date + timedelta(days=random.randint(1, 3))
                        withdrawal.save()

                    self.stdout.write(self.style.SUCCESS(
                        f'Created withdrawal request #{withdrawal.id} for {user.username}: ${withdrawal_amount}'
                    ))

        self.stdout.write(self.style.SUCCESS(
            f'Successfully populated database with {num_users} users and ~{transactions_per_user * num_users} transactions!'
        ))

        # Display login info
        self.stdout.write(self.style.WARNING('\n=== TEST ACCOUNTS ==='))
        self.stdout.write(self.style.WARNING('Admin: username=admin, password=admin123'))
        for user in users[:3]:  # Show first 3 users
            if user.username != 'admin':
                self.stdout.write(self.style.WARNING(f'User: username={user.username}, password=test123'))