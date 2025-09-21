from django.core.cache import cache
import requests
from datetime import timedelta
from django.conf import settings


def popular_tags(request):
    def fetch_fresh_tags():
        response = requests.get(
            settings.WP_API_URL_TAGS,
            params={
                'orderby': 'count',
                'order': 'desc',
                'per_page': 10,
                '_fields': 'id,name,count'
            }
        )
        return response.json() if response.status_code == 200 else []

    # Cache for 1 hour with auto-refresh
    cache_key = 'popular_tags_v2'
    tags = cache.get_or_set(cache_key, fetch_fresh_tags, timeout=3600)
    # print(f"TAGs from C Processors: {tags}")
    return {'popular_tags': tags}
