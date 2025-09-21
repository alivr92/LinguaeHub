from utils.timezones import get_all_timezones


def timezones(request):
    return {
        'all_timezones': get_all_timezones()
    }
