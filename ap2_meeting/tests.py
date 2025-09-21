from django.test import TestCase
# Create your tests here.
# from django.core.exceptions import ValidationError
# # from django.utils import timezone
# # from .models import Session, Tutor, User, Student
# from django.test import TestCase, Client
# from django.urls import reverse
# from django.contrib.auth.models import User
# from .models import Session, Tutor, Student
# #
# #
# # class SessionModelTests(TestCase):
# #     def setUp(self):
# #         self.user = User.objects.create(username='tutor1')
# #         self.tutor = Tutor.objects.create(profile=self.user)
# #         self.student = Student.objects.create(profile=self.user)
# #         self.start_time = timezone.now()
# #         self.end_time = self.start_time + timezone.timedelta(hours=1)
# #
# #     def test_start_before_end(self):
# #         # Test that start_session must be before end_session
# #         session = Session(
# #             subject='Math',
# #             tutor=self.tutor,
# #             start_session=self.end_time,
# #             end_session=self.start_time,
# #         )
# #         with self.assertRaises(ValidationError):
# #             session.full_clean()
# #
# #     def test_no_overlapping_sessions(self):
# #         # Create a session
# #         Session.objects.create(
# #             subject='Math',
# #             tutor=self.tutor,
# #             start_session=self.start_time,
# #             end_session=self.end_time,
# #         )
# #
# #         # Try to create an overlapping session
# #         overlapping_session = Session(
# #             subject='Science',
# #             tutor=self.tutor,
# #             start_session=self.start_time + timezone.timedelta(minutes=30),
# #             end_session=self.end_time + timezone.timedelta(minutes=30),
# #         )
# #         with self.assertRaises(ValidationError):
# #             overlapping_session.full_clean()



# class SessionViewTests(TestCase):
#     def setUp(self):
#         self.client = Client()
#         self.user1 = User.objects.create_user(username='tutor1', password='password123')
#         self.user2 = User.objects.create_user(username='tutor2', password='password123')
#         self.tutor1 = Tutor.objects.create(profile=self.user1)
#         self.tutor2 = Tutor.objects.create(profile=self.user2)
#         self.session = Session.objects.create(
#             subject='Math',
#             tutor=self.tutor1,
#             start_session=timezone.now(),
#             end_session=timezone.now() + timezone.timedelta(hours=1),
#         )
#
#     def test_tutor_can_modify_own_session(self):
#         self.client.login(username='tutor1', password='password123')
#         response = self.client.post(
#             reverse('update_session', args=[self.session.id]),
#             {'subject': 'Updated Math'}
#         )
#         self.assertEqual(response.status_code, 302)  # Redirects on success
#         self.session.refresh_from_db()
#         self.assertEqual(self.session.subject, 'Updated Math')
#
#     def test_tutor_cannot_modify_other_tutor_session(self):
#         self.client.login(username='tutor2', password='password123')
#         response = self.client.post(
#             reverse('update_session', args=[self.session.id]),
#             {'subject': 'Updated Math'}
#         )
#         self.assertEqual(response.status_code, 403)  # Permission Denied



# from django.utils import timezone
# from .forms import SessionForm
# from .models import Tutor, Student, Session
#
# class SessionFormTests(TestCase):
#     def setUp(self):
#         self.tutor = Tutor.objects.create(profile=User.objects.create(username='tutor1'))
#         self.student = Student.objects.create(profile=User.objects.create(username='student1'))
#         self.start_time = timezone.now()
#         self.end_time = self.start_time + timezone.timedelta(hours=1)
#
#     def test_valid_form(self):
#         form_data = {
#             'subject': 'Math',
#             'session_type': 'private',
#             'tutor': self.tutor.id,
#             'students': [self.student.id],
#             'start_session': self.start_time,
#             'end_session': self.end_time,
#             'status': 'pending',
#         }
#         form = SessionForm(data=form_data)
#         self.assertTrue(form.is_valid())
#
#     def test_invalid_form_start_after_end(self):
#         form_data = {
#             'subject': 'Math',
#             'session_type': 'private',
#             'tutor': self.tutor.id,
#             'students': [self.student.id],
#             'start_session': self.end_time,
#             'end_session': self.start_time,
#             'status': 'pending',
#         }
#         form = SessionForm(data=form_data)
#         self.assertFalse(form.is_valid())
#         self.assertIn('The session start time must be before the end time.', form.errors['__all__'])
#
#     def test_invalid_form_overlapping_sessions(self):
#         # Create an existing session
#         Session.objects.create(
#             subject='Math',
#             tutor=self.tutor,
#             start_session=self.start_time,
#             end_session=self.end_time,
#         )
#
#         # Try to create an overlapping session
#         form_data = {
#             'subject': 'Science',
#             'session_type': 'private',
#             'tutor': self.tutor.id,
#             'students': [self.student.id],
#             'start_session': self.start_time + timezone.timedelta(minutes=30),
#             'end_session': self.end_time + timezone.timedelta(minutes=30),
#             'status': 'pending',
#         }
#         form = SessionForm(data=form_data)
#         self.assertFalse(form.is_valid())
#         self.assertIn('This session overlaps with another session for the same tutor.', form.errors['__all__'])