abstract class NotificationObserver {
  Future<void> notify(String type, Map<String, dynamic> data);
}
