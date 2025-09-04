import 'package:yuppi_app/features/notifications/domain/observers/reward_notification_observer.dart';
import 'package:yuppi_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:yuppi_app/features/notifications/domain/observers/notification_observer.dart';
import 'package:yuppi_app/features/notifications/domain/entities/notification_entity.dart';

class NewRewardAccessibleObserver implements NotificationObserver {
  final NotificationFactory factory;
  final NotificationRepository repository;

  NewRewardAccessibleObserver({
    required this.factory,
    required this.repository,
  });

  @override
  Future<void> notify(String type, Map<String, dynamic> data) async {
    try {
      final NotificationEntity notification = factory.create(type, data);
      await repository.saveNotification(notification);
    } catch (e) {
      print('Error creando notificación de nueva recompensa accesible: $e');
    }
  }
}
