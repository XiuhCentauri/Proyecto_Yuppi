import 'dart:developer';

import 'package:yuppi_app/features/notifications/domain/observers/notification_observer.dart';
import 'package:yuppi_app/features/rewards/dominio/entities/Reward_model.dart';
import 'package:yuppi_app/features/rewards/dominio/repositories/reward_repository.dart';
import 'package:yuppi_app/features/score/domain/entities/scored.dart';
import 'package:yuppi_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:yuppi_app/features/notifications/domain/entities/notification_entity.dart';

final Map<String, String> categoryImages = {
  'Bronce': 'assets/images/rewards/Bronce.webp',
  'Plata': 'assets/images/rewards/Plata.webp',
  'Oro': 'assets/images/rewards/Oro.webp',
  'Diamante': 'assets/images/rewards/Diamante.webp',
  'Leyenda': 'assets/images/rewards/Leyenda.webp',
};

class NotifyNewAccessibleRewardsUseCase {
  final RewardRepository rewardRepository;
  final NotificationRepository notificationRepository;
  final NotificationObserver observer;

  NotifyNewAccessibleRewardsUseCase({
    required this.rewardRepository,
    required this.observer,
    required this.notificationRepository,
  });

  Future<void> execute({
    required Scored scored,
    required List<RewardModel> allRewards,
    required int previousCash,
  }) async {
    final nowAccessible = allRewards.where(
      (reward) => reward.countRewards <= scored.cash,
    );

    final List<NotificationEntity> notifications = await notificationRepository
        .getNotificationsForUser(scored.idKid);

    final filteredRewards =
        nowAccessible.where((reward) {
          final yaNotificada = notifications.any(
            (n) =>
                n.idReward ==
                reward.idReward, // ← asegurarte que se llama igual
          );
          return !yaNotificada;
        }).toList();

    //final nowAccessible
    log("Mi Dinero: ${scored.cash}");
    for (final reward in filteredRewards) {
      String imagePath = _handleImagePath(reward.categoryRewards);
      log(imagePath);
      log(
        "Recompensa accesible: ${reward.nameRewards} - cuesta: ${reward.countRewards}",
      );

      await observer.notify("reward_claimed", {
        'idParent': scored.idParent,
        'idNotif': '',
        'idKid': scored.idKid,
        'idReward': reward.idReward,
        'message':
            "¡Tienes una recompensa disponible en la sección ${reward.categoryRewards}! Ve a canjearla",
        'imagePath': imagePath,
      });
    }
  }

  String _handleImagePath(String category) {
    switch (category) {
      case 'Bronce':
        return 'assets/images/rewards/Bronce.webp';
      case 'Plata':
        return 'assets/images/rewards/Plata.webp';
      case 'Oro':
        return 'assets/images/rewards/Oro.webp';
      case 'Diamante':
        return 'assets/images/rewards/Diamante.webp';
      case 'Leyenda':
        return 'assets/images/rewards/Leyenda.webp';
      default:
        return 'assets/images/rewards/Bronce.webp'; // Ruta por defecto para evitar crash
    }
  }
}
