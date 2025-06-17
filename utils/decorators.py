from functools import wraps
from django.http import JsonResponse
from django.contrib.auth.decorators import login_required


def ownership_required(model=None, lookup_field='pk', lookup_url_kwarg=None, id_param=None):
    """
    Decorator to ensure user can only access their own data.

    Args:
        model: The model class (defaults to User)
        lookup_field: The model field to compare (default 'pk')
        lookup_url_kwarg: The URL parameter name (defaults to lookup_field)
        id_param: For GET/POST requests, specify parameter name if not in URL
    """

    def decorator(view_func):
        @wraps(view_func)
        @login_required
        def wrapper(request, *args, **kwargs):
            nonlocal lookup_url_kwarg

            if lookup_url_kwarg is None:
                lookup_url_kwarg = lookup_field

            # Get the owner ID
            owner_id = kwargs.get(lookup_url_kwarg) or (id_param and request.GET.get(id_param))

            if not owner_id:
                return JsonResponse({
                    'status': 'error',
                    'message': 'Invalid user ID format'
                }, status=400)

            # Get the owner model (default to User)
            owner_model = model or request.user.__class__

            try:
                owner = owner_model.objects.get(**{lookup_field: owner_id})
            except (owner_model.DoesNotExist, ValueError):
                return JsonResponse({
                    'status': 'error',
                    'message': 'User does not exist'
                }, status=404)

            if owner != request.user:
                return JsonResponse({
                    'status': 'error',
                    'message': 'Forbidden:AVR-- You can only access your own data'
                }, status=403)

            return view_func(request, *args, **kwargs)

        return wrapper

    return decorator
