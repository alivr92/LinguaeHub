from app_pages.models import ContentFiller


def site_info(request):
    filler1 = ContentFiller.objects.get(data_title='Site Info')
    return {
        'site_info': filler1,
    }
