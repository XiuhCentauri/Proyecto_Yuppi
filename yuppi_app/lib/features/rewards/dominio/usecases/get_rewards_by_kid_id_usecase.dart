import 'package:yuppi_app/features/rewards/dominio/entities/Reward_model.dart';
import 'package:yuppi_app/features/rewards/dominio/repositories/reward_repository.dart';

class GetRewardsByKidIdUseCase {
  final RewardRepository repository;

  GetRewardsByKidIdUseCase({required this.repository});

  Future<List<RewardModel>> call(String kidId) {
    return repository.getRewardsByKidId(kidId);
  }
}
