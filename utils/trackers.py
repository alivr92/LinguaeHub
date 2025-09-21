import requests


def get_client_ip(request):
    """Helper function to get client IP"""
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        return x_forwarded_for.split(',')[0]
    return request.META.get('REMOTE_ADDR')


def get_geo_data(ip):
    """
    return City, Country by input user IP

    Args:
        ip (str): User ip address
    """

    try:
        res = requests.get(f'https://ipapi.co/{ip}/json/')
        if res.status_code == 200:
            data = res.json()
            return {
                'city': data.get('city'),
                'country': data.get('country_name')
            }
    except Exception:
        pass
    return {'city': None, 'country': None}
