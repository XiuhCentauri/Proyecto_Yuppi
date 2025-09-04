import 'package:yuppi_app/features/notifications/domain/entities/notification_entity.dart';

class NotificationFactory {
  NotificationEntity create(String type, Map<String, dynamic> data) {
    switch (type) {
      case 'reward_claimed':
        return NotificationEntity(
          idNotif: '', // Firestore lo generará
          imagePath: data['imagePath'],
          idParent: data['idParent'],
          idKid: data['idKid'],
          idReward: data['idReward'],
          type: 'reward_claimed',
          message: data['message'],
          timestamp: DateTime.now(),
          read: false,
        );
      default:
        throw Exception("Tipo de notificación no soportado: $type");
    }
  }
}
