from django.http import Http404
from django.views.generic import TemplateView, ListView, DetailView, FormView
import requests
from datetime import datetime
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.core.cache import cache
from django.conf import settings
import math
from django.http import JsonResponse
from .models import Comment, Post, Tag, Category
from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from types import SimpleNamespace
from django.contrib.auth.models import User
from django.core.mail import send_mail, EmailMessage
from .forms import CommentForm
from django.urls import reverse_lazy


# _FINAL_PAGINATION
class BlogHome(TemplateView):
    template_name = 'app_blog/blog_home.html'
    wp_api_url = settings.WP_API_URL_POSTS
    posts_per_page = 8  # Must match your template's expected items per page

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)

        current_page = int(self.request.GET.get('page', 1))

        params = {
            '_embed': 'true',
            'orderby': 'date',
            'order': 'desc',
            'per_page': self.posts_per_page,
            'page': current_page  # This tells WordPress which page to return
        }

        try:
            response = requests.get(self.wp_api_url, params=params)

            if response.status_code == 200:
                posts = [self._process_post(post) for post in response.json()]
                total_posts = int(response.headers.get('X-WP-Total', 0))
                total_pages = int(response.headers.get('X-WP-TotalPages', 1))

                # Create a page_obj-like object that matches what your template expects
                page_obj = {
                    'object_list': posts,
                    'number': current_page,
                    'has_previous': current_page > 1,
                    'has_next': current_page < total_pages,
                    'previous_page_number': current_page - 1,
                    'next_page_number': current_page + 1,
                    'paginator': {
                        'num_pages': total_pages,
                        'page_range': range(1, total_pages + 1),
                    }
                }

                context['posts'] = posts
                context['page_obj'] = SimpleNamespace(**page_obj)  # Convert dict to object

            else:
                context['posts'] = []
                context['page_obj'] = None

        except Exception as e:
            print(f"Error fetching posts: {str(e)}")
            context['posts'] = []
            context['page_obj'] = None

        return context

    def _process_post(self, post):
        """Process post data consistently for both list and detail views"""
        embedded = post.get('_embedded', {})

        # Handle author data
        authors = embedded.get('author', [{}])
        author = authors[0] if authors else {}

        # Author data with avatar
        author_data = embedded.get('author', [{}])[0]  # Get first author
        author_avatar_urls = author_data.get('avatar_urls', {})
        avatar_url = author_avatar_urls.get('96')  # 96px size

        # author_url = author_data.get('_links', {}).get('self', [{}])[0].get('href')
        # if author_url:
        #     try:
        #         author_response = requests.get(author_url + '?_fields=roles')
        #         roles = author_response.json().get('roles', [])
        #         primary_role = roles[0]
        #     except:
        #         roles = []
        #         primary_role = None

        # Handle featured image
        featured_media = embedded.get('wp:featuredmedia', [{}])
        featured_image = featured_media[0] if featured_media else {}

        # Handle date ---------------------------------------------------------------------------
        raw_date = post.get('date', '')
        try:
            post_date = datetime.strptime(raw_date, "%Y-%m-%dT%H:%M:%S") if raw_date else None
        except ValueError:
            post_date = None
        # ---------------------------------------------------------------------------------------

        # calculate reading_time ----------------------------------------------------------------
        # Note: The average person reads about 200-250 words per minute.
        content = post.get('content', {}).get('rendered', '')
        word_count = len(content.split())  # Count the number of words
        reading_time = math.ceil(word_count / 200)  # Calculate time (rounded up)
        # ---------------------------------------------------------------------------------------

        # Calculate Visits and Likes of each post -----------------------------------------------
        visits = 3
        likes = 286
        # ---------------------------------------------------------------------------------------
        return {
            'id': post.get('id'),
            'title': post.get('title', {}).get('rendered', ''),
            'excerpt': post.get('excerpt', {}).get('rendered', ''),
            'content': content,
            'reading_time': f"{reading_time} min",
            'likes': f"{likes}",
            'visits': f"{visits} K",
            'date': post_date,
            'raw_date': raw_date,
            'link': post.get('link', ''),
            'slug': post.get('slug', ''),
            'comment_status': post.get('comment_status', ''),
            'author': author.get('name', ''),
            'author_id': author.get('id'),
            'author_avatar_url': avatar_url,
            # 'author_roles': roles,
            # 'author_primary_role': primary_role,
            'featured_image': featured_image.get('source_url', ''),
            'categories': [cat['name'] for cat in embedded.get('wp:term', [[]])[0] if isinstance(cat, dict)],
            'tags': [tag['name'] for tag in embedded.get('wp:term', [[]])[1] if isinstance(tag, dict)],
            # 'popular_tags': get_popular_tags(),
            # 'popular_tags': cache.get_or_set('popular_tags', get_popular_tags(), 3600)

        }


class PostDetail(DetailView, FormView):
    template_name = 'app_blog/blog_detail.html'
    context_object_name = 'post'
    # slug_url_kwarg = 'slug'
    wp_api_url_posts = settings.WP_API_URL_POSTS
    relevant_posts_count = 4

    form_class = CommentForm
    success_url = reverse_lazy('blog:home')

    # success_url = reverse_lazy('blog:post_detail', kwargs={'slug': request.POST.get('wp_post_id')})

    def get_object(self):
        slug = self.kwargs.get('slug')
        api_url = f"{self.wp_api_url_posts}?slug={slug}&_embed"

        try:
            # Fetch the post
            post_response = requests.get(api_url)
            posts = post_response.json()

            if not posts:
                raise Http404("Post not found")

            post = posts[0]
            processed_post = BlogHome()._process_post(post)

            # Fetch comments for this post
            comments = self._get_post_comments(post.get('id'))
            processed_post['comments'] = comments

            return processed_post

        except Exception as e:
            print(f"Error fetching post: {str(e)}")
            raise Http404("Error loading post")

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        post = context['object']

        # Get related posts from YARPP (limited to 4)
        context['related_posts'] = self._get_yarpp_related_posts(post['id'], limit=4)
        # context['comments'] = fetch_comments(post['id'])
        context['comments'] = Comment.objects.filter(wp_post_id=post['id'], is_published=True).order_by("-create_date")
        # context['djangoPosts'] = Post.objects.all()
        return context

    def _get_yarpp_related_posts(self, post_id, limit=4):
        """Fetch and process limited number of related posts from YARPP"""
        try:
            # 1. First get just the IDs from YARPP
            yarpp_response = requests.get(
                f"{settings.WP_API_URL_RELATED}{post_id}",
                params={'fields': 'id'},  # Only request IDs to minimize data
                timeout=2
            )
            if yarpp_response.status_code == 200:
                related_ids = [p['id'] for p in yarpp_response.json()[:limit]]  # Get first 4 IDs

                # 2. Fetch full post data only for these IDs
                # e.g. "http://localhost/Amin-Academy/wp-json/wp/v2/posts?include=29,278,27,282&_embed=True&per_page=4"
                posts_response = requests.get(
                    settings.WP_API_URL_POSTS,
                    params={
                        'include': ','.join(map(str, related_ids)),
                        '_embed': 'true',  # Get featured images  !!!!!  True is for DJANGO and 'true' is for WORDPRESS
                        'per_page': limit
                    },
                    timeout=3
                )
                if posts_response.status_code == 200:
                    return [self._process_yarpp_post(p) for p in posts_response.json()]

        except requests.RequestException as e:
            print(f"Error fetching YARPP related posts: {str(e)}")
        return []

    def _process_yarpp_post(self, post):
        """Process individual post data with featured image"""
        # Get featured image URL from embedded data
        featured_image = ''
        embedded = post.get('_embedded', {})
        if 'wp:featuredmedia' in embedded:
            media = embedded['wp:featuredmedia']
            if media and isinstance(media, list):
                featured_image = media[0].get('source_url', '')

        # Format date
        raw_date = post.get('date', '')
        try:
            date = datetime.strptime(raw_date, "%Y-%m-%dT%H:%M:%S").strftime("%b %d, %Y")
        except ValueError:
            date = raw_date

        return {
            'id': post.get('id'),
            'title': post.get('title', {}).get('rendered', ''),
            'slug': post.get('slug'),
            'link': post.get('link'),
            'excerpt': post.get('excerpt', {}).get('rendered', ''),
            'date': date,
            'featured_image': featured_image,
            'score': post.get('score', 0)  # Optional: relevance score
        }

    # _process_post from json respond!
    def _process_post(self, post):
        """Process raw post data from WordPress"""
        embedded = post.get('_embedded', {})
        # 1. Get author data
        author_data = embedded.get('author', [{}])[0]
        # 2. Get featured image
        featured_media = embedded.get('wp:featuredmedia', [{}])[0]

        # Convert tag names to IDs
        tag_names = [tag['name'] for tag in embedded.get('wp:term', [[]])[0]
                     if isinstance(tag, dict) and tag.get('taxonomy') == 'post_tag']
        tag_ids = [self.all_tags[name] for name in tag_names if name in self.all_tags]
        # Convert category names to IDs
        category_names = [cat['name'] for cat in embedded.get('wp:term', [[]])[0]
                          if isinstance(cat, dict) and cat.get('taxonomy') == 'category']
        category_ids = [self.all_categories[name] for name in category_names
                        if name in self.all_categories]

        # 3. Get terms (tags/categories)
        terms = embedded.get('wp:term', [])
        tag_terms = next(
            (group for group in terms
             if group and group[0].get('taxonomy') == 'post_tag'),
            []
        )
        category_terms = next(
            (group for group in terms
             if group and group[0].get('taxonomy') == 'category'),
            []
        )

        # 4. Return structured post data
        return {
            'id': post.get('id'),
            'title': post.get('title', {}).get('rendered', ''),
            'content': post.get('content', {}).get('rendered', ''),
            'excerpt': post.get('excerpt', {}).get('rendered', ''),
            'date': post.get('date', ''),
            'slug': post.get('slug', ''),
            'link': post.get('link', ''),
            # 'tags': [tag['id'] for tag in tag_terms],
            # 'categories': [cat['id'] for cat in category_terms],
            'tags': tag_ids,
            'categories': category_ids,

            'author': author_data.get('name', ''),
            'author_avatar': author_data.get('avatar_urls', {}).get('96', ''),
            'featured_image_url': featured_media.get('source_url', ''),
            'comment_status': post.get('comment_status', 'closed')
        }

    # get comments from WP rest API (working well) ------------------------------------------------------
    def _get_post_comments(self, post_id):
        """Fetch comments for a specific post"""
        if not post_id:
            return []

        comments_url = f"{settings.WP_API_URL_COMMENTS}?post={post_id}"

        try:
            response = requests.get(comments_url)
            if response.status_code == 200:
                return self._process_comments(response.json())
            return []
        except Exception as e:
            print(f"Error fetching comments: {str(e)}")
            return []

    def _process_comments(self, comments):
        """Process raw comments data into a usable format"""
        processed = []
        for comment in comments:
            # Convert date to readable format
            raw_date = comment.get('date', '')
            try:
                date_obj = datetime.strptime(raw_date, "%Y-%m-%dT%H:%M:%S")
                formatted_date = date_obj.strftime("%B %d, %Y at %I:%M %p")
            except (ValueError, TypeError):
                formatted_date = raw_date

            processed.append({
                'id': comment.get('id'),
                'author_name': comment.get('author_name', 'Anonymous'),
                'author_avatar': comment.get('author_avatar_urls', {}).get('96', ''),
                'date': formatted_date,
                'content': comment.get('content', {}).get('rendered', ''),
                'parent': comment.get('parent', 0),  # For nested comments
            })
        return processed

    # ---------------------------------------------------------------------------------------------------

    # Comments for each post --------------------------------------------------
    def get_form_kwargs(self):
        kwargs = super().get_form_kwargs()
        # Set the initial value for the 'name' field based on user authentication
        if self.request.user.is_authenticated:
            kwargs['initial'] = {
                'name': f"{self.request.user.first_name} {self.request.user.last_name}",
                'email': self.request.user.email,
            }
        return kwargs

    def form_valid(self, form):
        wp_post_id = self.request.POST.get('wp_post_id')
        name = self.request.POST.get('name')
        email = self.request.POST.get('email')
        message = self.request.POST.get('message')

        # Notify admin by email
        admin_info = User.objects.get(is_superuser=True)
        admin_email = admin_info.email

        try:
            send_feedback_email(name, wp_post_id, email, message, admin_email)
        except Exception as e:
            messages.error(self.request, f"Error sending email: {str(e)}")

        # Save the comment
        form.instance.user = self.request.user if self.request.user.is_authenticated else None
        form.instance.name = f"{self.request.user.first_name} {self.request.user.last_name}" if self.request.user.is_authenticated else name
        form.instance.email = self.request.user.email if self.request.user.is_authenticated else email
        form.instance.wp_post_id = wp_post_id
        # form.instance.wp_post_title = wp_post_title
        form.save()
        form.save()  # Save the form data to the database
        messages.success(self.request,
                         'Thank you for sharing your thoughts! Your comment has been received and will be published after it passes admin review.')
        return super().form_valid(form)

    def form_invalid(self, form):
        messages.error(self.request, 'There is an error in sending message! please check your fields again.')
        return self.render_to_response(self.get_context_data(form=form))


def send_feedback_email(name, wp_post_id, email, message, admin_email):
    # Define the subject, body, and other details
    subject = f"{name} has sent feedback on Blog post: {wp_post_id}"
    html_content = f"""
    <html>
        <body>
            <h3>Feedback from {name}</h3>
            <p style="color:red;"><strong>Email:</strong> {email}</p>
            <p><strong>Message:</strong></p>
            <p>{message}</p>
        </body>
    </html>
    """

    # Set up the email
    email_message = EmailMessage(
        subject,
        html_content,  # Message content
        settings.EMAIL_HOST_USER,  # From email
        [admin_email]  # To email
    )

    # Specify that the content is HTML
    email_message.content_subtype = 'html'

    # Send the email
    email_message.send(fail_silently=False)


# Blog Comments handled by django -------------------------------------------------------------
def fetch_comments(post_id):
    comments = Comment.objects.filter(wp_post_id=post_id).order_by("-create_date")
    comments_data = [{"user": c.user, "name": str(c.name), "message": c.message, "create_date": c.create_date,
                      "is_published": c.is_published} for c in comments]
    # return JsonResponse(comments_data, safe=False)
    return comments_data


# .
# .
# .
# .
# .
# .
# .
# .

def submit_comment_WP(request, slug):
    if request.method == 'POST':
        # First get the WordPress post ID via API
        wp_api_url = settings.WP_API_URL_POSTS
        response = requests.get(f"{wp_api_url}?slug={slug}")

        if not response.ok or not response.json():
            messages.error(request, 'Post not found')
            return redirect('blog:home')  # Or your homepage

        wp_post = response.json()[0]
        post_id = wp_post['id']

        # Prepare data for WordPress API
        comment_data = {
            'post': post_id,
            'author_name': request.POST.get('author_name'),
            'author_email': request.POST.get('author_email'),
            'content': request.POST.get('content'),
        }

        # Send to WordPress
        try:
            response = requests.post(
                settings.WP_API_URL_COMMENTS,
                data=comment_data,
                auth=('your_wp_username', 'your_wp_application_password')  # Requires application password
            )

            if response.status_code == 201:
                messages.success(request, 'Your comment is awaiting moderation.')
            else:
                messages.error(request, 'Failed to submit comment. Please try again.')

        except Exception as e:
            messages.error(request, f'Error submitting comment: {str(e)}')

    return redirect('post_detail', slug=slug)


def posts_by_tag(request, tag_id):
    posts_response = requests.get(
        settings.WP_API_URL + 'posts',
        params={
            '_embed': 'true',
            'tags': tag_id,
            'per_page': 10
        }
    )
    posts = posts_response.json() if posts_response.status_code == 200 else []

    return render(request, 'app_blog/posts_search.html', {
        'posts': posts,
        'tag': next((t for t in request.all_tags if t['id'] == tag_id), None)
    })


# .
# .
# .
# .
# .
# -------------------------------------------- vvv Must DELETE vvv ---------------------------------------------
# -------------------------------------------- initialization Start ---------------------------------------------
def get_all_tags(self):
    """Get all terms (tags) with their IDs and names"""
    terms_url = settings.WP_API_URL_TAGS
    try:
        response = requests.get(terms_url, params={'per_page': 100})
        if response.ok:
            return {term['name']: term['id'] for term in response.json()}
    except requests.RequestException:
        return {}
    return {}


def get_all_categories(self):
    """Get all terms (categories) with their IDs and names"""
    terms_url = settings.WP_API_URL_CATEGORIES
    try:
        response = requests.get(terms_url, params={'per_page': 100})
        if response.ok:
            return {term['name']: term['id'] for term in response.json()}
    except requests.RequestException:
        return {}
    return {}


def __init__(self, *args, **kwargs):
    super().__init__(*args, **kwargs)
    self.all_tags = self.get_all_tags()
    print(f"all_tags: {self.all_tags}")
    self.all_categories = self.get_all_categories()
    print(f"all_categories: {self.all_categories}")


def _get_term_ids(self, post, taxonomy):
    """Get IDs for tags or categories"""
    # Try direct IDs first
    terms = post.get(taxonomy + 's', [])
    if terms and isinstance(terms[0], int):
        return terms

    # Try list of objects
    try:
        return [t['id'] for t in terms if isinstance(t, dict)]
    except (TypeError, KeyError):
        pass

    # Fallback to embedded terms
    embedded_terms = post.get('_embedded', {}).get('wp:term', [])
    for term_group in embedded_terms:
        if term_group and term_group[0].get('taxonomy') == taxonomy:
            return [t['id'] for t in term_group]

    return []


# -------------------------------------------- initialization End ---------------------------------------------
def _get_related_posts(self, post):
    if not post.get('id'):
        return []

    params = {
        '_embed': 'true',
        'per_page': self.relevant_posts_count,
        'exclude': [post['id']],
        'orderby': 'date',
    }

    # Try tags first
    tag_names = post.get('tags')

    tag_ids = []
    # Get IDs from tag names
    for t in tag_names:
        if t in self.all_tags:  # Check if the tag name exists in all_tags
            tag_ids.append(self.all_tags[t])  # Append the corresponding ID
    print(f"tag_ids: {tag_ids}")

    if tag_ids:
        params['tags'] = tag_ids[0]  # Just use the first tag for initial filtering
        try:
            response = requests.get(self.wp_api_url_posts, params=params, timeout=3)
            print(f"response11: {response}")
            if response.ok:
                posts = response.json()
                # Filter to only keep posts with at least one matching tag
                print(f"self._get_post_tag_ids(p): {self._get_post_tag_ids(post)}")
                return [
                           p for p in posts
                           if set(self._get_post_tag_ids(p)).intersection(tag_ids)
                       ][:self.relevant_posts_count]
        except requests.RequestException:
            pass

    # Fallback to categories
    category_names = post.get('categories')

    category_ids = []
    # Get IDs from tag names
    for cat in category_names:
        if cat in self.all_categories:  # Check if the tag name exists in all_tags
            category_ids.append(self.all_categories[cat])  # Append the corresponding ID
    print(f"category_ids: {category_ids}")

    if category_ids:
        params = {
            '_embed': 'true',
            'per_page': self.relevant_posts_count,
            'exclude': [post['id']],
            'categories': category_ids[0],  # First category
            'orderby': 'date',
        }
        try:
            response = requests.get(self.wp_api_url_posts, params=params, timeout=3)
            if response.ok:
                return response.json()[:self.relevant_posts_count]
        except requests.RequestException:
            pass

    return []


def _get_post_tag_ids(self, post):
    """Extract tag IDs from a post object"""
    if isinstance(post.get('tags', [])[0], int):
        return post['tags']
    return [tag['id'] for tag in post.get('tags', []) if isinstance(tag, dict)]


def _fetch_related_by_any_term(self, taxonomy, term_ids, base_params):
    """Find posts that share ANY of the specified terms"""
    try:
        # Make separate requests for each term and combine results
        all_related = []

        for term_id in term_ids[:5]:  # Limit to first 5 terms to avoid too many requests
            params = base_params.copy()
            params[taxonomy] = str(term_id)  # Filter by single term
            print(f"Searching for {taxonomy} IDs: {term_ids}")

            response = requests.get(
                self.wp_api_url_posts,
                params=params,
                timeout=2
            )

            # print(f"API URL: {self.wp_api_url_posts}?{urlencode(params)}")
            print(f"API URL: {self.wp_api_url_posts}?{params}")
            if response.ok:
                posts = response.json()
                # Add only new posts to avoid duplicates
                for post in posts:
                    if post['id'] not in [p['id'] for p in all_related]:
                        all_related.append(post)
                        if len(all_related) >= 4:  # Stop when we have enough
                            return all_related[:4]  # Return max 4 posts

        return all_related[:4]  # Return whatever we found (up to 4)

    except requests.RequestException as e:
        print(f"Error fetching related by {taxonomy}: {str(e)}")
    return None


def _fetch_related_by_taxonomy(self, taxonomy, ids, base_params):
    """Helper method to fetch posts by taxonomy"""
    try:
        # 1. Copy and update parameters
        params = base_params.copy()
        params[taxonomy] = ','.join(map(str, ids))

        # 2. Make API request
        response = requests.get(
            self.wp_api_url_posts,
            params=params,
            timeout=3
        )

        # 3. Process successful response
        if response.ok:
            return self._process_related_posts(response.json())
    except requests.RequestException as e:
        print(f"Error fetching related posts by {taxonomy}: {str(e)}")
    return None
