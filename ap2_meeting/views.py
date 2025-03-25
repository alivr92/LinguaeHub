from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse_lazy
from django.contrib import messages, auth
from django.contrib.auth.mixins import LoginRequiredMixin
from django.views.generic import TemplateView, ListView, FormView
import json
from django.http import JsonResponse
from .models import Session, Availability, AppointmentSetting
from ap2_tutor.models import Tutor
from django.views.decorators.csrf import csrf_exempt
from django.utils import timezone
from datetime import datetime, timedelta
import pytz  # For time zone handling (Python Time Zone)
from django.core.exceptions import PermissionDenied
from .forms import SessionForm, AppointmentSettingForm
import logging
from django.utils.dateparse import parse_datetime

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


# save available tutor times
@csrf_exempt
def save_available_tutor_times(request):
    if not request.user.is_authenticated:
        messages.error(request, "Sorry, You have no access to this page without login! Please sign in first.")
        return redirect('accounts:sign_in')

    # Ensure the logged-in TUTOR's profile is retrieved
    if not request.user.profile.tutor_profile:
        messages.error(request, "Sorry, You should be a tutor to have access to this page! ")
        return redirect('accounts:sign_out')
    else:
        logged_in_tutor_id = request.user.profile.tutor_profile.pk
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
                    if not all(key in avail_s for key in ['startTime', 'endTime', 'timezone', 'tutorId']):
                        return JsonResponse(
                            {'status': 'error', 'message': 'Missing required fields in available session.'})

                    if not (logged_in_tutor_id == int(avail_s.get('tutorId'))):
                        # Debugging lines (DELETE BEFORE LAUNCH) -------------------------------------
                        s_tutor_obj = get_object_or_404(Tutor, id=int(avail_s.get('tutorId')))
                        logged_in_tutor_obj = get_object_or_404(Tutor, id=logged_in_tutor_id)
                        print(
                            f'Session Tutor: {s_tutor_obj.profile.user.first_name}, {s_tutor_obj.profile.user.last_name}')
                        print(
                            f'Logged in Tutor: {logged_in_tutor_obj.profile.user.first_name}, {logged_in_tutor_obj.profile.user.last_name}')
                        messages.error(request, "You just authorized to define your available times. Not more!")
                        return redirect('accounts:sign_out')
                    avail_tutor_obj = get_object_or_404(Tutor, id=int(avail_s.get('tutorId')))

                    start_time_str = avail_s.get('startTime', '')
                    end_time_str = avail_s.get('endTime', '')
                    #  CHECK WHY UTC ????????????????????????????????????????????????????????????????????????????
                    tutor_timezone = avail_s.get('timezone', 'UTC')  # Get the tutor's time zone from the frontend

                    # Validate timezone
                    try:
                        local_tz = pytz.timezone(tutor_timezone)
                    except pytz.UnknownTimeZoneError:
                        return JsonResponse({'status': 'error', 'message': f'Invalid timezone: {tutor_timezone}'})

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

                        print(
                            f'Start Avail Time (Local): {start_avail_time_local}, End Session (Local): {end_avail_time_local}')
                        print(
                            f'Start Avail Time (UTC): {start_avail_time_utc}, End Session (UTC): {end_avail_time_utc}')

                        # Create Availability object
                        availability = Availability(
                            tutor=avail_tutor_obj,
                            start_time_utc=start_avail_time_utc,
                            end_time_utc=end_avail_time_utc,
                            tutor_timezone=tutor_timezone,
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


# save student reserved sessions
def reservation_single_student(request):
    if request.method == 'POST':
        try:
            # Decode JSON data from request body
            raw_data = request.body.decode('utf-8')
            data = json.loads(raw_data)
            print(f'Decoded JSON data: {data}')

            periods = data.get('periods', [])
            if not periods:
                return JsonResponse({'status': 'error', 'message': 'No periods provided.'})

            # Ensure the logged-in student's profile is retrieved
            student_profile = request.user.profile.student_profile

            sessions_to_create = []
            for period in periods:
                # Validate required fields
                if not all(key in period for key in ['startTime', 'endTime', 'timezone', 'tutorId']):
                    return JsonResponse({'status': 'error', 'message': 'Missing required fields in period.'})

                tutor_id = period.get('tutorId')
                tutor_obj = get_object_or_404(Tutor, id=tutor_id)
                print(f'Tutor: {tutor_obj.profile.user.first_name}, {tutor_obj.profile.user.last_name}')

                start_time_str = period.get('startTime', '')
                end_time_str = period.get('endTime', '')
                student_timezone = period.get('timezone', 'UTC')  # Get the user's time zone from the frontend

                # Validate timezone
                try:
                    local_tz = pytz.timezone(student_timezone)
                except pytz.UnknownTimeZoneError:
                    return JsonResponse({'status': 'error', 'message': f'Invalid timezone: {student_timezone}'})

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

                    print(f'Start Session (Local): {start_session_local}, End Session (Local): {end_session_local}')
                    print(f'Start Session (UTC): {start_session_utc}, End Session (UTC): {end_session_utc}')

                    # Create session object
                    session = Session(
                        subject='Piano Class (Test)',
                        session_type='private',
                        tutor=tutor_obj,
                        start_session_utc=start_session_utc,
                        end_session_utc=end_session_utc,
                        students_timezone=student_timezone,
                        status='pending',
                    )
                    sessions_to_create.append(session)
                except ValueError as e:
                    return JsonResponse({'status': 'error', 'message': f'Error parsing dates: {e}'})

            # Bulk create sessions
            created_sessions = Session.objects.bulk_create(sessions_to_create)
            for session in created_sessions:
                session.students.add(student_profile)

            return JsonResponse({'status': 'success', 'message': 'Sessions reserved successfully.'})
        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)})
    else:
        return JsonResponse({'status': 'error', 'message': 'Invalid request method.'})


# Tutor in dashboard save his/her free times (periods)


# Fetch Tutor's Booked Sessions
def get_booked_sessions(request):
    tutor_id = request.GET.get('tutorId')
    start_date_str = request.GET.get('startDate')

    if not tutor_id or not start_date_str:
        return JsonResponse({'status': 'error', 'message': 'Missing parameters'}, status=400)

    try:
        # Parse the start date and make it timezone-aware
        start_date = timezone.datetime.strptime(start_date_str, '%Y-%m-%d').date()
        start_date = timezone.make_aware(timezone.datetime.combine(start_date, timezone.datetime.min.time()),
                                         timezone.get_current_timezone())
        # Calculate the end date (7 days later)
        end_date = start_date + timezone.timedelta(days=7)

        # Fetch booked sessions data for the tutor within the date range
        sessions = Session.objects.filter(
            tutor_id=tutor_id,
            start_session_utc__gte=start_date,
            end_session_utc__lte=end_date,
        ).values('start_session_utc', 'end_session_utc', 'tutor_timezone', 'status')

        # Convert datetime objects to local time strings for JSON serialization
        booked_sessions_list = [
            {
                'start_session_utc': booked['start_session_utc'].isoformat(),
                'end_session_utc': booked['end_session_utc'].isoformat(),
                'tutor_timezone': booked['tutor_timezone'],
                'status': booked['status'],
            }
            for booked in sessions
        ]

        print(f"Start Date: {start_date}, End Date: {end_date}")
        print(f"Availability Data: {booked_sessions_list}")

        return JsonResponse({'status': 'success', 'booked_sessions': booked_sessions_list})
    except Exception as e:
        return JsonResponse({'status': 'error', 'message': str(e)}, status=500)


# Fetch Tutor free times (periods) to show on Schedule table
def get_availability(request):
    tutor_id = request.GET.get('tutorId')
    start_date_str = request.GET.get('startDate')

    if not tutor_id or not start_date_str:
        return JsonResponse({'status': 'error', 'message': 'Missing parameters'}, status=400)

    try:
        # Parse the start date and make it timezone-aware
        start_date = timezone.datetime.strptime(start_date_str, '%Y-%m-%d').date()
        start_date = timezone.make_aware(timezone.datetime.combine(start_date, timezone.datetime.min.time()),
                                         timezone.get_current_timezone())
        # Calculate the end date (7 days later)
        end_date = start_date + timezone.timedelta(days=7)

        # Fetch availability data for the tutor within the date range
        availability = Availability.objects.filter(
            tutor_id=tutor_id,
            start_time_utc__gte=start_date,
            end_time_utc__lte=end_date,
            is_available=True
        ).values('id', 'start_time_utc', 'end_time_utc', 'tutor_timezone')

        # Convert datetime objects to local time strings for JSON serialization
        availability_list = [
            {
                'availId': avail['id'],  # pk or id of availability record
                'start_time_utc': avail['start_time_utc'].isoformat(),
                'end_time_utc': avail['end_time_utc'].isoformat(),
                'tutor_timezone': avail['tutor_timezone'],
            }
            for avail in availability
        ]

        print(f"Start Date: {start_date}, End Date: {end_date}")
        print(f"Availability Data: {availability_list}")

        return JsonResponse({'status': 'success', 'availability': availability_list})
    except Exception as e:
        return JsonResponse({'status': 'error', 'message': str(e)}, status=500)


def get_availability11(request):
    tutor_id = request.GET.get('tutorId')
    start_date_str = request.GET.get('startDate')

    if not tutor_id or not start_date_str:
        return JsonResponse({'status': 'error', 'message': 'Missing parameters'}, status=400)

    try:
        # Parse the start date and make it timezone-aware
        start_date = timezone.datetime.strptime(start_date_str, '%Y-%m-%d').date()
        start_date = timezone.make_aware(timezone.datetime.combine(start_date, timezone.datetime.min.time()),
                                         timezone.get_current_timezone())
        # Calculate the end date (7 days later)
        end_date = start_date + timezone.timedelta(days=7)

        # Fetch availability data for the tutor within the date range
        availability = Availability.objects.filter(
            tutor_id=tutor_id,
            start_time_utc__gte=start_date,
            end_time_utc__lt=end_date,
            is_available=True
        ).values('start_time', 'end_time')

        # Convert datetime objects to local time strings for JSON serialization
        availability_list = [
            {
                'start_time': timezone.localtime(avail['start_time']).isoformat(),
                'end_time': timezone.localtime(avail['end_time']).isoformat(),
            }
            for avail in availability
        ]

        return JsonResponse({'status': 'success', 'availability': availability_list})
    except Exception as e:
        return JsonResponse({'status': 'error', 'message': str(e)}, status=500)


# def update_session2(request, session_id):
#     session = get_object_or_404(Session, id=session_id)
#
#     # Check if the logged-in user is the tutor for this session
#     if request.user != session.tutor.profile.user:
#         raise PermissionDenied("You can only modify your own sessions.")
#
#     if request.method == 'POST':
#         form = SessionForm(request.POST, instance=session)
#         if form.is_valid():
#             form.save()
#             return redirect('session_detail', session_id=session.id)
#     else:
#         form = SessionForm(instance=session)
#
#     return render(request, 'update_session.html', {'form': form})


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


def update_session1(request, session_id):
    # session_id must be the pk in the Session table
    session = Session.objects.get(id=session_id)

    # Check if the logged-in user is the tutor for this session
    if request.user != session.tutor.profile.user:
        raise PermissionDenied("You do not have permission to modify this session.")

    # Proceed with updating the session
    # if request.method == 'POST':
    #     session.rescheduled_start = new_start_time
    #     session.rescheduled_by = request.user  # The user who initiated the rescheduling
    #     session.is_rescheduled = True
    #     session.rescheduled_at = timezone.now()
    #     session.save()
    #     form = SessionForm(request.POST, instance=session)
    #     if form.is_valid():
    #         form.save()
    #         return redirect('session_detail', session_id=session.id)
    # else:
    #     form = SessionForm(instance=session)
    #
    # return render(request, 'update_session.html', {'form': form})


def dashboard(request):
    return render(request, 'dashboard.html')


class SuccessSubmitView(TemplateView):
    template_name = 'ap2_meeting/success_submit.html'


# class DAppointments(LoginRequiredMixin, TemplateView):
#     template_name = 'ap2_meeting/dashboard/d_appointments_manual.html'
#
#     def generate_weekdays(self, start_date):
#         days_of_week = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
#         weekdays = []
#         for i in range(7):
#             current_date = start_date + timedelta(days=i)
#             weekdays.append({
#                 'day': days_of_week[current_date.weekday()],
#                 'date': current_date.strftime('%m/%d/%Y'),
#                 'abbr_day': days_of_week[current_date.weekday()][:3].upper(),
#                 'current_date': current_date
#             })
#         return weekdays
#
#     def get_context_data(self, **kwargs):
#         context = super().get_context_data(**kwargs)
#         start_day = self.request.GET.get('start_day', 'Sunday')  # Default to Sunday if not specified
#         today = datetime.today()
#         days_of_week = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
#         start_day_index = days_of_week.index(start_day)
#         start_date = today - timedelta(days=(today.weekday() - start_day_index) % 7)
#         context['weekdays'] = self.generate_weekdays(start_date)
#         context['today'] = today
#         return context


class DAppointmentsEdit(LoginRequiredMixin, ListView):
    model = Availability
    template_name = 'ap2_meeting/dashboard/d_appointments_edit.html'
    # ordering = ['-profile__create_date']
    paginate_by = 10  # Number of items per page

    def get_queryset(self):
        # Assuming the logged-in user is a Tutor and you have a relationship between Tutor and UserProfile
        return Availability.objects.filter(tutor__profile__user=self.request.user).order_by('-start_time_utc')


class DAppointmentsEdit1_DELETE(LoginRequiredMixin, TemplateView):
    template_name = 'ap2_meeting/dashboard/d_appointments_edit.html'

    def generate_weekdays(self, start_date):
        days_of_week = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
        weekdays = []
        for i in range(7):
            current_date = start_date + timedelta(days=i)
            weekdays.append({
                'day': days_of_week[current_date.weekday()],
                'date': current_date.strftime('%m/%d/%Y'),
                'abbr_day': days_of_week[current_date.weekday()][:3].upper(),
                'current_date': current_date
            })
        return weekdays

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        start_day = self.request.GET.get('start_day', 'Sunday')  # Default to Sunday if not specified
        today = datetime.today()
        days_of_week = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
        start_day_index = days_of_week.index(start_day)
        start_date = today - timedelta(days=(today.weekday() - start_day_index) % 7)
        context['weekdays'] = self.generate_weekdays(start_date)
        context['today'] = today
        return context


# from dateutil.parser import parse as parse_date

class DAppointments(LoginRequiredMixin, TemplateView):
    template_name = 'ap2_meeting/dashboard/d_appointments_manual.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        tutor_profile = self.request.user.profile.tutor_profile
        appointment_settings = AppointmentSetting.objects.get(tutor=tutor_profile)
        provider_timezone = appointment_settings.provider_timezone
        tz = pytz.timezone(provider_timezone) if provider_timezone else pytz.UTC
        # Ensure today is a timezone-aware date object
        context['today'] = datetime.now(tz).date()
        # Generate weekdays with timezone-aware dates
        context['tutor_id'] = tutor_profile.id
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


class DAppointmentsVTable(LoginRequiredMixin, TemplateView):
    template_name = 'ap2_meeting/dashboard/d_appointments_vtable.html'


class DAppointmentsSettings(LoginRequiredMixin, FormView):
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
            tutor = self.request.user.profile.tutor_profile
            appointment_setting, created = AppointmentSetting.objects.get_or_create(tutor=tutor)
            kwargs['instance'] = appointment_setting
            print(f"Passed instance: {appointment_setting}")
        except Tutor.DoesNotExist:
            print("Tutor instance does not exist.")
        return kwargs

    def form_valid(self, form):
        appointment_setting = form.save(commit=False)
        appointment_setting.tutor = self.request.user.profile.tutor_profile
        appointment_setting.save()
        messages.success(self.request, "Your appointment settings have been saved successfully!")
        return super().form_valid(form)

    def form_invalid(self, form):
        print("Form is invalid")
        print(form.errors)
        return super().form_invalid(form)


def fetch_appointment_settings(request):
    tutor = request.user.profile.tutor_profile
    try:
        appointment_settings = AppointmentSetting.objects.get(tutor=tutor)
        data = {
            'provider_timezone': appointment_settings.provider_timezone,
            'session_length': appointment_settings.session_length,
            'week_start': appointment_settings.week_start,
            'class_type': appointment_settings.session_type
        }
        return JsonResponse(data)
    except AppointmentSetting.DoesNotExist:
        return JsonResponse({'error': 'Appointment settings not found'}, status=404)
