from django.http import Http404, HttpResponse, JsonResponse
from django.shortcuts import render, redirect, get_object_or_404
from django.utils import timezone
from datetime import timedelta
from django.conf import settings
from utils.email import send_dual_email
from django.contrib import messages
from django.contrib.admin.views.decorators import staff_member_required
from django.contrib.auth.models import User
from .models import InPersonRequest, InPersonOffer, InPersonService
from django.urls import reverse
from django.db.models import Sum


@staff_member_required
def inp_send_email_tutor(request, user_id):
    user = get_object_or_404(User, id=user_id)
    tutor_profile = user.profile

    # 1. Find nearby students
    nearby_student_profiles = tutor_profile.nearby_students().select_related('user')

    sent_offers = []
    for student_profile in nearby_student_profiles:
        student_user = student_profile.user

        # 2. CRITICAL FIX: Only find requests that are actively 'searching' for a tutor.
        # We do NOT send offers for requests that already have an offer out (status 'offer_sent').
        active_requests = InPersonRequest.objects.filter(
            user=student_user,
            status='searching'  # Only target requests that are truly available
        )

        for in_person_request in active_requests:
            # 3. Check if an offer already exists to this tutor for this request
            # (This is a final safeguard, the status filter above should prevent this)
            offer_exists = InPersonOffer.objects.filter(
                request=in_person_request,
                user=user
            ).exists()

            if not offer_exists:
                # 4. CREATE A NEW OFFER
                new_offer = InPersonOffer.objects.create(
                    request=in_person_request,
                    user=user,
                    service_name=in_person_request.service.name,
                    tutor_payout_per_hour=in_person_request.service.tutor_payout_per_hour,
                    number_of_sessions=in_person_request.number_of_sessions,
                    session_duration_hours=in_person_request.session_duration_hours,
                    total_payout=in_person_request.total_tutor_payout,
                    expires_at=timezone.now() + timedelta(hours=48)  # Offer expires in 48 hours
                )
                sent_offers.append(new_offer)

                # 5. PREPARE AND SEND EMAIL FOR *THIS SINGLE OFFER*
                context = {
                    'teacher_name': user.first_name,
                    'site_name': settings.SITE_NAME,
                    'offer': new_offer,  # Pass the whole offer object
                    'request': in_person_request,  # Pass the whole request object
                    # Generate URLs using the unique tokens
                    'accept_url': request.build_absolute_uri(
                        reverse('in_person:inp_accept_offer', kwargs={'token': new_offer.accept_token})
                    ),
                    'decline_url': request.build_absolute_uri(
                        reverse('in_person:inp_decline_offer', kwargs={'token': new_offer.decline_token})
                    ),
                }

                send_dual_email(
                    subject=f"New In-Person Request: {in_person_request.service.name}",
                    template_name='emails/in_person/tutor_new_opportunity',
                    context=context,
                    to_email=[user.email]
                )

                # 6. Update the request status to indicate an offer is now pending
                in_person_request.status = 'offer_sent'
                in_person_request.save()

    if sent_offers:
        messages.success(
            request,
            f"Successfully sent {len(sent_offers)} new in-person offer(s) to {user.get_full_name()}."
        )
    else:
        messages.info(
            request,
            f"No new in-person offers were found to send to {user.get_full_name()}. "
            f"There are no active student requests in their area that require a new tutor match."
        )

    # Redirect back to the admin page for this user
    return redirect('my_admin:user_neighborhood_detail', user_id=user_id)


def accept_offer(request, token):
    try:
        offer = InPersonOffer.objects.get(accept_token=token, status='sent')
        if offer.is_expired():
            return HttpResponse("This offer has expired.")

        # Check if the request is still available (not taken by another tutor)
        if offer.request.accepted_offer is not None:
            return HttpResponse("This request has already been accepted by another tutor.")

        # ALL GOOD - ACCEPT THE OFFER
        offer.status = 'accepted'
        offer.responded_at = timezone.now()
        offer.save()

        # LINK THE OFFER TO THE REQUEST
        offer.request.status = 'accepted'
        offer.request.accepted_offer = offer
        offer.request.save()

        # MARK ALL OTHER OFFERS FOR THIS REQUEST AS EXPIRED
        InPersonOffer.objects.filter(
            request=offer.request,
            status='sent'
        ).exclude(
            id=offer.id
        ).update(
            status='expired'
        )

        # SEND CONFIRMATION EMAILS TO STUDENT AND TUTOR...
        # Build context for confirmation emails
        confirmation_context = {
            'site_name': settings.SITE_NAME,
            'request': offer.request,
            'offer': offer,
            'dashboard_uri': request.build_absolute_uri(reverse('client:dc_home')),  # For student
            'tutor_dashboard_uri': request.build_absolute_uri(reverse('provider:dp_home')),  # For tutor
        }

        # Email to Tutor
        send_dual_email(
            subject=f"Confirmation: You've Accepted a Request for {offer.request.service.name}",
            template_name='emails/in_person/tutor_offer_accepted',
            context=confirmation_context,
            to_email=[offer.user.email]
        )

        # Email to Student
        student_context = confirmation_context.copy()
        student_context.update({
            'tutor_name': offer.user.get_full_name(),
            'tutor_profile_url': request.build_absolute_uri(
                reverse('provider:tutor_detail', args=[offer.user.profile.tutor_profile.pk])),
        })
        send_dual_email(
            subject=f"Great News! A Tutor Has Accepted Your Request",
            template_name='emails/in_person/student_offer_accepted',
            context=student_context,
            to_email=[offer.request.user.email]
        )

        return render(request, 'app_in_person/offer_accepted.html')

    except InPersonOffer.DoesNotExist:
        raise Http404("Offer not found.")


def decline_offer(request, token):
    # ... Similar logic to above, but just mark the offer as declined.
    # The request status might go back to 'offer_sent' or 'searching' so other tutors can be found.
    try:
        offer = InPersonOffer.objects.select_related('request').get(decline_token=token, status='sent')
        if offer.is_expired():
            return render(request, 'app_in_person/offer_error.html', {
                'error_title': 'Offer Expired',
                'error_message': 'This offer has expired and is no longer valid.'
            })

        # Mark the offer as declined
        offer.status = 'declined'
        offer.responded_at = timezone.now()
        offer.save()

        # Check the request's status logic carefully.
        # If it was 'offer_sent' ONLY because of this offer, we can put it back to 'searching'.
        # If other offers are still out ('sent'), we should leave it as 'offer_sent'.
        active_offers_still_out = InPersonOffer.objects.filter(
            request=offer.request,
            status='sent'
        ).exclude(  # Exclude this one we just declined
            id=offer.id
        ).exists()

        if not active_offers_still_out:
            # No other offers are pending for this request. Open it back up.
            offer.request.status = 'searching'
            offer.request.save()
            # A management command or admin action could later find new tutors for it.
        # Else, leave request.status as 'offer_sent' (other offers are pending)

        # Send a notification to admin? Optional.
        # notify_admin_offer_declined(offer)

        return render(request, 'app_in_person/offer_declined.html', {'offer': offer})

    except InPersonOffer.DoesNotExist:
        raise Http404("Offer not found or already processed.")


def tutor_appointments_stats(request):
    tutor = request.user
    now = timezone.now()

    stats = {
        'total_sessions': InPersonOffer.objects.filter(
            tutor_user=tutor,
            status='accepted'
        ).count(),
        'upcoming': InPersonOffer.objects.filter(
            tutor_user=tutor,
            status='accepted',
            request__preferred_start_date__gte=now.date()
        ).count(),
        'monthly_revenue': InPersonOffer.objects.filter(
            tutor_user=tutor,
            status='accepted',
            request__preferred_start_date__month=now.month,
            request__preferred_start_date__year=now.year
        ).aggregate(total=Sum('total_payout'))['total'] or 0,
        'avg_rating': 4.8  # This would come from your rating system
    }

    return JsonResponse(stats)
