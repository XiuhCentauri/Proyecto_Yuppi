import 'package:yuppi_app/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<void> saveNotification(NotificationEntity notification);
  Future<List<NotificationEntity>> getNotificationsForUser(String userId);
  Future<void> markAsRead(String notificationId);
}
