import 'package:yuppi_app/features/rewards/dominio/repositories/reward_repository.dart';
import 'package:yuppi_app/features/rewards/dominio/entities/Reward_model.dart';

class UpdateReward {
  final RewardRepository repository;
  UpdateReward({required this.repository});

  Future<bool> call(RewardModel reward) async {
    final result = await repository.updateReward(reward);

    if (result == false) return false;

    return true;
  }
}
