from django.core.cache import cache
from django.core.exceptions import ValidationError
from django.utils import timezone


def rate_limit_messages(view_func):
    def wrapper(request, *args, **kwargs):
        if request.method == 'POST':
            cache_key = f'msg_limit_{request.user.id}_{timezone.now().hour}'
            count = cache.get(cache_key, 0)
            if count >= 20:
                raise ValidationError("Too many messages. Please try again later.")
            cache.set(cache_key, count + 1, 3600)  # 1 hour expiry
        return view_func(request, *args, **kwargs)

    return wrapper
