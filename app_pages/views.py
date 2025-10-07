from django.shortcuts import render, redirect
from django.views.generic import TemplateView, FormView, ListView, DetailView
from django.shortcuts import get_object_or_404
from django.urls import reverse_lazy, reverse
from django.contrib import messages
from django.conf import settings
from django.contrib.auth.models import User
from django.utils.timezone import now, timedelta
from django.db.models import Q, F
from utils.email import notification_email_to_admin, get_base64_logo
from ap2_tutor.models import Tutor
from ap2_student.models import Student
from ap2_meeting.models import Session, Review
from .forms import ContactUsForm
from app_pages.models import HelpCategory, HelpSection, HelpArticle


class Home2(TemplateView):
    template_name = 'app_pages/iLanding/home.html'


class Home(TemplateView):
    template_name = 'app_pages/home_mixed.html'

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


class Pricing(TemplateView):
    template_name = 'app_pages/pricing.html'


class Imprint(TemplateView):
    template_name = 'app_pages/imprint.html'


class ContactUs(FormView):
    template_name = 'app_pages/contact-us.html'
    form_class = ContactUsForm
    success_url = reverse_lazy('app_pages:contact_us')

    def form_valid(self, form):
        fullname = self.request.POST.get('name')
        subject = f'New message from: {fullname}'
        template = 'emails/admin/notify_admin_contact_us'
        context = {
            'fullname': fullname,
            'email': self.request.POST.get('email'),
            'phone': self.request.POST.get('phone'),
            'message': self.request.POST.get('message'),
            'admin_dashboard_uri': self.request.build_absolute_uri(reverse('my_admin:da_contact_us')),
            'site_name': settings.SITE_NAME,
            # 'logo_uri': self.request.build_absolute_uri(static('assets/images/logo_white_gold.png'))
            'logo_base64': get_base64_logo()
        }
        notification_email_to_admin(subject, template, context)

        form.save()  # Save the form data to the database
        messages.success(self.request, 'We received your message. We will get back to you soon.')
        return super().form_valid(form)

    def form_invalid(self, form):
        messages.error(self.request, 'There is an error in sending message! please check your fields')
        return self.render_to_response(self.get_context_data(form=form))


class AGB(TemplateView):
    template_name = 'app_pages/agb.html'


class TermsCondition(TemplateView):
    template_name = 'app_pages/terms.html'


class TermsUser(TemplateView):
    template_name = 'app_pages/terms_user.html'


class PrivacyPolicy(TemplateView):
    template_name = 'app_pages/privacy_policy.html'


class ComingSoon(TemplateView):
    template_name = 'app_pages/coming-soon.html'


# -------------------------------- Help Center --------------------------------
class HelpCenterView(ListView):
    model = HelpCategory
    template_name = 'app_pages/help/help_center.html'
    context_object_name = 'categories'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['categories'] = HelpCategory.objects.filter(featured=True)
        context['popular_articles'] = HelpArticle.objects.filter(is_featured=True).order_by('-view_count')[:5]
        context['popular_questions'] = HelpArticle.objects.order_by('-view_count')[:5]
        return context


class FAQ(TemplateView):
    template_name = 'app_pages/help/faq.html'


class SectionView(DetailView):
    model = HelpSection
    template_name = 'app_pages/help/section.html'

    def get_queryset(self):
        return HelpSection.objects.filter(
            category__slug=self.kwargs['category_slug'],
            slug=self.kwargs['section_slug']
        )


# def search_articles(query):
#     return HelpArticle.objects.filter(
#         Q(title__icontains=query) | Q(content__icontains=query)
#     ).order_by('-is_featured', 'section__category__order', 'section__order', 'order')


class ArticleView(DetailView):
    model = HelpArticle
    template_name = 'app_pages/help/help_article.html'
    context_object_name = 'article'

    def get_object(self, queryset=None):
        # Get the article using all three slugs
        return get_object_or_404(
            HelpArticle,
            section__category__slug=self.kwargs['category_slug'],
            section__slug=self.kwargs['section_slug'],
            slug=self.kwargs['article_slug']
        )

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # Increment view count
        HelpArticle.objects.filter(pk=self.object.pk).update(view_count=F('view_count') + 1)
        # Add related articles
        context['related_articles'] = self.object.related_articles.all()[:5]
        return context


class InPerson(TemplateView):
    template_name = 'app_pages/in_person/in-person.html'



class InPersonIndividual(TemplateView):
    template_name = 'app_pages/in_person/private_class.html'


class InPersonGruop(TemplateView):
    template_name = 'app_pages/in_person/in-person-group.html'


class InPersonGruop2(TemplateView):
    template_name = 'app_pages/in_person/inp_group2.html'


class InPersonCorporate(TemplateView):
    template_name = 'app_pages/in_person/inp_corporate.html'


class InPersonCorporate2(TemplateView):
    template_name = 'app_pages/in_person/inp_corporate2.html'

class ForBusiness(TemplateView):
    template_name = 'app_pages/for_business.html'

class OnlineLearning(TemplateView):
    template_name = 'app_pages/online_learning.html'

# CTA Form pages:
class RequestEnterpriseDemoView(TemplateView):
    template_name = 'app_pages/forms/request_enterprise_demo.html'


class ExploreBusinessSolutionsView(TemplateView):
    template_name = 'app_pages/forms/explore_business_solutions.html'


class InPersonKids(TemplateView):
    template_name = 'app_pages/in_person/in-person-kids.html'


class InPersonKids2(TemplateView):
    template_name = 'app_pages/in_person/inp_kids2.html'
