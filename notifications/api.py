# # notifications/api.py
# from rest_framework import generics, permissions, status
# from rest_framework.response import Response
# from .models import Notification
# from .serializers import NotificationSerializer
#
#
# class NotificationListAPI(generics.ListAPIView):
#     serializer_class = NotificationSerializer
#     permission_classes = [permissions.IsAuthenticated]
#     pagination_class = StandardResultsSetPagination
#
#     def get_queryset(self):
#         return Notification.objects.filter(
#             user_id=self.request.user.id
#         ).order_by('-created_at')
#
#
# class MarkAsReadAPI(generics.GenericAPIView):
#     permission_classes = [permissions.IsAuthenticated]
#
#     def post(self, request, notification_id):
#         if NotificationService.mark_as_read(request.user.id, notification_id):
#             return Response(status=status.HTTP_204_NO_CONTENT)
#         return Response(
#             {"detail": "Notification not found or already read"},
#             status=status.HTTP_404_NOT_FOUND
#         )
#
#
# class ClearAllNotificationsAPI(generics.GenericAPIView):
#     permission_classes = [permissions.IsAuthenticated]
#
#     def post(self, request):
#         count = Notification.objects.filter(
#             user_id=request.user.id,
#             is_read=False
#         ).update(is_read=True)
#
#         # Reset cache
#         cache_key = f"unread_count_{request.user.id}"
#         cache.set(cache_key, 0, timeout=60 * 5)
#
#         return Response(
#             {"cleared_count": count},
#             status=status.HTTP_200_OK
#         )