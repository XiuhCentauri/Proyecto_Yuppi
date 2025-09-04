import 'package:get_it/get_it.dart';
import 'package:yuppi_app/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:yuppi_app/features/notifications/domain/observers/new_reward_accessible_observer.dart';
import 'package:yuppi_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:yuppi_app/features/notifications/domain/observers/notification_observer.dart';
import 'package:yuppi_app/features/notifications/domain/usecases/NotifyNAccesibleR.dart';
import 'package:yuppi_app/features/notifications/domain/observers/reward_notification_observer.dart';
import 'package:yuppi_app/features/rewards/innjection/rewards_injection.dart';
import 'package:yuppi_app/features/rewards/dominio/repositories/reward_repository.dart';

final notifyAccessibleInjection = GetIt.instance;

class NotifyAccessibleRewardsInjection {
  Future<void> init() async {
    // Factory
    notifyAccessibleInjection.registerLazySingleton<NotificationFactory>(
      () => NotificationFactory(),
    );

    // Repository
    notifyAccessibleInjection.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(),
    );

    // Observer
    notifyAccessibleInjection.registerLazySingleton<NotificationObserver>(
      () => NewRewardAccessibleObserver(
        factory: notifyAccessibleInjection<NotificationFactory>(),
        repository: notifyAccessibleInjection<NotificationRepository>(),
      ),
    );

    // RewardRepository (usamos otro GetIt si lo tienes registrado así)
    final rewardRepository = sl<RewardRepository>();

    // UseCase
    notifyAccessibleInjection
        .registerLazySingleton<NotifyNewAccessibleRewardsUseCase>(
          () => NotifyNewAccessibleRewardsUseCase(
            rewardRepository: rewardRepository,
            observer: notifyAccessibleInjection<NotificationObserver>(),
            notificationRepository:
                notifyAccessibleInjection<NotificationRepository>(),
          ),
        );
  }
}
