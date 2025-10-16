from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone


# from ap2_meeting.models import Session as Appointment
# from ap2_tutor.models import Tutor as Provider
# from ap2_student.models import Student as Client
# from shortuuid.django_fields import ShortUUIDField
#
#
# class Bill(models.Model):
#     appointment = models.ForeignKey(Appointment, on_delete=models.CASCADE, null=False, blank=False, related_name='appointment_bills')
#     client = models.ForeignKey(Client, on_delete=models.SET_NULL, null=True, blank=False, related_name='client_bills')
#     provider = models.ForeignKey(Provider, on_delete=models.SET_NULL, null=True, blank=False, related_name='provider_bills')
#     sub_total = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
#     tax = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
#     total = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
#     status = models.CharField(max_length=10, choices=[('paid', 'Paid'), ('unpaid', 'Unpaid')], default='unpaid')
#     bill_id = ShortUUIDField(length=6, max_length=10, alphabet="1234567890", unique=True)
#     # date = models.DateTimeField(default=timezone.now)
#     date = models.DateTimeField(auto_now_add=True)
#
#     def __str__(self):
#         return f'Billing for {self.client} - Total: {self.total}'

