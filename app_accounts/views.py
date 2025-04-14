from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse_lazy
from django.contrib import messages, auth
from django.contrib.auth import authenticate, login
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User, Group
from app_accounts.models import UserProfile
from django.views.generic import View, CreateView, ListView, TemplateView
from .forms import UserRegistrationForm


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


class SignUpStudent(CreateView):
    model = User
    form_class = UserRegistrationForm
    template_name = 'app_accounts/sign_up.html'
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


class SignUpTutor(CreateView):
    model = User
    form_class = UserRegistrationForm
    template_name = 'app_accounts/sign_up_tutor.html'
    success_url = reverse_lazy('accounts:dashboard')

    def form_valid(self, form):
        user = form.save(commit=False)
        user.set_password(form.cleaned_data['password'])
        user.save()
        messages.success(self.request,
                         "Congratulations! You registered successfully. Now confirm your email address and then login to your dashboard!")
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


# def sign_up(request):
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
        return redirect('my_admin:da_home')
    elif user_type == 'staff':
        return redirect('staff:dstf_home')
    elif user_type == 'tutor':
        return redirect('tutor:dt_home')
    elif user_type == 'student':
        return redirect('student:ds_home')
    else:
        # Handle invalid or unexpected user_type (e.g., log an error)
        print(f"Invalid or unexpected user_type: {user_type}")
        return redirect('accounts:ds_home')


@login_required
def dashboardEdit(request, pk):
    if not request.user.is_authenticated:
        return redirect('accounts:sign_in')
    user = request.user

    if user.is_superuser:
        return redirect('my_admin:da_edit', pk)
    elif user.groups.filter(name='staff').exists():
        return redirect('staff:dstf_edit', pk)
    elif user.groups.filter(name='tutor').exists():
        return redirect('tutor:dt_edit', pk)
    elif user.groups.filter(name='student').exists():
        return redirect('student:ds_edit', pk)
    else:
        # Redirect to a default page or handle unauthenticated roles
        return redirect('student:ds_edit', pk)

# finally Here MUST CHECK FOR JUST TUTOR ACCESS NOT OTHERS!!!!
