from django.contrib import admin
from .models import Bill

#
# class BillInline(admin.TabularInline):
#     model = Bill
#     extra = 1


class BillAdmin(admin.ModelAdmin):
    list_display = ('provider', 'client', 'appointment', 'total',  'status', 'date')


admin.site.register(Bill, BillAdmin)
