import 'package:flutter/material.dart';
import 'package:yuppi_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:yuppi_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:yuppi_app/features/notifications/injection/notify_accessible_rewards_injection.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repository =
      notifyAccessibleInjection<NotificationRepository>();

  List<NotificationEntity> _notifications = [];
  bool _hasUnread = false;

  List<NotificationEntity> get notifications => _notifications;
  bool get hasUnreadNotifications => _hasUnread;

  Future<void> loadNotifications(String kidId) async {
    try {
      final fetched = await _repository.getNotificationsForUser(kidId);
      _notifications = fetched;
      _hasUnread = fetched.any((n) => !n.read);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markAsRead(notificationId);
      final index = _notifications.indexWhere(
        (n) => n.idNotif == notificationId,
      );
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(read: true);
        _hasUnread = _notifications.any((n) => !n.read);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking as read: $e');
    }
  }

  void clearNotifications() {
    _notifications = [];
    _hasUnread = false;
    notifyListeners();
  }
}
