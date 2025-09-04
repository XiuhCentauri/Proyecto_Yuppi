import "package:yuppi_app/features/rewards/dominio/entities/Reward_model.dart";

abstract class RewardRepository {
  /// Crea una nueva recompensa en la base de datos
  Future<void> createReward(RewardModel reward);

  /// Obtiene todas las recompensas asociadas a un niño por su ID
  Future<List<RewardModel>> getRewardsByKidId(String idKid);
  Future<List<RewardModel>> getRewardStatusP(String idKid);
  Future<bool> updateReward(RewardModel reward);
  Future<bool> deleteReward(String idReward);

  /// Elimina una recompensa (opcional)
  //Future<void> deleteReward(String rewardId);

  /// Actualiza el estado de una recompensa (opcional)
  //Future<void> updateRewardStatus(String rewardId, int newStatus);
}
