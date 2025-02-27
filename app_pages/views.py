from django.shortcuts import render


def home(request):
    # Optionally, filter tutors based on criteria (e.g., language, availability)
    context = {}
    return render(request, 'app_pages/home.html', context)