from django.urls import path
from . import views

app_name = 'blog'

urlpatterns = [
    path('', views.BlogHome.as_view(), name='home'),
    # path('post/', views.BlogPost.as_view(), name='post'),
    # path('', views.PostList.as_view(), name='home'),
    path('<slug:slug>/', views.PostDetail.as_view(), name='post_detail'),

    path('tag/<int:tag_id>/', views.posts_by_tag, name='posts_by_tag'),
    # path('post/<slug:slug>/comment/', views.submit_comment, name='submit_comment'),
    # path("comments/<int:post_id>/submit/", views.submit_comment, name="submit_comment"),
    path("comments/<int:post_id>/", views.fetch_comments, name="fetch_comments"),
]
