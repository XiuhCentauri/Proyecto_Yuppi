import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yuppi_app/features/notifications/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required String idNotif,
    required String idReward,
    required String idParent,
    required String idKid,
    required String type,
    required String message,
    required DateTime timestamp,
    required String imagePath,
    bool read = false,
  }) : super(
         idNotif: idNotif,
         idReward: idReward,
         //idReward: idReward.
         idParent: idParent,
         idKid: idKid,
         type: type,
         message: message,
         timestamp: timestamp,
         read: read,
         imagePath: imagePath,
       );

  factory NotificationModel.fromMap(String id, Map<String, dynamic> map) {
    return NotificationModel(
      idNotif: map['idNotif'] ?? '',
      idReward: map['idReward'] ?? '',
      idParent: map['idParent'] ?? '',
      idKid: map['idKid'] ?? '',
      type: map['type'] ?? '',
      message: map['message'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      read: map['read'] ?? false,
      imagePath: map['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idParent': idParent,
      'idReward': idReward,
      'imagePath': imagePath,
      'idNotif': idNotif,
      'idKid': idKid,
      'type': type,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'read': read,
    };
  }
}
