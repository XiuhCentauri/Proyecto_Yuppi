import 'package:yuppi_app/features/rewards/dominio/repositories/reward_repository.dart';
import 'package:yuppi_app/features/rewards/dominio/usecases/create_reward_usecase.dart';
import 'package:yuppi_app/features/rewards/data/repositories/reward_repository_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:yuppi_app/features/rewards/dominio/usecases/get_rewards_by_kid_id_usecase.dart';
import 'package:yuppi_app/features/rewards/dominio/usecases/get_rewards_StatusP.dart';
import 'package:yuppi_app/features/rewards/dominio/usecases/updateR_usecase.dart';
import 'package:yuppi_app/features/rewards/dominio/usecases/deleteR_usecase.dart';

final sl = GetIt.instance;

class RewardsInjection {
  Future<void> init() async {
    // Repository
    sl.registerLazySingleton<RewardRepository>(() => RewardRepositoryImpl());

    // Use Cases
    sl.registerLazySingleton<CreateRewardUseCase>(
      () => CreateRewardUseCase(repository: sl()),
    );

    sl.registerLazySingleton<GetRewardsByKidIdUseCase>(
      () => GetRewardsByKidIdUseCase(repository: sl()),
    );

    sl.registerLazySingleton<GetRewardsStatusp>(
      () => GetRewardsStatusp(repository: sl()),
    );

    sl.registerLazySingleton<DeleteReward>(
      () => DeleteReward(repository: sl()),
    );

    sl.registerLazySingleton<UpdateReward>(
      () => UpdateReward(repository: sl()),
    );
  }
}
