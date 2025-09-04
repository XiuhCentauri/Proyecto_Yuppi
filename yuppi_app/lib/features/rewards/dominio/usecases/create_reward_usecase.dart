import 'package:yuppi_app/features/rewards/dominio/entities/Reward_model.dart';
import 'package:yuppi_app/features/rewards/dominio/repositories/reward_repository.dart';

class CreateRewardUseCase {
  final RewardRepository repository;

  CreateRewardUseCase({required this.repository});

  Future<void> call(RewardModel reward) async {
    return repository.createReward(reward);
  }
}
