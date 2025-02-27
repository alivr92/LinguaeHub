from django.shortcuts import render, redirect, get_object_or_404
from django.db.models import Exists, OuterRef
from django.urls import reverse
from django.contrib import messages, auth
from django.contrib.auth import authenticate, login
from django.contrib.auth.decorators import login_required
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.auth.models import User, Group
from app_accounts.models import UserProfile
from ap2_tutor.models import Tutor
from ap2_student.models import Student
from ap2_meeting.models import Session, Review
from django.views.generic import View, TemplateView, CreateView, UpdateView, ListView
from .forms import UserRegistrationForm, DTEditProfileForm2
from django.urls import reverse_lazy
# from django.views.generic.edit import CreateView


class SignInView(View):
    template_name = 'app_accounts/sign-in.html'

    def get(self, request, *args, **kwargs):
        context = {}
        return render(request, self.template_name, context)

    def post(self, request, *args, **kwargs):
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(username=username, password=password)

        if user is not None:
            login(request, user)
            messages.success(request, "You are successfully logged in. Welcome!")
            return redirect('accounts:dashboard')
        else:
            messages.error(request, 'Invalid login credentials!')
            return redirect('accounts:sign_in')


class SignUpView2(View):
    template_name = 'app_accounts/sign_up.html'

    def get(self, request, *args, **kwargs):
        context = {}
        return render(request, self.template_name, context)

    def post(self, request, *args, **kwargs):
        first_name = request.POST['first_name']
        last_name = request.POST['last_name']
        username = request.POST['username']
        email = request.POST['email']
        password = request.POST['password']
        password_confirm = request.POST['password_confirm']

        if User.objects.filter(username=username).exists():
            messages.error(request, "Sorry, This username has been registered before! Try another one!")
            return redirect('accounts:sign_up')
        elif User.objects.filter(email=email).exists():
            messages.error(request, "Sorry, This email address has been registered before! Try another one!")
            return redirect('accounts:sign_up')
        elif password != password_confirm:
            messages.error(request, "Check your passwords! They must be the same!")
            return redirect('accounts:sign_up')
        else:
            user = User.objects.create_user(email=email, username=username, password=password,
                                            first_name=first_name, last_name=last_name)
            user.save()
            messages.success(request, "Congratulations! You registered successfully. Now login for the first time!")
            return redirect('accounts:sign_in')


class UserSignUpView(CreateView):
    model = User
    form_class = UserRegistrationForm
    template_name = 'app_accounts/sign_up2.html'
    success_url = reverse_lazy('accounts:dashboard')

    def form_valid(self, form):
        user = form.save(commit=False)
        user.set_password(form.cleaned_data['password'])
        user.save()
        messages.success(self.request, "Congratulations! You registered successfully. Now login for the first time!")
        login(self.request, user)
        return super().form_valid(form)

    def form_invalid(self, form):
        for error in form.errors.values():
            messages.error(self.request, str(error))
        return self.render_to_response(self.get_context_data(form=form))


@login_required
def sign_out(request):
    auth.logout(request)
    return redirect('app_pages:home')

# def sign_up2(request):
#     if request.method == 'POST':
#         first_name = request.POST['first_name']
#         last_name = request.POST['last_name']
#         username = request.POST['username']
#         email = request.POST['email']
#         password = request.POST['password']
#         password_confirm = request.POST['password_confirm']
#
#         if User.objects.filter(username=username).exists():
#             messages.error(request, "Sorry, This username has been registered before! Try another one!")
#             return redirect('accounts:sign_up')
#         elif User.objects.filter(email=email).exists():
#             messages.error(request, "Sorry, This email address has been registered before! Try another one!")
#             return redirect('app_accounts:sign_up')
#         elif password != password_confirm:
#             messages.error(request, "Check your passwords! They must be the same!")
#             return redirect('app_accounts:sign_up')
#         else:
#             user = User.objects.create_user(email=email, username=username, password=password,
#                                             first_name=first_name, last_name=last_name)
#             user.save()
#             messages.success(request, "Congratulations! You registered successfully. Now login for the first time!")
#             return redirect('app_accounts:sign_in')
#     else:
#         context = {}
#         return render(request, 'app_accounts/sign-up.html', context)


@login_required
def dashboard(request):
    if not request.user.is_authenticated:
        return redirect('accounts:sign_in')
    user = request.user
    try:
        user_type = user.profile.user_type
    except AttributeError:
        UserProfile.objects.create(user=user, user_type='student')
        user_type = user.profile.user_type

    if user.is_superuser:
        return redirect('accounts:da_home')
    elif user_type == 'staff':
        return redirect('accounts:dstaff_home')
    elif user_type == 'tutor':
        return redirect('accounts:dt_home')
    elif user_type == 'student':
        return redirect('accounts:ds_home')
    else:
        # Handle invalid or unexpected user_type (e.g., log an error)
        print(f"Invalid or unexpected user_type: {user_type}")
        return redirect('accounts:ds_home')


@login_required
def dashboardEdit(request):
    if not request.user.is_authenticated:
        return redirect('accounts:sign_in')
    user = request.user

    if user.is_superuser:
        return redirect('accounts:da_settings')
    elif user.groups.filter(name='staff').exists():
        return redirect('accounts:dstaff_edit')
    elif user.groups.filter(name='tutor').exists():
        return redirect('accounts:dt_edit')
    elif user.groups.filter(name='student').exists():
        return redirect('accounts:ds_edit')
    else:
        # Redirect to a default page or handle unauthenticated roles
        return redirect('accounts:ds_edit')


# finally Here MUST CHECK FOR JUST TUTOR ACCESS NOT OTHERS!!!!


# DASHBOARD ADMIN (SUPERUSER)   --------------------------------------------------------------------------------
class DAHomeView(LoginRequiredMixin, TemplateView):
    template_name = 'app_accounts/dashboard/superuser/da_home.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context


class DASettings(LoginRequiredMixin, TemplateView):
    template_name = 'app_accounts/dashboard/superuser/da_setting.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context


# DASHBOARD STAFF   ---------------------------------------------------------------------------------------------
class DSTFHomeView(LoginRequiredMixin, TemplateView):
    template_name = 'app_accounts/dashboard/staff/dstf_home.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context


class DSTFEditView(LoginRequiredMixin, TemplateView):
    template_name = 'app_accounts/dashboard/staff/dstf_edit.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context


# DASHBOARD STUDENT ---------------------------------------------------------------------------------------------
class DSHomeView(LoginRequiredMixin, TemplateView):
    template_name = 'app_accounts/dashboard/student/ds_home.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context


class DSClassListView(LoginRequiredMixin, ListView):
    model = Session
    template_name = 'app_accounts/dashboard/student/ds_class_list.html'
    paginate_by = 6

    def get_queryset(self):
        # Assuming the logged-in user is a Tutor and you have a relationship between Tutor and UserProfile
        return Session.objects.filter(students__profile__user=self.request.user).order_by('-start_session_utc')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        student_id = self.request.user.profile.student_profile.pk

        # Annotate each session with a flag indicating if the current student has reviewed it
        sessions = Session.objects.annotate(
            has_reviewed=Exists(
                Review.objects.filter(
                    session_id=OuterRef('pk'),
                    student_id=student_id
                )
            )
        )

        context['sessions'] = sessions
        return context

    def post(self, request, *args, **kwargs):
        if request.method == 'POST':
            tutor_id = request.POST.get('tutorId')
            student_id = int(request.POST.get('studentId'))
            if request.user.profile.student_profile.pk != student_id:

                messages.error(self.request, f'you just allow to send feedback on your classes not more!')
                return redirect('accounts:sign_out')
            # print(f'studenId: {type(student_id)}, request: {type(request.user.profile.student_profile.pk)}')
            session_id = request.POST.get('sessionId')
            rate_tutor = request.POST.get('rate_tutor')
            rate_session = request.POST.get('rate_session')
            msg = request.POST.get('msg')

            if Review.objects.filter(session_id=session_id, student_id=student_id):
                messages.error(self.request, 'You have posted your review for this session before! You are allow to '
                                            'send your feedback just one time!')
                return redirect(reverse('accounts:ds_class_list'))

            # Create and save the review
            Review.objects.create(
                tutor_id=tutor_id,
                student_id=student_id,
                session_id=session_id,
                rate_tutor=rate_tutor,
                rate_session=rate_session,
                message=msg
            )

            # Redirect to the same page after submission
            return redirect(reverse('accounts:ds_class_list'))

        return super().get(request, *args, **kwargs)

# def ds_review_save(request):
#     if request.method == 'POST':
#
#         tutorId = request.POST['tutorId']
#         studentId = request.POST['studentId']
#         sessionId = request.POST['sessionId']
#         rate_tutor = request.POST['rate_tutor']
#         rate_session = request.POST['rate_session']
#         msg = request.POST['msg']
#         # print(f'message: {msg}')
#         # return
#         review = Review.objects.create(tutor_id=tutorId, student_id=studentId, message=msg, session_id=sessionId,
#                                        rate_tutor=rate_tutor, rate_session=rate_session,
#                                        )
#         review.save()



class DSCourseResumeView(LoginRequiredMixin, TemplateView):
    template_name = 'app_accounts/dashboard/student/ds_course_resume.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context

class DSEditView(LoginRequiredMixin, TemplateView):
    template_name = 'app_accounts/dashboard/student/ds_edit.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context


# DASHBOARD TUTOR   ---------------------------------------------------------------------------------------------
class DTHomeView(LoginRequiredMixin, TemplateView):
    template_name = 'app_accounts/dashboard/tutor/dt_home.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['tutor'] = self.request.user.profile.tutor_profile
        return context


class DTEditView(LoginRequiredMixin, TemplateView):
    template_name = 'app_accounts/dashboard/tutor/dt_edit.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context



class DTStudentList(LoginRequiredMixin, ListView):
    model = Session
    template_name = 'app_accounts/dashboard/tutor/dt_student_list.html'
    # ordering = ['-profile__create_date']
    paginate_by = 6  # Number of items per page

    def get_queryset(self):
        # Assuming the logged-in user is a Tutor and you have a relationship between Tutor and UserProfile
        return Session.objects.filter(tutor__profile__user=self.request.user).order_by('-start_session_utc')


class DTSettingView(LoginRequiredMixin, TemplateView):
    template_name = 'app_accounts/dashboard/tutor/dt_settings.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # context['tutor'] = self.get_object()  # Get the current tutor object
        return context


# class DTEditProfileView(UpdateView):
#     template_name = 'app_accounts/dashboard/tutor/dt_edit_profile.html'
#     model = Tutor
#     form_class = DTEditProfileForm
#     success_url = reverse_lazy('app_accounts:dt_home')
#
#     def get_context_data(self, **kwargs):
#         context = super().get_context_data(**kwargs)
#         context['tutor'] = self.get_object()  # Get the current tutor object
#         return context
#
#     def form_valid(self, form):
#         if form.is_valid():
#             self.object = form.save()  # Save the updated instance
#             return super().form_valid(form)
#         else:
#             print(form.errors)  # Debugging line to print form errors
class DTEditProfileView(LoginRequiredMixin, UpdateView):
    login_url = ''
    template_name = 'app_accounts/dashboard/../ap2_tutor/templates/ap2_tutor/dashboard/tutor/dt_edit.html'
    model = Tutor
    form_class = DTEditProfileForm2
    success_url = reverse_lazy('app_accounts:dt_home')

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # context['tutor'] = get_object_or_404(Tutor, pk=self.request.user.pk)
        context['tutor'] = self.get_object()  # Get the current tutor object
        return context

    # def form_valid(self, form):
    #     if form.is_valid():
    #         print("Form is valid")
    #         print("Cleaned data:", form.cleaned_data)  # Debugging line to print cleaned form data
    #         self.object = form.save()  # Save the updated instance
    #         messages.success(self.request, "You profile edited successfully.")
    #         print("Object saved")  # Debugging line
    #         return super().form_valid(form)
    #     else:
    #         self.form_invalid(form)

    def form_valid(self, form):
        if form.is_valid():
            print("Form is valid")
            print("Cleaned data:", form.cleaned_data)  # Debugging
            self.object = form.save()
            messages.success(self.request, "You profile edited successfully.")
            print("Object saved")
            return super().form_valid(form)
        else:
            return self.form_invalid(form)

    def form_invalid(self, form):
        for error in form.errors.values():
            messages.error(self.request, str(error))
        return self.render_to_response(self.get_context_data(form=form))

    def post(self, request, *args, **kwargs):
        print("Form submission received")  # Debugging line
        response = super().post(request, *args, **kwargs)
        print("Form processed")  # Debugging line
        return response






