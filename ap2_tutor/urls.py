from django.urls import path, re_path
from django.views.generic import RedirectView
from . import views
app_name = 'provider'

urlpatterns = [
    # ---------------------- PROVIDER FRONT PAGES
    path('', views.TutorListView.as_view(), name='tutor_list'),
    # path('reserve/<int:pk>/', views.TutorReserveView.as_view(), name='tutor_reserve'),
    path('reserve/<str:public_id>/', views.TutorReserveView.as_view(), name='tutor_reserve'),

    # SEO-friendly URL (primary - should come FIRST)
    path('s/<slug:slug>/', views.ProviderDetailView.as_view(), name='provider_detail'),
    # Short URL (redirects to SEO version)
    path('p/<str:public_id>/', views.ProviderShortRedirectView.as_view(), name='provider_short'),
    # Legacy URL (redirects to SEO version) - keep for existing links
    path('i/<int:pk>/', views.ProviderLegacyRedirectView.as_view(), name='provider_legacy'),


    # ---------------------- PROVIDER DASHBOARD
    path('dashboard/panel/', views.DPHome.as_view(), name='dp_home'),
    path('dashboard/manage-course/', views.DPManageCourse.as_view(), name='dp_manage_course'),
    path('dashboard/quiz/', views.DPQuiz.as_view(), name='dp_quiz'),
    path('dashboard/earning/', views.DPEarning.as_view(), name='dp_earning'),
    path('dashboard/pricing/', views.DPPricing.as_view(), name='dp_pricing'),
    path('dashboard/student-list/', views.DPStudentList.as_view(), name='dp_client_list'),
    path('dashboard/order/', views.DPOrder.as_view(), name='dp_order'),
    path('dashboard/review/', views.DPReviews.as_view(), name='dp_reviews'),
    path('dashboard/edit-profile/<int:pk>/', views.DPEditProfile.as_view(), name='dp_edit'),
    path('dashboard/payout/', views.DPPayout.as_view(), name='dp_payout'),
    path('dashboard/setting/', views.DPSetting.as_view(), name='dp_setting'),
    path('dashboard/in-person/', views.DPInPerson.as_view(), name='dp_in_person'),
    path('dashboard/delete-account/<int:pk>/', views.DPDeleteAccount.as_view(), name='dp_delete_account'),

    # ---------------------- PROVIDER INTERVIEW ----------------------------------------------
    path('interview/', views.DPInterview.as_view(), name='dp_interview'),

    # ---------------------- PROVIDER WIZARD -------------------------------------------------
    path('wizard/', views.DPWizard.as_view(), name='dp_wizard'),
    path('become-tutor/', views.BecomeTutor.as_view(), name='become_tutor'),
    path('wizard/submit/', views.SuccessSubmit.as_view(), name='success_submit'),
    path('wizard/result/', views.DPWizardResult.as_view(), name='dp_wizard_result'),
    path('wizard/test/', views.DPWizardTest.as_view(), name='dp_wizard_test'),

    # ---------------------- functions -------------------------------------------------------
    path('wizard/submit-profile/', views.submit_profile, name='submit_profile'),
    path('wizard/submit-form-skill/', views.submit_form_skill, name='submit_form_skill'),
    path('wizard/submit-teaching-method/', views.submit_teaching_method, name='submit_teaching_method'),
    path('wizard/submit-edu/', views.submit_edu, name='submit_edu'),
    path('wizard/submit-final/', views.wizard_submit_final, name='wizard_submit_final'),

    path('get-existed-skills/', views.get_existed_skills, name='get_existed_skills'),
    path('get-education-data/', views.get_education_data, name='get_education_data'),
    path('save-skills/', views.save_skills, name='save_skills'),
    path('save-educations/', views.save_educations, name='save_educations'),
    path('get-pricing/', views.get_pricing, name='get_pricing'),
    path('update-pricing/', views.update_pricing, name='update_pricing'),

    # path('get-categories/', views.get_categories, name='get_categories'),
    # path('get-subcategories/', views.get_subcategories, name='get_subcategories'),
    # path('get-category-for-subcategories/', views.get_category_for_subcategories, name='get_category_for_subcategories'),

    # path('wizard/', views.BaseWizardView.as_view(), name='dp_wizard'),
    # path('wizard/step2/', views.ProfileStepView.as_view(), name='dp_wizard_step2'),
    # path('wizard/step3/', views.SkillsStepView.as_view(), name='dp_wizard_step3'),
    # path('wizard/step4/', views.EducationStepView.as_view(), name='dp_wizard_step4'),
    # ... other steps

]
