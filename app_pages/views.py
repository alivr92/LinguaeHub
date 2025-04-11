from django.shortcuts import render, redirect
from django.views.generic import TemplateView, FormView
from django.urls import reverse_lazy
from django.contrib import messages
from django.core.mail import send_mail
from django.conf import settings
from django.contrib.auth.models import User
from ap2_tutor.models import Tutor
from ap2_student.models import Student
from ap2_meeting.models import Session, Review
from .forms import ContactUsForm
from django.utils.timezone import now, timedelta
from django.db.models import Q


class Home2(TemplateView):
    template_name = 'app_pages/iLanding/home.html'


class Home(TemplateView):
    template_name = 'app_pages/home.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['tutor_list_new_joined'] = Tutor.objects.filter(
            profile__user__date_joined__gte=now() - timedelta(days=7))[:16]
        context['tutor_list_most_held_classes'] = Tutor.objects.order_by('-session_count')[:16]
        context['tutor_list_high_ranked'] = Tutor.objects.order_by('-profile__rating')[:20]
        context['tutor_list_free_trial'] = Tutor.objects.filter(cost_trial__exact=0).order_by('-profile__rating')[:16]
        context['tutor_discount_list'] = Tutor.objects.filter(
            Q(discount__isnull=False) & Q(discount_deadline__gte=now())
        ).order_by('discount_deadline')[:16]

        initial_counters = 512
        context['tutor_count'] = Tutor.objects.count() + initial_counters
        context['student_count'] = Student.objects.count() + initial_counters
        context['session_count'] = Session.objects.count() + initial_counters
        context['review_count'] = Review.objects.count() + initial_counters
        return context


class About(TemplateView):
    template_name = 'app_pages/about.html'


class ContactUs(FormView):
    template_name = 'app_pages/contact-us.html'
    form_class = ContactUsForm
    success_url = reverse_lazy('app_pages:contact_us')

    def form_valid(self, form):
        fullname = self.request.POST.get('fullname')
        phone = self.request.POST.get('phone')
        email = self.request.POST.get('email')
        message = self.request.POST.get('message')

        admin_info = User.objects.get(is_superuser=True)
        admin_email = admin_info.email

        # print('settings.EMAIL_HOST_USER: ', settings.EMAIL_HOST_USER)
        # print('settings.EMAIL_HOST_USER: ', settings.EMAIL_HOST_PASSWORD)
        send_mail(
            f"Subject: New message from:{fullname}, Email:{email}, Phone: {phone} ",
            f"message: {message}",
            settings.EMAIL_HOST_USER,
            [admin_email],
            fail_silently=False,
        )

        form.save()  # Save the form data to the database
        messages.success(self.request, 'We received your message. We will get back to you soon.')
        return super().form_valid(form)

    def form_invalid(self, form):
        messages.error(self.request, 'There is an error in sending message! please check your fields')
        return self.render_to_response(self.get_context_data(form=form))


class FAQ(TemplateView):
    template_name = 'app_pages/faq.html'


class AGB(TemplateView):
    template_name = 'app_pages/agb.html'


class BecomeTutor(TemplateView):
    template_name = 'app_pages/become-tutor.html'


class HelpCenter(TemplateView):
    template_name = 'app_pages/help-center.html'


class ComingSoon(TemplateView):
    template_name = 'app_pages/coming-soon.html'
