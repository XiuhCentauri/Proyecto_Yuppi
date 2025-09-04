class NotificationEntity {
  final String idNotif;
  final String idReward;
  final String idParent;
  final String idKid;
  final String type;
  final String message;
  final DateTime timestamp;
  final bool read;
  final String imagePath;

  NotificationEntity({
    required this.idNotif,
    required this.idReward,
    required this.idParent,
    required this.idKid,
    required this.type,
    required this.message,
    required this.timestamp,
    this.read = false,
    required this.imagePath,
  });

  NotificationEntity copyWith({
    String? idNotif,
    String? idReward,
    String? idParent,
    String? idKid,
    String? type,
    String? message,
    DateTime? timestamp,
    String? imagePath,
    bool? read,
  }) {
    return NotificationEntity(
      idNotif: idNotif ?? this.idNotif,
      idReward: idReward ?? this.idReward,
      idParent: idParent ?? this.idParent,
      idKid: idKid ?? this.idKid,
      type: type ?? this.type,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      imagePath: imagePath ?? this.imagePath,
      read: read ?? this.read,
    );
  }
}
