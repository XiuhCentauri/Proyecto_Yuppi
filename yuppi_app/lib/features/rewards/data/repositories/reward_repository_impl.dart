import 'package:yuppi_app/core/servicios/firebase_service.dart';
import 'package:yuppi_app/features/rewards/dominio/entities/Reward_model.dart';
import 'package:yuppi_app/features/rewards/dominio/repositories/reward_repository.dart';
import 'dart:developer';

class RewardRepositoryImpl implements RewardRepository {
  final _firestore = FirebaseService().firestore;

  final String collectionPath = 'rewards';
  final int statusPendiente = 1;

  @override
  Future<void> createReward(RewardModel reward) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(reward.idReward)
          .set(reward.toMap());
      log('Registrado en base');
    } catch (e) {
      throw Exception('Error al crear recompensa: $e');
    }
  }

  @override
  Future<bool> updateReward(RewardModel reward) async {
    await _firestore
        .collection(collectionPath)
        .doc(reward.idReward)
        .update(reward.toMap());

    return true;
  }

  @override
  Future<bool> deleteReward(String idReward) async {
    await _firestore.collection(collectionPath).doc(idReward).delete();

    return true;
  }

  @override
  Future<List<RewardModel>> getRewardStatusP(String idKid) async {
    try {
      final snapshot =
          await _firestore
              .collection(collectionPath)
              .where("IdKid", isEqualTo: idKid)
              .where("Status", isEqualTo: statusPendiente)
              .get();

      return snapshot.docs
          .map((doc) => RewardModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al obteneer recompensa (CAPA DATOS)');
    }
  }

  @override
  Future<List<RewardModel>> getRewardsByKidId(String idKid) async {
    try {
      final snapshot =
          await _firestore
              .collection(collectionPath)
              .where('IdKid', isEqualTo: idKid)
              .get();

      return snapshot.docs
          .map((doc) => RewardModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener recompensas: $e');
    }
  }

  // @override
  // Future<void> deleteReward(String rewardId) async {
  //   throw UnimplementedError();
  // }

  // @override
  // Future<void> updateRewardStatus(String rewardId, int newStatus) async {
  //   throw UnimplementedError();
  // }
}
