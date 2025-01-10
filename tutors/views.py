from django.shortcuts import render
from tutors.models import Tutor, TutorVideo


def tutor_list(request):
    tutors = Tutor.objects.all()
    # Optionally, filter tutors based on criteria (e.g., language, availability)
    context = {'tutors': tutors}
    return render(request, 'tutors/tutors.html', context)