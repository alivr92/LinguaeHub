from django.urls import path, include
from app_pages import views

app_name = 'app_pages'

urlpatterns = [
    path('', views.Home.as_view(), name='home'),
    path('home2/', views.Home2.as_view(), name='home2'),
    path('about/', views.About.as_view(), name='about'),
    path('contact/', views.ContactUs.as_view(), name='contact_us'),
    path('in-person/', views.InPerson.as_view(), name='in_person'),
    path('in-person-2/', views.InPerson2.as_view(), name='in_person2'),
    path('in-person-individual/', views.InPersonIndividual.as_view(), name='in_person_individual'),
    path('in-person-gruop/', views.InPersonGruop.as_view(), name='in_person_gruop'),
    path('in-person-companies/', views.InPersonCompanies.as_view(), name='in_person_companies'),
    path('in-person-kids/', views.InPersonKids.as_view(), name='in_person_kids'),
    # path('contact-us/', views.saveContactUs, name='save_contact_us'),
    # path('blog/', views.Blog.as_view(), name='blog'),
    path('FAQ/', views.FAQ.as_view(), name='faq'),
    path('terms-and-condition/', views.TermsCondition.as_view(), name='terms'),
    path('terms-user/', views.TermsUser.as_view(), name='terms_user'),
    path('AGB/', views.AGB.as_view(), name='agb'),
    path('privacy-policy/', views.PrivacyPolicy.as_view(), name='privacy_policy'),
    path('coming-soon/', views.ComingSoon.as_view(), name='coming_soon'),
    path('pricing/', views.Pricing.as_view(), name='pricing'),
    path('imprint/', views.Imprint.as_view(), name='imprint'),
    # path('services/', views.services, name='services'),
    # path('dashboard/', views.dashboard, name='dashboard'),

    # Help Center
    # path('<slug:category_slug>/', views.HelpHomeView.as_view(), name='help_category'),
    path('help-center/', views.HelpCenterView.as_view(), name='help_center'),
    # path('help/<slug:category_slug>/<slug:section_slug>/', views.HelpCategoryView.as_view(), name='help_category'),
    # path('help/<slug:category_slug>/<slug:section_slug>/', views.SectionView.as_view(), name='help_section'),
    path('help/<slug:category_slug>/<slug:section_slug>/<slug:article_slug>/', views.ArticleView.as_view(),
         name='help_article'),

]
