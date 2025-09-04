import 'package:flutter/material.dart';
import 'package:yuppi_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:yuppi_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:yuppi_app/features/notifications/injection/notify_accessible_rewards_injection.dart';

class NotificationsPage extends StatefulWidget {
  final List<NotificationEntity> listNotif;
  final void Function(bool hasUnread)? onUnreadStatusChanged;
  const NotificationsPage({
    super.key,
    required this.listNotif,
    this.onUnreadStatusChanged,
  });

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late List<NotificationEntity> notificaciones;

  @override
  void initState() {
    super.initState();
    notificaciones = widget.listNotif;
  }

  void removeNotification(int index) async {
    final removedNotif = notificaciones.removeAt(index);
    final notifications =
        await notifyAccessibleInjection<NotificationRepository>().markAsRead(
          removedNotif.idNotif,
        );

    setState(() {
      if (notificaciones.isEmpty) {
        widget.onUnreadStatusChanged?.call(false);
      }
    });
    // TODO opcional: Marcar como leída o eliminar en Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child:
                  notificaciones.isEmpty
                      ? Center(
                        child: Text(
                          'No hay notificaciones por el momento',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 18,
                          ),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: notificaciones.length,
                        itemBuilder: (context, index) {
                          final notification = notificaciones[index];
                          return _buildNotificationCard(notification, index);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blue, size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Notificaciones',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(NotificationEntity notification, int index) {
    final imagePath =
        notification.imagePath ?? _getImageForType(notification.type);

    return Card(
      color: Colors.blue.shade50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Image.asset(
            imagePath,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(notification.message, style: const TextStyle(fontSize: 16)),
        trailing: IconButton(
          icon: const Icon(Icons.close, color: Colors.red),
          onPressed: () => removeNotification(index),
        ),
      ),
    );
  }

  String _getImageForType(String? type) {
    switch (type) {
      case 'diamond':
      case 'Diamante':
        return 'assets/images/rewards/Diamante.webp';
      case 'gold':
      case 'Oro':
        return 'assets/images/rewards/Oro.webp';
      case 'bronze':
      case 'Bronce':
        return 'assets/images/rewards/Bronce.webp';
      case 'silver':
      case 'Plata':
        return 'assets/images/rewards/Plata.webp';
      case 'legend':
      case 'Leyenda':
        return 'assets/images/rewards/Leyenda.webp';
      default:
        return 'assets/images/notifications/default.png';
    }
  }
}
