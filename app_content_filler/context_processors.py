from app_pages.models import ContentFiller, ContactUs
from app_content_filler.models import (CFChar, CFText, CFRichText, CFURL, CFBoolean, CFImage, CFFloat, CFDecimal,
                                       CFFile,
                                       CFDateTime, CFInteger, CFEmail)
from app_accounts.models import Language
from ap2_tutor.models import ProviderApplication


def content_filler(request):
    return {
        'CFChar': {item.key: item.value for item in CFChar.objects.all()},
        'CFText': {item.key: item.value for item in CFText.objects.all()},
        'CFRichText': {item.key: item.value for item in CFRichText.objects.all()},
        'CFURL': {item.key: item.value for item in CFURL.objects.all()},
        'CFEmail': {item.key: item.value for item in CFEmail.objects.all()},
        'CFImage': {item.key: item.value for item in CFImage.objects.all()},
        'CFInteger': {item.key: item.value for item in CFInteger.objects.all()},
        'CFFloat': {item.key: item.value for item in CFFloat.objects.all()},
        'CFDecimal': {item.key: item.value for item in CFDecimal.objects.all()},
        'CFFile': {item.key: item.value for item in CFFile.objects.all()},
        'CFDateTime': {item.key: item.value for item in CFDateTime.objects.all()},
        'CFBoolean': {item.key: item.value for item in CFBoolean.objects.all()},

        'languages': Language.objects.all(),
    }


def counters(request):
    return {
        'range': range(1, 6),  # for rating stars
        'contact_us_unread': ContactUs.objects.filter(is_read=False).count(),  # to show in admin sidebar
        'applicants_pending': ProviderApplication.objects.filter(status='pending').count(),  # New Applicant Counters to show in admin sidebar
    }
