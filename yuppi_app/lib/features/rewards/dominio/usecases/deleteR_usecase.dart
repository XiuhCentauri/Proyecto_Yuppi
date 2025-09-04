import 'package:yuppi_app/features/rewards/dominio/repositories/reward_repository.dart';

class DeleteReward {
  final RewardRepository repository;
  DeleteReward({required this.repository});

  Future<bool> call(String idReward) async {
    final result = await repository.deleteReward(idReward);

    if (result == false) return false;

    return true;
  }
}
