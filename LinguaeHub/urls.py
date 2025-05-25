"""
URL configuration for LinguaeHub project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.conf.urls.static import static
from django.conf import settings

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('app_pages.urls')),
    path('myadmin/', include('app_admin.urls', namespace='my_admin')),
    path('staff/', include('app_staff.urls', namespace='staff')),
    path('tutor/', include('ap2_tutor.urls', namespace='Instructors')),
    path('student/', include('ap2_student.urls', namespace='student')),
    path('accounts/', include('app_accounts.urls', namespace='accounts')),
    path('schedule/', include('ap2_meeting.urls', namespace='schedule')),
    # path('payments/', include('payments.urls', namespace='payments')),
    path('blog/', include('app_blog.urls', namespace='blog')),

]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
