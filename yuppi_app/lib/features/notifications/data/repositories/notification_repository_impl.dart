import 'package:yuppi_app/features/notifications/data/models/notification_model.dart';
import 'package:yuppi_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:yuppi_app/features/notifications/domain/repositories/notification_repository.dart';
import "package:yuppi_app/core/uuid_generator.dart";
import 'package:yuppi_app/core/servicios/firebase_service.dart';
import 'dart:developer';

class NotificationRepositoryImpl implements NotificationRepository {
  final _firestore = FirebaseService().firestore;

  @override
  Future<void> saveNotification(NotificationEntity notification) async {
    final model = NotificationModel(
      idNotif: generateUuid(), // Se generará automáticamente
      idReward: notification.idReward,
      idParent: notification.idParent,
      idKid: notification.idKid,
      type: notification.type,
      message: notification.message,
      timestamp: notification.timestamp,
      read: notification.read,
      imagePath: notification.imagePath,
    );
    log(model.idNotif);
    log(model.imagePath);
    await _firestore
        .collection('notifications')
        .doc(model.idNotif)
        .set(model.toMap());
  }

  @override
  Future<List<NotificationEntity>> getNotificationsForUser(String idKid) async {
    final query =
        await _firestore
            .collection('notifications')
            .where('idKid', isEqualTo: idKid)
            .orderBy('timestamp', descending: true)
            .get();

    return query.docs
        .map((doc) => NotificationModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final ref = _firestore.collection('notifications').doc(notificationId);
    await ref.update({'read': true});
  }
}
