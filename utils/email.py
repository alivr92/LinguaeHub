from django.core.mail import EmailMultiAlternatives
from django.template.loader import render_to_string
from django.conf import settings
from django.core.mail import send_mail, EmailMessage
import base64
from django.templatetags.static import static
from django.urls import reverse_lazy, reverse
from django.utils import timezone


def send_dual_email(subject, template_name, context, to_email, from_email=None):
    """
    Send an email with both HTML and plain text versions.

    Args:
        subject (str): Subject of the email
        template_name (str): Base name of the template (e.g., 'emails/tutor_accepted')
        context (dict): Context to render in both templates
        to_email (str or list): Recipient email(s)
        from_email (str): Optional; defaults to settings.EMAIL_HOST_USER
    """
    from_email = from_email or settings.EMAIL_HOST_USER

    # Render both text and HTML templates
    text_content = render_to_string(f'{template_name}.txt', context)
    html_content = render_to_string(f'{template_name}.html', context)

    # Ensure to_email is a list
    if isinstance(to_email, str):
        to_email = [to_email]

    # Create and send email
    email = EmailMultiAlternatives(subject, text_content, from_email, to_email)
    email.attach_alternative(html_content, "text/html")
    email.send()


def notification_email_to_admin(subject, template_name, context, from_email=None, to_email=None):
    """
    Send an email with both HTML and plain text versions.

    Args:
        subject (str): Subject of the email
        template_name (str): Base name of the template (e.g., 'emails/tutor_accepted')
        context (dict): Context to render in both templates
        from_email (str): Optional; defaults to settings.EMAIL_HOST_USER
        to_email (str or list): Recipient email(s)
    """
    from_email = from_email or settings.EMAIL_HOST_USER
    to_email = to_email or settings.EMAIL_ADMIN_USER

    # Render both text and HTML templates
    html_content = render_to_string(f'{template_name}.html', context)
    text_content = render_to_string(f'{template_name}.txt', context)

    # Ensure to_email is a list
    if isinstance(to_email, str):
        to_email = [to_email]

    # Create and send email
    email = EmailMultiAlternatives(subject, text_content, from_email, to_email)
    email.attach_alternative(html_content, "text/html")
    email.send()


# CHECK_BEFORE_RELEASE
def invitation_email_DELETE(full_name, to_email):
    # Define the subject, body, and other details
    subject = f"Congratulation {full_name}, your application has been accepted."

    # HTML content
    html_content = f"""
                       <!DOCTYPE html>
               <html>
               <head>
                   <meta charset="UTF-8">
                   <title>Tutor Application Accepted</title>
               </head>
               <body style="font-family: Arial, sans-serif; background-color: #f7f7f7; margin: 0; padding: 0;">
                   <table width="100%" cellpadding="0" cellspacing="0" style="margin: 0 auto; max-width: 600px; background-color: #ffffff; border-radius: 6px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
                       <tr>
                           <td style="padding: 20px 30px;">
                               <h2 style="color: #333333;">Congratulations, {full_name}!</h2>
                               <p style="font-size: 16px; color: #555555;">
                                   We're delighted to inform you that your application to become a tutor with <strong>{settings.SITE_NAME}</strong> has been accepted.
                               </p>
                               <p style="font-size: 16px; color: #555555;">
                                   To proceed, please complete your registration using the button below. Once registered, you’ll be able to log into your account and schedule your interview session.
                               </p>
                               <div style="text-align: center; margin: 30px 0;">
                                   <a href="{registration_url}" style="background-color: #007bff; color: #ffffff; text-decoration: none; padding: 12px 25px; border-radius: 5px; font-size: 16px;">
                                       Complete Registration
                                   </a>
                               </div>
                               <p style="font-size: 14px; color: #888888;">
                                   Please note: This link is valid for 7 days. If it expires, you will need to request a new one.
                               </p>
                               <p style="font-size: 16px; color: #555555;">We’re looking forward to meeting you!</p>
                               <p style="font-size: 16px; color: #555555;">Best regards,<br><strong>{settings.SITE_NAME} Team</strong></p>
                           </td>
                       </tr>
                   </table>
               </body>
               </html>
                       """

    # Set up the email
    email_message = EmailMessage(
        subject,
        html_content,  # Message content
        settings.EMAIL_HOST_USER,  # From email
        [to_email]  # To email
    )

    # Specify that the content is HTML
    email_message.content_subtype = 'html'

    # Send the email
    email_message.send(fail_silently=False)


def notification_formatted_email(subject, template_name, context, photo, resume_file, from_email=None, to_email=None):
    """
       Send email with HTML and attached files (photo and file).

       Args:
           subject (str): Subject of the email
           template_name (str): Base name of the template (e.g., 'emails/tutor_accepted')
           context (dict): Context to render in both templates
           from_email (str): Optional; defaults to settings.EMAIL_HOST_USER
           to_email (str or list): Recipient email(s)
           photo (file): file of attached photo
           resume_file (file): file of attached resume
    """

    from_email = from_email or settings.EMAIL_HOST_USER
    to_email = to_email or settings.EMAIL_ADMIN_USER

    html_content = render_to_string(f'{template_name}.html', context)

    # Set up the email
    email_message = EmailMessage(
        subject,
        html_content,  # Message content
        from_email,  # From email
        [to_email]  # To email
    )

    # Specify that the content is HTML
    email_message.content_subtype = 'html'

    # Attach the photo and resume files
    if photo:
        email_message.attach(photo.name, photo.read(), photo.content_type)
    if resume_file:
        email_message.attach(resume_file.name, resume_file.read(), resume_file.content_type)

    # Send the email
    email_message.send(fail_silently=False)


def get_base64_logo():
    with open("static/assets/images/logo_white_gold.png", "rb") as img_file:
        return base64.b64encode(img_file.read()).decode('utf-8')


def get_absolute_logo_url(request):
    # Force HTTP if in development
    if settings.DEBUG:
        return request.build_absolute_uri(static('assets/images/logo_white_gold.png')).replace('https://', 'http://')
    return request.build_absolute_uri(static('assets/images/logo_white_gold.png'))


def send_reset_password_link(request, user, reset_url):
    """Send activation email with activation link"""
    context = {
        'user': user,
        'first_name': user.first_name,
        'full_name': f"{user.first_name} {user.last_name}",
        'reset_url': reset_url,
        'site_name': settings.SITE_NAME,
        'support_email': settings.EMAIL_SUPPORT,
        'current_year': timezone.now().year,
        'company_address': settings.COMPANY_ADDRESS,
        'privacy_policy_url': request.build_absolute_uri(reverse('app_pages:privacy_policy')),
        'terms_url': request.build_absolute_uri(reverse('app_pages:agb')),
        'full_logo_url': request.build_absolute_uri(static('assets/images/logo_white_gold.png'))
    }

    send_dual_email(
        subject=f"Password Reset Request - {settings.SITE_NAME}",
        template_name='emails/accounts/password_reset',
        context=context,
        to_email=[user.email]
    )


def send_verification_email(request, user, verification_url):
    """Send verification link to verify email address"""
    context = {
        'first_name': user.first_name,
        'full_name': f"{user.first_name} {user.last_name}",
        'verification_url': verification_url,
        'site_name': settings.SITE_NAME,
        'support_email': settings.EMAIL_SUPPORT,
        'current_year': timezone.now().year,
        'company_address': settings.COMPANY_ADDRESS,
        'privacy_policy_url': request.build_absolute_uri(reverse('app_pages:privacy_policy')),
        'terms_url': request.build_absolute_uri(reverse('app_pages:agb')),
        'full_logo_url': request.build_absolute_uri(static('assets/images/logo_white_gold.png'))
    }

    send_dual_email(
        subject=f"Verify Your {settings.SITE_NAME} Account",
        template_name='emails/accounts/verification',
        context=context,
        to_email=[user.email]
    )


def send_security_alert(user, ip, timestamp):
    subject = "Security Alert: New Login Detected"
    message = (
        f"Dear {user.username},\n\n"
        f"A login was detected from a new IP address:\n\n"
        f"IP: {ip}\nTime: {timestamp}\n\n"
        f"If this was not you, please reset your password immediately.\n\n"
        f"– Security Team"
    )
    send_mail(subject, message, settings.DEFAULT_FROM_EMAIL, [user.email])
