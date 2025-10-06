from django.shortcuts import render


# Error Pages!
def error_page(request, err_title, err_message, err_code):
    """Render a standardized error page"""
    context = {
        'err_title': err_title,
        'err_message': err_message,
        'err_code': err_code,
    }
    return render(request, 'pages/errors/error.html', context, status=err_code)


def page_404(request, exception):
    """Render a customized 404 page"""
    context = {
        'err_title': 'Page Not Found',
        'err_message': 'The page you requested does not exist.',
        'err_code': 404
    }
    return render(request, 'pages/errors/error_404.html', context, status=404)
