from django.shortcuts import render


# Error Pages!
def error_page(request, err_title, err_message, err_code):
    context = {
        'err_title': err_title,
        'err_message': err_message,
        'err_code': err_code,
    }
    return render(request, 'pages/errors/error.html', context)
