from django.shortcuts import render, redirect, get_object_or_404
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.generic import TemplateView, ListView, FormView
from django.utils import timezone
from django.utils.dateparse import parse_datetime
from datetime import datetime, timedelta, time, date
import pytz  # For time zone handling (Python Time Zone)
from django.core.exceptions import PermissionDenied, ValidationError
from django.conf import settings
from django.urls import reverse_lazy, reverse
from django.contrib import messages, auth
from django.contrib.auth.decorators import login_required
from django.contrib.auth.models import User
from django.contrib.auth.mixins import LoginRequiredMixin
import json
from ap2_tutor.models import Tutor, ProviderApplication
from utils.pages import error_page
from .models import Session, Availability, AppointmentSetting, AvailableRule
from .forms import SessionForm, AppointmentSettingForm
from utils.email import send_dual_email, notification_email_to_admin
from utils.converters import utc_to_local, local_to_utc, utcTime_to_localTime, localTime_to_utcTime
from utils.mixins import RoleRequiredMixin, ActivationRequiredMixin
import logging

logger = logging.getLogger(__name__)


# def create_session(request):
#     if request.method == 'POST':
#         form = SessionForm(request.POST)
#         if form.is_valid():
#             form.save()
#             return redirect('session_list')  # Redirect to a list of sessions
#     else:
#         form = SessionForm()
#
#     return render(request, 'create_session.html', {'form': form})


def parse_date_time(date_str):
    """
    Parses a date string into a datetime object using a list of predefined formats.

    Args:
        date_str (str): The date string to parse.

    Returns:
        datetime: A datetime object representing the parsed date and time.

    Raises:
        ValueError: If the date string does not match any of the predefined formats.
    """
    # Handle "24:00" case
    if '24:00' in date_str:
        date_str = date_str.replace(' 24:00', ' 00:00')
        extra_day = True
    else:
        extra_day = False

    formats = ["%m/%d/%Y %H:%M", "%m-%d-%Y %H:%M", "%Y-%m-%d %H:%M"]  # Add more formats as needed
    for fmt in formats:
        try:
            parsed_date = datetime.strptime(date_str, fmt)
            if extra_day:
                parsed_date += timedelta(days=1)
            return parsed_date
        except ValueError:
            continue
    raise ValueError(f"Time data '{date_str}' does not match any known format")


def parse_date(date_str):
    """
    Parses a date string into a datetime object using a list of predefined formats.

    Args:
        date_str (str): The date string to parse.

    Returns:
        date: A date object representing the parsed date.

    Raises:
        ValueError: If the date string does not match any of the predefined formats.
    """
    formats = ["%m/%d/%Y", "%m-%d-%Y", "%Y-%m-%d"]  # Add more formats as needed
    for fmt in formats:
        try:
            parsed_date2 = datetime.strptime(date_str, fmt)
            return parsed_date2
        except ValueError:
            continue
    raise ValueError(f"date '{date_str}' does not match any known format")


# CHECKED PROVIDER
@csrf_exempt
def save_available_provider_times(request):
    if not request.user.is_authenticated:
        messages.error(request, "Sorry, You have no access to this page without login! Please sign in first.")
        return redirect('accounts:sign_in')

    # Ensure the logged-in TUTOR's profile is retrieved
    if request.user.profile.user_type not in ['admin', 'tutor', 'interviewer']:
        messages.error(request, "Sorry, You have no access to this page! ")
        return redirect('accounts:sign_out')
    else:
        # logged_in_tutor_id = request.user.profile.tutor_profile.pk
        logged_in_user_id = request.user.pk
        # TEST INDENT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        if request.method == 'POST':
            try:
                # Decode JSON data from request body
                raw_data = request.body.decode('utf-8')
                data = json.loads(raw_data)
                print(f'Decoded JSON data: {data}')

                available_sessions = data.get('available_sessions', [])
                deletableTimeSlots = data.get('DeletableTimeSlots', [])
                print(f'deletableTimeSlots: {deletableTimeSlots}')
                if not (available_sessions or deletableTimeSlots):
                    return JsonResponse(
                        {'status': 'error', 'message': 'No available sessions provided. No for delete!'})

                # Bulk delete all ids which are in deletableTimeSlots list!
                Availability.objects.filter(id__in=deletableTimeSlots).delete()

                avails_to_create = []
                for avail_s in available_sessions:
                    # Validate required fields
                    if not all(key in avail_s for key in ['startTime', 'endTime', 'timezone', 'providerUId']):
                        return JsonResponse(
                            {'status': 'error', 'message': 'Missing required fields in available session.'})

                    if not (logged_in_user_id == int(avail_s.get('providerUId'))):
                        # Debugging lines (DELETE BEFORE LAUNCH) -------------------------------------
                        # s_tutor_obj = get_object_or_404(Tutor, id=int(avail_s.get('providerUId')))
                        # s_user_obj = get_object_or_404(User, id=int(avail_s.get('providerUId')))
                        # logged_in_tutor_obj = get_object_or_404(Tutor, id=logged_in_user_id)
                        # print(f'Session Tutor: {s_tutor_obj.profile.user.first_name}, {s_tutor_obj.profile.user.last_name}')
                        # print(f'Logged in Tutor: {logged_in_tutor_obj.profile.user.first_name}, {logged_in_tutor_obj.profile.user.last_name}')
                        messages.error(request, "You just authorized to define your available times. Not more!")
                        return redirect('accounts:sign_out')
                    # avail_tutor_obj = get_object_or_404(Tutor, id=int(avail_s.get('providerUId')))
                    avail_user_obj = get_object_or_404(User, id=int(avail_s.get('providerUId')))

                    start_time_str = avail_s.get('startTime', '')
                    end_time_str = avail_s.get('endTime', '')
                    #  CHECK WHY UTC ????????????????????????????????????????????????????????????????????????????
                    # tutor_timezone = avail_s.get('timezone', 'UTC')  # Get the tutor's time zone from the frontend
                    provider_timezone = avail_s.get('timezone', 'UTC')  # Get the provider's time zone from the frontend

                    # Validate timezone
                    try:
                        local_tz = pytz.timezone(provider_timezone)
                    except pytz.UnknownTimeZoneError:
                        return JsonResponse({'status': 'error', 'message': f'Invalid timezone: {provider_timezone}'})

                    # Parse and convert times
                    try:
                        # Use datetime.strptime to parse custom format
                        # start_avail_time_local = datetime.strptime(start_time_str, '%m/%d/%Y %H:%M')
                        start_avail_time_local = parse_date_time(start_time_str)
                        end_avail_time_local = parse_date_time(end_time_str)

                        # Localize and convert to UTC
                        start_avail_time_local = local_tz.localize(start_avail_time_local)
                        end_avail_time_local = local_tz.localize(end_avail_time_local)
                        start_avail_time_utc = start_avail_time_local.astimezone(pytz.UTC)
                        end_avail_time_utc = end_avail_time_local.astimezone(pytz.UTC)

                        # print(f'Start Avail Time (Local): {start_avail_time_local}, End Session (Local): {end_avail_time_local}')
                        # print(f'Start Avail Time (UTC): {start_avail_time_utc}, End Session (UTC): {end_avail_time_utc}')

                        # Create Availability object
                        availability = Availability(
                            # tutor=avail_tutor_obj,
                            user=avail_user_obj,
                            start_time_utc=start_avail_time_utc,
                            end_time_utc=end_avail_time_utc,
                            status='free',
                            is_available=True,
                        )
                        avails_to_create.append(availability)
                    except ValueError as e:
                        return JsonResponse({'status': 'error', 'message': f'Error parsing dates: {e}'})

                # Bulk create availabilities
                created_availabilities = Availability.objects.bulk_create(avails_to_create)
                for c_availability in created_availabilities:
                    c_availability.save()

                return JsonResponse({'status': 'success', 'message': 'Available times saved successfully.'})
            except Exception as e:
                return JsonResponse({'status': 'error', 'message': str(e)})
        else:
            return JsonResponse({'status': 'error', 'message': 'Invalid request method.'})


# save client (student -> client) reserved sessions
def reservation_single_client_MAIN(request):
    if request.method == 'POST':
        try:
            # Decode JSON data from request body
            raw_data = request.body.decode('utf-8')
            data = json.loads(raw_data)
            # print(f'Decoded JSON data: {data}')

            periods = data.get('periods', [])
            if not periods:
                return JsonResponse({'status': 'error', 'message': 'No periods provided.'})

            # Ensure the logged-in client is student or tutor (in interview process) is retrieved
            if request.user.profile.user_type in ['student', 'tutor']:
                client = request.user
            else:
                return JsonResponse({'status': 'error', 'message': 'You are not in defined client types!'})

            sessions_to_create = []
            for period in periods:
                # Validate required fields
                if not all(key in period for key in
                           ['subject', 'session_type', 'startTime', 'endTime', 'timezone', 'providerUId']):
                    return JsonResponse({'status': 'error', 'message': 'Missing required fields in period.'})

                providerUId = period.get('providerUId')
                # tutor_obj = get_object_or_404(Tutor, id=providerUId)
                provider_user_obj = get_object_or_404(User, id=providerUId)
                print(f'Provider: {provider_user_obj.first_name}, {provider_user_obj.last_name}')

                subject = period.get('subject', '')
                session_type = period.get('session_type', '')
                start_time_str = period.get('startTime', '')
                end_time_str = period.get('endTime', '')
                client_timezone = period.get('timezone', 'UTC')  # Get the user's time zone from the frontend

                # Validate timezone
                try:
                    local_tz = pytz.timezone(client_timezone)
                except pytz.UnknownTimeZoneError:
                    return JsonResponse({'status': 'error', 'message': f'Invalid timezone: {client_timezone}'})

                # Parse and convert times
                try:
                    # Use datetime.strptime to parse custom format
                    start_session_local = datetime.strptime(start_time_str, '%m/%d/%Y %H:%M')
                    end_session_local = datetime.strptime(end_time_str, '%m/%d/%Y %H:%M')

                    # Localize and convert to UTC
                    start_session_local = local_tz.localize(start_session_local)
                    end_session_local = local_tz.localize(end_session_local)
                    start_session_utc = start_session_local.astimezone(pytz.UTC)
                    end_session_utc = end_session_local.astimezone(pytz.UTC)

                    # Create session object
                    session = Session(
                        subject=subject,
                        session_type=session_type,
                        provider=provider_user_obj,
                        start_session_utc=start_session_utc,
                        end_session_utc=end_session_utc,
                        status='pending',
                    )
                    sessions_to_create.append(session)
                except ValueError as e:
                    return JsonResponse({'status': 'error', 'message': f'Error parsing dates: {e}'})

            for session in sessions_to_create:
                # by manually save each session we call session.generate_unique_appointment_id() for appointment_id
                session.save()
                session.clients.add(client)

                # Bulk create sessions
                # created_sessions = Session.objects.bulk_create(sessions_to_create)
                # for session in created_sessions:
                #     session.clients.add(client)
                if session.session_type == 'interview':
                    # applicant = ProviderApplication.objects.get(user=client)
                    applicant = Tutor.objects.get(profile__user=client)
                    applicant.status = 'scheduled'
                    applicant.save()
                    # handle sending email and related notifications
                    # interview_submit(request, session, client, start_session_local,  client_timezone, provider_user_obj)

            return JsonResponse({'status': 'success', 'message': 'Sessions reserved successfully.'})
        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)})
    else:
        return JsonResponse({'status': 'error', 'message': 'Invalid request method.'})


def reservation_single_client(request):
    if request.method == 'POST':
        try:
            # Decode JSON data from request body
            raw_data = request.body.decode('utf-8')
            data = json.loads(raw_data)

            periods = data.get('periods', [])
            if not periods:
                return JsonResponse({'status': 'error', 'message': 'No periods provided.'})

            # Ensure the logged-in client is student or tutor (in interview process) is retrieved
            if request.user.profile.user_type in ['student', 'tutor']:
                client = request.user
            else:
                return JsonResponse({'status': 'error', 'message': 'You are not in defined client types!'})

            sessions_to_create = []
            for period in periods:
                # Validate required fields
                if not all(key in period for key in
                           ['subject', 'session_type', 'startTime', 'endTime', 'timezone', 'providerUId']):
                    return JsonResponse({'status': 'error', 'message': 'Missing required fields in period.'})

                providerUId = period.get('providerUId')
                provider_user_obj = get_object_or_404(User, id=providerUId)

                subject = period.get('subject', '')
                session_type = period.get('session_type', '')
                start_time_str = period.get('startTime', '')
                end_time_str = period.get('endTime', '')
                client_timezone = period.get('timezone', 'UTC')

                try:
                    # Use the modular function to convert to UTC
                    start_session_utc = local_to_utc(date_str=start_time_str, date_format='%m/%d/%Y %H:%M',
                                                     timezone_str=client_timezone)
                    end_session_utc = local_to_utc(date_str=end_time_str, date_format='%m/%d/%Y %H:%M',
                                                   timezone_str=client_timezone)

                    # Create session object
                    session = Session(
                        subject=subject,
                        session_type=session_type,
                        provider=provider_user_obj,
                        start_session_utc=start_session_utc,
                        end_session_utc=end_session_utc,
                        status='pending',
                    )
                    sessions_to_create.append(session)
                except pytz.UnknownTimeZoneError:
                    return JsonResponse({'status': 'error', 'message': f'Invalid timezone: {client_timezone}'})
                except ValueError as e:
                    return JsonResponse({'status': 'error', 'message': f'Error parsing dates: {e}'})

            for session in sessions_to_create:
                session.save()
                session.clients.add(client)

                if session.session_type == 'interview':
                    # applicant = ProviderApplication.objects.get(user=client)
                    applicant = Tutor.objects.get(profile__user=client)
                    applicant.status = 'scheduled'
                    applicant.timezone = client_timezone  # set applicant timezone
                    applicant.save()

                    interview_submit(request, session, client, start_time_str, client_timezone, provider_user_obj)

            return JsonResponse({'status': 'success', 'message': 'Sessions reserved successfully.'})
        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)})
    else:
        return JsonResponse({'status': 'error', 'message': 'Invalid request method.'})


# Fetch Provider's Booked Sessions
def get_booked_sessions(request):
    providerUId = request.GET.get('providerUId')
    start_date_str = request.GET.get('startDate')

    if not providerUId or not start_date_str:
        return JsonResponse({'status': 'error', 'message': 'Missing parameters'}, status=400)

    try:
        # Parse the start date and make it timezone-aware
        start_date = timezone.datetime.strptime(start_date_str, '%Y-%m-%d').date()
        start_date = timezone.make_aware(timezone.datetime.combine(start_date, timezone.datetime.min.time()),
                                         timezone.get_current_timezone())
        # Calculate the end date (7 days later)
        end_date = start_date + timezone.timedelta(days=7)

        # Fetch booked sessions data for the provider within the date range
        sessions = Session.objects.filter(
            provider_id=providerUId,
            start_session_utc__gte=start_date,
            end_session_utc__lte=end_date,
        ).values('start_session_utc', 'end_session_utc', 'status')

        # Convert datetime objects to local time strings for JSON serialization
        booked_sessions_list = [
            {
                'start_session_utc': booked['start_session_utc'].isoformat(),
                'end_session_utc': booked['end_session_utc'].isoformat(),
                'status': booked['status'],
            }
            for booked in sessions
        ]

        # print(f"Start Date: {start_date}, End Date: {end_date}")
        # print(f"Availability Data: {booked_sessions_list}")

        return JsonResponse({'status': 'success', 'booked_sessions': booked_sessions_list})
    except Exception as e:
        return JsonResponse({'status': 'error', 'message': str(e)}, status=500)


# Fetch Provider (Tutor) free times (periods) to show on Schedule table
def get_availability(request):
    providerUId = request.GET.get('providerUId')
    start_date_str = request.GET.get('startDate')

    if not providerUId or not start_date_str:
        return JsonResponse({'status': 'error', 'message': 'Missing parameters'}, status=400)

    try:
        # Parse the start date and make it timezone-aware
        start_date = timezone.datetime.strptime(start_date_str, '%Y-%m-%d').date()
        start_date = timezone.make_aware(timezone.datetime.combine(start_date, timezone.datetime.min.time()),
                                         timezone.get_current_timezone())
        # Calculate the end date (7 days later)
        end_date = start_date + timezone.timedelta(days=7)

        # Fetch availability data for the provider (tutor) within the date range
        availability = Availability.objects.filter(
            user_id=providerUId,
            start_time_utc__gte=start_date,
            end_time_utc__lte=end_date,
            is_available=True
        ).values('id', 'start_time_utc', 'end_time_utc')

        # Convert datetime objects to local time strings for JSON serialization
        availability_list = [
            {
                'availId': avail['id'],  # pk or id of availability record
                'start_time_utc': avail['start_time_utc'].isoformat(),
                'end_time_utc': avail['end_time_utc'].isoformat(),
                # 'provider_timezone': avail['timezone'],
            }
            for avail in availability
        ]

        # print(f"Start Date: {start_date}, End Date: {end_date}")
        # print(f"Availability Data: {availability_list}")

        return JsonResponse({'status': 'success', 'availability': availability_list})
    except Exception as e:
        return JsonResponse({'status': 'error', 'message': str(e)}, status=500)


def update_session(request, session_id):
    session = get_object_or_404(Session, id=session_id)

    # Check if the logged-in user is the tutor for this session
    if not session.is_tutor(request.user):
        raise PermissionDenied("You can only modify your own sessions.")

    # Proceed with updating the session
    if request.method == 'POST':
        form = SessionForm(request.POST, instance=session)
        if form.is_valid():
            form.save()
            return redirect('session_detail', session_id=session.id)
    else:
        form = SessionForm(instance=session)

    return render(request, 'update_session.html', {'form': form})


def reschedule_session(request, session_id):
    session = get_object_or_404(Session, id=session_id)

    # Check if the logged-in user is the tutor or a student in the session
    if request.user != session.tutor.profile.user and request.user not in session.students.all():
        raise PermissionDenied("You do not have permission to reschedule this session.")

    # Proceed with rescheduling logic
    if request.method == 'POST':
        new_start_time = request.POST.get('new_start_time')
        session.rescheduled_start = new_start_time
        session.rescheduled_by = request.user
        session.is_rescheduled = True
        session.rescheduled_at = timezone.now()
        session.save()
        return redirect('session_detail', session_id=session.id)

    return render(request, 'reschedule_session.html')


def dashboard(request):
    return render(request, 'dashboard.html')


class SuccessSubmitView(LoginRequiredMixin, TemplateView):
    template_name = 'ap2_meeting/success_submit.html'


class DAppointmentsEdit(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, ListView):
    allowed_roles = ['tutor', 'admin', ]
    model = Availability
    template_name = 'ap2_meeting/dashboard/d_appointments_edit.html'
    # ordering = ['-profile__create_date']
    paginate_by = 10  # Number of items per page

    def get_queryset(self):
        # Assuming the logged-in user is a Tutor and you have a relationship between Tutor and UserProfile
        return Availability.objects.filter(tutor__profile__user=self.request.user).order_by('-start_time_utc')


class DAppointments(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, TemplateView):
    allowed_roles = ['tutor', 'admin']
    template_name = 'ap2_meeting/dashboard/d_appointments_manual.html'

    def dispatch(self, request, *args, **kwargs):
        if self.request.user.profile.user_type not in ['tutor', 'admin', 'interviewer']:
            err_title = f"Access Denied"
            err_msg = f"Sorry! You have no access to scheduling system!"
            messages.error(self.request, err_msg)
            return error_page(request, err_title, err_msg, 403)

        return super().dispatch(request, *args, **kwargs)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)

        try:
            # Get the appointment settings for the current user
            appointment_settings = AppointmentSetting.objects.get(user=self.request.user)
            timezone = appointment_settings.timezone
        except AppointmentSetting.DoesNotExist:
            timezone = None  # Default to None if not found

        # Handle timezone for date objects
        tz = pytz.timezone(timezone) if timezone else pytz.UTC
        context['today'] = datetime.now(tz).date()
        context['providerUId'] = self.request.user.id

        # Validate tutor profile existence to avoid errors
        if hasattr(self.request.user.profile, 'tutor_profile'):
            context['provider_id'] = self.request.user.profile.tutor_profile.id

        return context


class DAppointments_BACKUP(LoginRequiredMixin, TemplateView):
    template_name = 'ap2_meeting/dashboard/d_appointments_manual.html'

    def generate_weekdays(self, start_date):
        days_of_week = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
        weekdays = []
        for i in range(7):
            current_date = start_date + timedelta(days=i)
            weekdays.append({
                'day': days_of_week[current_date.weekday()],
                'date': current_date.strftime('%Y-%m-%d'),
                'abbr_day': days_of_week[current_date.weekday()][:3].upper(),
                'current_date': current_date  # Ensure this is a date object
            })
        return weekdays

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        tutor_profile = self.request.user.profile.tutor_profile
        appointment_settings = AppointmentSetting.objects.get(tutor=tutor_profile)
        provider_timezone = appointment_settings.provider_timezone
        tz = pytz.timezone(provider_timezone) if provider_timezone else pytz.UTC

        # Ensure today is a timezone-aware date object
        context['today'] = datetime.now(tz).date()

        # Generate weekdays with timezone-aware dates
        start_date_str = self.request.GET.get('start_date', None)
        if start_date_str:
            start_date = parse_date(start_date_str).date()
        else:
            start_date = context['today']

        start_day = appointment_settings.week_start
        start_date = start_date - timedelta(days=(start_date.weekday() - int(start_day)) % 7)
        context['weekdays'] = self.generate_weekdays(start_date)
        context['tutor_id'] = tutor_profile.id

        return context


def navigate_week_BACKUP(request, direction):
    week_offset = {
        'next': 7,
        'previous': -7,
        'current': 0
    }.get(direction, 0)

    start_date_str = request.GET.get('start_date', datetime.today().strftime('%m/%d/%Y'))
    start_date = datetime.strptime(start_date_str, '%m/%d/%Y') + timedelta(days=week_offset)
    return redirect(f'/schedule/dashboard/appointments/manual/?start_date={start_date.strftime("%m/%d/%Y")}')


class DAppointmentsVTable(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, TemplateView):
    allowed_roles = ['tutor', 'admin', ]
    template_name = 'ap2_meeting/dashboard/d_appointments_vtable.html'


class DAppointmentsSettings(LoginRequiredMixin, RoleRequiredMixin, ActivationRequiredMixin, FormView):
    allowed_roles = ['tutor', 'admin', ]
    template_name = 'ap2_meeting/dashboard/d_appointments_settings.html'
    form_class = AppointmentSettingForm
    success_url = reverse_lazy('meeting:d_appointments_settings')

    def get_initial(self):
        initial = super().get_initial()
        detected_timezone = self.request.POST.get('detected_timezone')
        print(f'detected_timezone: {detected_timezone}')
        if detected_timezone:
            initial['provider_timezone'] = detected_timezone
        return initial

    def get_form_kwargs(self):
        """Pass additional kwargs to the form."""
        kwargs = super().get_form_kwargs()
        try:
            # Fetch or create the tutor's appointment settings instance
            # tutor = self.request.user.profile.tutor_profile
            appointment_setting, created = AppointmentSetting.objects.get_or_create(user=self.request.user)
            kwargs['instance'] = appointment_setting
            print(f"Passed instance: {appointment_setting}")
        except Tutor.DoesNotExist:
            print("Provider instance does not exist.")
        return kwargs

    def form_valid(self, form):
        appointment_setting = form.save(commit=False)
        # appointment_setting.tutor = self.request.user.profile.tutor_profile
        appointment_setting.user = self.request.user
        appointment_setting.save()
        messages.success(self.request, "Your appointment settings have been saved successfully!")
        return super().form_valid(form)

    def form_invalid(self, form):
        print("Form is invalid")
        print(form.errors)
        return super().form_invalid(form)


def fetch_appointment_settings(request):
    # tutor = request.user.profile.tutor_profile
    try:
        # appointment_settings = AppointmentSetting.objects.get(tutor=tutor)
        appointment_settings = AppointmentSetting.objects.get(user=request.user)
        data = {
            'user_timezone': appointment_settings.timezone,
            'session_length': appointment_settings.session_length,
            'week_start': appointment_settings.week_start,
            'class_type': appointment_settings.session_type
        }
        return JsonResponse(data)
    except AppointmentSetting.DoesNotExist:
        return JsonResponse({'error': 'Appointment settings not found'}, status=404)


def interview_submit(request, session, client, start_session_local, client_timezone, provider):
    # utc_to_local(session.start_session_utc, client_timezone)
    # send email to applicant
    subject = f"🎯 Dear {client.first_name} {client.last_name}, You've scheduled your interview session."
    to_email = [client.email]
    template_name = 'emails/interview/success_after_schedule'
    # example:  2025-05-02 09:30:00+03:30
    local_datetime = utc_to_local(session.start_session_utc, client_timezone)
    local_date = local_datetime.date()
    local_time = local_datetime.time()
    context = {
        'full_name': f"{client.first_name} {client.last_name}",
        'scheduled_at': f"{local_date} at {local_time} ",
        'start_session_local': f"{start_session_local} at {local_time} ",
        'client_timezone': client_timezone,
        'dashboard_uri': request.build_absolute_uri(reverse('tutor:dp_wizard')),
        'site_name': settings.SITE_NAME,
    }
    print(f"scheduled_at: {context['scheduled_at']}")
    send_dual_email(subject, template_name, context, to_email)

    # send email to Admin
    notify_subject = f"🔔 New Interview scheduled by {client.first_name} {client.last_name}"
    notification_email_to_admin(notify_subject, 'emails/admin/interview_notify_scheduled', context)

    # send Notification to applicant

    # send Notification to Admin


@login_required
@csrf_exempt
def save_available_rule_times_MAIN_WORKING_EXCEPT_FOR_24(request):
    DAY_ABBR_TO_NUM = {
        'SUN': '0',
        'MON': '1',
        'TUE': '2',
        'WED': '3',
        'THU': '4',
        'FRI': '5',
        'SAT': '6',
    }

    if not request.user.is_authenticated:
        messages.error(request, "Sorry, You have no access to this page without login! Please sign in first.")
        return redirect('accounts:sign_in')

    # Ensure the logged-in TUTOR's profile is retrieved
    if request.user.profile.user_type not in ['admin', 'tutor', 'interviewer']:
        messages.error(request, "Sorry, You have no access to this page! ")
        return redirect('accounts:sign_out')

    logged_in_user_id = request.user.pk
    if request.method == 'POST':
        try:
            # Decode JSON data from request body
            raw_data = request.body.decode('utf-8')
            data = json.loads(raw_data)
            print(f'Decoded JSON data: {data}')

            available_sessions = data.get('available_sessions', [])
            deletableTimeSlots = data.get('DeletableTimeSlots', [])
            provider_timezone = data.get('timezone')  # Get timezone from request

            # Allow saving even if only timezone is changed (no new sessions or deletions)
            if not available_sessions and not deletableTimeSlots and not provider_timezone:
                return JsonResponse(
                    {'status': 'error', 'message': 'No available sessions provided. No for delete!'})

            # Bulk delete all ids which are in deletableTimeSlots list!
            if deletableTimeSlots:
                AvailableRule.objects.filter(id__in=deletableTimeSlots).delete()

            rules_to_create = []
            for avail_s in available_sessions:
                # Validate required fields
                if not all(key in avail_s for key in ['startTime', 'endTime', 'timezone', 'providerUId', 'day']):
                    return JsonResponse(
                        {'status': 'error', 'message': 'Missing required fields in available session.'})

                if not (logged_in_user_id == int(avail_s.get('providerUId'))):
                    messages.error(request, "You just authorized to define your available times. Not more!")
                    return redirect('accounts:sign_out')

                avail_user_obj = get_object_or_404(User, id=int(avail_s.get('providerUId')))
                session_timezone = avail_s.get('timezone', provider_timezone)  # Use session timezone if available
                day_abbr = avail_s.get('day')  # e.g. 'MON'
                day = DAY_ABBR_TO_NUM.get(day_abbr)  # returns '1'
                start_time_str = avail_s.get('startTime', '')
                end_time_str = avail_s.get('endTime', '')

                # ✅ Convert ONLY end time if it's 24:00, leave start time as is
                if end_time_str == '24:00':
                    end_time_str = '23:59:59'

                # Validate timezone
                try:
                    local_tz = pytz.timezone(session_timezone)
                except pytz.UnknownTimeZoneError:
                    return JsonResponse({'status': 'error', 'message': f'Invalid timezone: {session_timezone}'})

                # Parse and convert times
                try:
                    # Parse time strings
                    start_time_utc = localTime_to_utcTime(start_time_str, session_timezone)
                    end_time_utc = localTime_to_utcTime(end_time_str, session_timezone)
                    # print(f'start_time: {start_time_utc}, end_time: {end_time_utc}')

                    # Create AvailableRule object
                    available_rule = AvailableRule(
                        user=avail_user_obj,
                        weekday=day,
                        start_time_utc=start_time_utc,
                        end_time_utc=end_time_utc,
                        status='free',
                        is_available=True,
                    )
                    available_rule.clean()
                    rules_to_create.append(available_rule)
                except ValidationError as e:
                    return JsonResponse({'status': 'error', 'message': f'Validation error: {e}'})

            # Bulk create available rules
            if rules_to_create:
                AvailableRule.objects.bulk_create(rules_to_create)
                print('bulk timeslot is saving ...')

            # Always update timezone in AppointmentSetting (even if no new sessions)
            if provider_timezone:
                try:
                    user_settings = AppointmentSetting.objects.get(user__id=logged_in_user_id)
                    user_settings.timezone = provider_timezone
                    user_settings.save()
                except AppointmentSetting.DoesNotExist:
                    # Create new AppointmentSetting if it doesn't exist
                    user_settings = AppointmentSetting.objects.create(
                        user=request.user,
                        timezone=provider_timezone
                    )
                    user_settings.save()

            # Update tutor profile status if inactive
            if (request.user.profile and not request.user.profile.is_active):
                profile = request.user.profile
                profile.tutor_profile.status = 'added_availability'
                profile.tutor_profile.save()

            return JsonResponse({'status': 'success', 'message': 'Available times saved successfully.'})
        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)})
    else:
        return JsonResponse({'status': 'error', 'message': 'Invalid request method.'})

@login_required
def get_available_rules_MAIN_DEL(request):
    providerUId = request.GET.get('providerUId') or request.user.id

    if not providerUId:
        return JsonResponse({'status': 'error', 'message': 'Missing parameters!'}, status=400)

    try:
        # Get or create AppointmentSetting with default timezone
        user_settings, created = AppointmentSetting.objects.get_or_create(
            user__id=providerUId,
            defaults={'timezone': 'UTC'}  # Default timezone
        )
        user_timezone = user_settings.timezone

        # Fetch availability rules for the provider
        availability_rules = AvailableRule.objects.filter(
            user_id=providerUId,
            is_available=True
        ).values('id', 'weekday', 'start_time_utc', 'end_time_utc')

        # Convert time objects to strings for JSON serialization
        availability_list = [
            {
                'availId': rule['id'],
                'weekday': rule['weekday'],
                'start_time_utc': rule['start_time_utc'].strftime('%H:%M'),
                'end_time_utc': rule['end_time_utc'].strftime('%H:%M'),
            }
            for rule in availability_rules
        ]

        return JsonResponse({'status': 'success', 'timezone': user_timezone, 'availability': availability_list})
    except Exception as e:
        return JsonResponse({'status': 'error', 'message': str(e)}, status=500)



@login_required
@csrf_exempt
def save_available_rule_times(request):
    DAY_ABBR_TO_NUM = {
        'SUN': '0', 'MON': '1', 'TUE': '2', 'WED': '3',
        'THU': '4', 'FRI': '5', 'SAT': '6',
    }

    if not request.user.is_authenticated:
        return JsonResponse({'status': 'error', 'message': 'Authentication required'}, status=401)

    if request.user.profile.user_type not in ['admin', 'tutor', 'interviewer']:
        return JsonResponse({'status': 'error', 'message': 'Permission denied'}, status=403)

    if request.method != 'POST':
        return JsonResponse({'status': 'error', 'message': 'Invalid request method'}, status=405)

    try:
        data = json.loads(request.body)
        available_sessions = data.get('available_sessions', [])
        deletableTimeSlots = data.get('DeletableTimeSlots', [])
        provider_timezone = data.get('timezone')

        # Delete requested slots
        if deletableTimeSlots:
            AvailableRule.objects.filter(id__in=deletableTimeSlots, user=request.user).delete()

        rules_to_create = []
        for avail_s in available_sessions:
            # Validate required fields
            required_fields = ['startTime', 'endTime', 'timezone', 'providerUId', 'day']
            if not all(key in avail_s for key in required_fields):
                return JsonResponse({'status': 'error', 'message': 'Missing required fields'}, status=400)

            # Authorization check
            if request.user.id != int(avail_s.get('providerUId')):
                return JsonResponse({'status': 'error', 'message': 'Unauthorized'}, status=403)

            # Parse data
            session_timezone = avail_s.get('timezone', provider_timezone)
            day_abbr = avail_s.get('day')
            day = DAY_ABBR_TO_NUM.get(day_abbr)
            start_time_str = avail_s.get('startTime', '')
            end_time_str = avail_s.get('endTime', '')

            # Check for full-day slot
            is_full_day = (start_time_str == '00:00' and end_time_str == '24:00')

            # Handle 24:00 case - convert to 23:59:59 for database
            if end_time_str == '24:00':
                end_time_str = '23:59:59'

            # Validate timezone
            try:
                pytz.timezone(session_timezone)
            except pytz.UnknownTimeZoneError:
                return JsonResponse({'status': 'error', 'message': f'Invalid timezone: {session_timezone}'}, status=400)

            # Convert to UTC
            try:
                start_time_utc = localTime_to_utcTime(start_time_str, session_timezone)
                end_time_utc = localTime_to_utcTime(end_time_str, session_timezone)
            except ValueError as e:
                return JsonResponse({'status': 'error', 'message': f'Error parsing times: {e}'}, status=400)

            # Create AvailableRule object
            available_rule = AvailableRule(
                user=request.user,
                weekday=day,
                start_time_utc=start_time_utc,
                end_time_utc=end_time_utc,
                status='free',
                is_available=True,
                is_full_day=is_full_day
            )

            # Validate (skip validation for full-day slots)
            if not is_full_day:
                try:
                    available_rule.clean()
                except ValidationError as e:
                    return JsonResponse({'status': 'error', 'message': f'Validation error: {e}'}, status=400)

            rules_to_create.append(available_rule)

        # Bulk create
        if rules_to_create:
            AvailableRule.objects.bulk_create(rules_to_create)

        # Update timezone settings
        if provider_timezone:
            AppointmentSetting.objects.update_or_create(
                user=request.user,
                defaults={'timezone': provider_timezone}
            )

        # Update tutor profile status
        if hasattr(request.user, 'profile') and not request.user.profile.is_active:
            request.user.profile.tutor_profile.status = 'added_availability'
            request.user.profile.tutor_profile.save()

        return JsonResponse({'status': 'success', 'message': 'Available times saved successfully.'})

    except json.JSONDecodeError:
        return JsonResponse({'status': 'error', 'message': 'Invalid JSON'}, status=400)
    except Exception as e:
        return JsonResponse({'status': 'error', 'message': str(e)}, status=500)


@login_required
def get_available_rules22(request):
    providerUId = request.GET.get('providerUId') or request.user.id
    viewer_timezone = request.GET.get('timezone')  # Get viewer's timezone

    if not providerUId:
        return JsonResponse({'status': 'error', 'message': 'Missing parameters!'}, status=400)

    try:
        # Get provider's timezone
        user_settings = AppointmentSetting.objects.filter(user__id=providerUId).first()
        provider_timezone = user_settings.timezone if user_settings else 'UTC'

        # Use viewer's timezone if provided, otherwise use provider's timezone
        display_timezone = viewer_timezone or provider_timezone

        # Fetch availability rules
        availability_rules = AvailableRule.objects.filter(
            user_id=providerUId,
            is_available=True
        ).values('id', 'weekday', 'start_time_utc', 'end_time_utc', 'is_full_day')

        availability_list = []
        for rule in availability_rules:
            # SIMPLIFIED: For now, just convert UTC times to display timezone
            # This avoids complex cross-day logic that might be causing issues

            if rule['is_full_day']:
                # For full-day slots, show as 00:00-24:00 in the display timezone
                availability_list.append({
                    'availId': rule['id'],
                    'weekday': rule['weekday'],
                    'start_time_local': '00:00',
                    'end_time_local': '24:00',
                    'is_full_day': True
                })
            else:
                # Convert UTC to display timezone
                start_local = utcTime_to_localTime(rule['start_time_utc'], display_timezone)
                end_local = utcTime_to_localTime(rule['end_time_utc'], display_timezone)

                availability_list.append({
                    'availId': rule['id'],
                    'weekday': rule['weekday'],
                    'start_time_local': start_local,
                    'end_time_local': end_local,
                    'is_full_day': False
                })

        return JsonResponse({
            'status': 'success',
            'provider_timezone': provider_timezone,
            'display_timezone': display_timezone,
            'availability': availability_list
        })

    except Exception as e:
        return JsonResponse({'status': 'error', 'message': str(e)}, status=500)


# ------------------------------------------------
@login_required
def get_available_rules(request):
    providerUId = request.GET.get('providerUId') or request.user.id
    viewer_timezone = request.GET.get('timezone')

    if not providerUId:
        return JsonResponse({'status': 'error', 'message': 'Missing parameters!'}, status=400)

    try:
        # Get provider's timezone
        user_settings = AppointmentSetting.objects.filter(user__id=providerUId).first()
        provider_timezone = user_settings.timezone if user_settings else 'UTC'

        # Use viewer's timezone if provided, otherwise use provider's timezone
        display_timezone = viewer_timezone or provider_timezone

        # Fetch availability rules
        availability_rules = AvailableRule.objects.filter(
            user_id=providerUId,
            is_available=True
        ).values('id', 'weekday', 'start_time_utc', 'end_time_utc', 'is_full_day')

        availability_list = []
        for rule in availability_rules:
            if rule['is_full_day']:
                # Handle full-day slots - these need special cross-timezone handling
                availability_list.extend(handle_full_day_cross_timezone(rule, provider_timezone, display_timezone))
            else:
                # Handle regular time slots
                availability_list.extend(handle_regular_slot_cross_timezone(rule, provider_timezone, display_timezone))

        return JsonResponse({
            'status': 'success',
            'provider_timezone': provider_timezone,
            'display_timezone': display_timezone,
            'availability': availability_list
        })

    except Exception as e:
        return JsonResponse({'status': 'error', 'message': str(e)}, status=500)


def handle_full_day_cross_timezone(rule, provider_timezone, display_timezone):
    """
    Handle full-day slots that may span multiple days in different timezones
    """
    results = []

    # Get timezone objects
    provider_tz = pytz.timezone(provider_timezone)
    display_tz = pytz.timezone(display_timezone)

    # Create a reference date (we'll use today)
    ref_date = date.today()

    # Calculate the actual date for this weekday
    # Convert weekday string to integer
    weekday_int = int(rule['weekday'])

    # Find the next occurrence of this weekday
    days_ahead = (weekday_int - ref_date.weekday()) % 7
    target_date = ref_date + timedelta(days=days_ahead)

    # Get the start and end of the day in provider's timezone
    day_start_provider = provider_tz.localize(datetime.combine(target_date, time(0, 0, 0)))
    day_end_provider = provider_tz.localize(datetime.combine(target_date, time(23, 59, 59)))

    # Convert to display timezone
    day_start_display = day_start_provider.astimezone(display_tz)
    day_end_display = day_end_provider.astimezone(display_tz)

    # If the full day spans multiple days in display timezone, split it
    if day_start_display.date() != day_end_display.date():
        # First day
        first_day_end = display_tz.localize(datetime.combine(day_start_display.date(), time(23, 59, 59)))
        results.append({
            'availId': f"{rule['id']}_part1",
            'weekday': str(day_start_display.weekday()),
            'start_time_local': day_start_display.time().strftime('%H:%M'),
            'end_time_local': '24:00',
            'is_full_day': False,
            'is_partial_day': True,
            'original_weekday': rule['weekday']
        })

        # Last day
        last_day_start = display_tz.localize(datetime.combine(day_end_display.date(), time(0, 0, 0)))
        results.append({
            'availId': f"{rule['id']}_part2",
            'weekday': str(day_end_display.weekday()),
            'start_time_local': '00:00',
            'end_time_local': day_end_display.time().strftime('%H:%M'),
            'is_full_day': False,
            'is_partial_day': True,
            'original_weekday': rule['weekday']
        })
    else:
        # Single day in display timezone
        results.append({
            'availId': rule['id'],
            'weekday': str(day_start_display.weekday()),
            'start_time_local': '00:00',
            'end_time_local': '24:00',
            'is_full_day': True,
            'original_weekday': rule['weekday']
        })

    return results


def handle_regular_slot_cross_timezone(rule, provider_timezone, display_timezone):
    """
    Handle regular time slots with cross-timezone conversion
    """
    results = []

    provider_tz = pytz.timezone(provider_timezone)
    display_tz = pytz.timezone(display_timezone)

    # Create a reference date (we'll use today)
    ref_date = date.today()

    # Calculate the actual date for this weekday
    weekday_int = int(rule['weekday'])
    days_ahead = (weekday_int - ref_date.weekday()) % 7
    target_date = ref_date + timedelta(days=days_ahead)

    # Convert UTC times to datetime objects with the correct date
    start_utc = pytz.UTC.localize(datetime.combine(target_date, rule['start_time_utc']))
    end_utc = pytz.UTC.localize(datetime.combine(target_date, rule['end_time_utc']))

    # Convert to display timezone
    start_display = start_utc.astimezone(display_tz)
    end_display = end_utc.astimezone(display_tz)

    # Check if the slot spans multiple days in display timezone
    if start_display.date() != end_display.date():
        # First day part
        first_day_end = display_tz.localize(datetime.combine(start_display.date(), time(23, 59, 59)))
        results.append({
            'availId': f"{rule['id']}_part1",
            'weekday': str(start_display.weekday()),
            'start_time_local': start_display.time().strftime('%H:%M'),
            'end_time_local': '24:00',
            'is_full_day': False,
            'is_partial_day': True,
            'original_weekday': rule['weekday']
        })

        # Last day part
        last_day_start = display_tz.localize(datetime.combine(end_display.date(), time(0, 0, 0)))
        results.append({
            'availId': f"{rule['id']}_part2",
            'weekday': str(end_display.weekday()),
            'start_time_local': '00:00',
            'end_time_local': end_display.time().strftime('%H:%M'),
            'is_full_day': False,
            'is_partial_day': True,
            'original_weekday': rule['weekday']
        })
    else:
        # Single day in display timezone
        results.append({
            'availId': rule['id'],
            'weekday': str(start_display.weekday()),
            'start_time_local': start_display.time().strftime('%H:%M'),
            'end_time_local': end_display.time().strftime('%H:%M'),
            'is_full_day': False,
            'original_weekday': rule['weekday']
        })

    return results