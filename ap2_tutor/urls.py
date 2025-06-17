from django.urls import path
from . import views

app_name = 'tutor'

urlpatterns = [
    # ---------------------- PROVIDER FRONT PAGES
    path('', views.TutorListView.as_view(), name='tutor_list'),
    path('tutor-detail/instructor_<int:pk>/', views.TutorDetailView.as_view(), name='tutor_detail'),
    path('tutor-reserve/instructor_<int:pk>/', views.TutorReserveView.as_view(), name='tutor_reserve'),

    # ---------------------- PROVIDER DASHBOARD
    path('dashboard/panel/', views.DTHome.as_view(), name='dt_home'),
    path('dashboard/manage-course/', views.DTManageCourse.as_view(), name='dt_manage_course'),
    path('dashboard/quiz/', views.DTQuiz.as_view(), name='dt_quiz'),
    path('dashboard/earning/', views.DTEarning.as_view(), name='dt_earning'),
    path('dashboard/student-list/', views.DTStudentList.as_view(), name='dt_student_list'),
    path('dashboard/order/', views.DTOrder.as_view(), name='dt_order'),
    path('dashboard/review/', views.DTReviews.as_view(), name='dt_reviews'),
    path('dashboard/edit-profile/<int:pk>/', views.DTEditProfile.as_view(), name='dt_edit'),
    path('dashboard/payout/', views.DTPayout.as_view(), name='dt_payout'),
    path('dashboard/setting/', views.DTSetting.as_view(), name='dt_setting'),
    path('dashboard/delete-account/<int:pk>/', views.DTDeleteAccount.as_view(), name='dt_delete_account'),

    # ---------------------- PROVIDER INTERVIEW ----------------------------------------------
    path('interview/', views.DTInterview.as_view(), name='dt_interview'),

    # ---------------------- PROVIDER WIZARD -------------------------------------------------
    path('wizard/', views.DTWizard.as_view(), name='dt_wizard'),
    path('become-tutor/', views.BecomeTutor.as_view(), name='become_tutor'),
    path('wizard/submit/', views.SuccessSubmit.as_view(), name='success_submit'),

    # ---------------------- functions -------------------------------------------------------
    path('wizard/submit-profile/', views.submit_form_profile, name='submit_form_profile'),
    path('wizard/submit-form-skill/', views.submit_form_skill, name='submit_form_skill'),
    path('get-existed-skills/', views.get_existed_skills, name='get_existed_skills'),
    path('save-skills/', views.save_skills, name='save_skills'),

    path('get-categories/', views.get_categories, name='get_categories'),
    path('get-subcategories/', views.get_subcategories, name='get_subcategories'),
    path('get-category-for-subcategories/', views.get_category_for_subcategories,
         name='get_category_for_subcategories'),

    # path('wizard/', views.BaseWizardView.as_view(), name='dt_wizard'),
    # path('wizard/step2/', views.ProfileStepView.as_view(), name='dt_wizard_step2'),
    # path('wizard/step3/', views.SkillsStepView.as_view(), name='dt_wizard_step3'),
    # path('wizard/step4/', views.EducationStepView.as_view(), name='dt_wizard_step4'),
    # ... other steps

]
