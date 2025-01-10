from django.shortcuts import render


def home(request):
    context = {
        'site_name': 'Linguae Hub',
        'email_1': 'info@LinguaeHub.com',
        'email_2': 'support@LinguaeHub.com',
        'phone_1': '+49 1590 512-6308',
        'phone_2': '+1 6678 254445 41',
        'address_line1': 'A108 Adam Street',
        'address_line2': 'Dresden, Saxony 535022',
    }
    return render(request, 'pages/home.html', context)


def teachers(request):
    context = {}
    return render(request, 'pages/teachers.html', context)


def about(request):
    context = {}
    return render(request, 'pages/about.html', context)


def contact(request):
    context = {}
    return render(request, 'pages/contact.html', context)


def services(request):
    context = {}
    return render(request, 'pages/services.html', context)


def blog(request):
    context = {}
    return render(request, 'pages/blog.html', context)
