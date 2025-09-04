import 'dart:developer';

import 'package:yuppi_app/features/score/domain/repositories/scored_repository.dart';
//import 'package:yuppi_app/core/servicios/firebase_service.dart';
import 'package:yuppi_app/features/score/domain/entities/scored.dart';
import 'package:yuppi_app/features/notifications/injection/notify_accessible_rewards_injection.dart';
import 'package:yuppi_app/features/notifications/domain/usecases/NotifyNAccesibleR.dart';
import 'package:yuppi_app/features/rewards/innjection/rewards_injection.dart';
import 'package:yuppi_app/features/rewards/dominio/usecases/get_rewards_by_kid_id_usecase.dart';

import 'package:yuppi_app/features/rewards/dominio/entities/Reward_model.dart';
import 'package:yuppi_app/core/uuid_generator.dart';

class NewScoreMark {
  final ScoredRepository repository;

  NewScoreMark({required this.repository});

  Future<bool> changeScoreWin(String idKid, int NewCash) async {
    const int win = 1;
    int totalCash;

    final scoredPrevious = await repository.getScoredById(idKid);
    log("${scoredPrevious.idParent}");
    final int newWin = scoredPrevious.wins + win;
    totalCash = NewCash + scoredPrevious.cash;

    if (totalCash < 0) {
      totalCash = 0;
    }
    final Scored newScore = Scored(
      idScored: scoredPrevious.idScored,
      idKid: idKid,
      idParent: scoredPrevious.idParent,
      cash: totalCash,
      losses: scoredPrevious.losses,
      wins: newWin,
    );

    final update = await repository.updateScore(idKid, newScore);

    if (update) {
      final List<RewardModel> listaRecompensas =
          await sl<GetRewardsByKidIdUseCase>().call(idKid);
      log("Lista de recompensas: ${listaRecompensas}");
      final _observer =
          notifyAccessibleInjection<NotifyNewAccessibleRewardsUseCase>()
              .execute(
                scored: newScore,
                allRewards: listaRecompensas,
                previousCash: scoredPrevious.cash,
              );
    }
    return update;
  }

  Future<Scored> getScore(String idKid) async {
    final scored = await repository.getScoredById(idKid);

    return scored;
  }

  Future<bool> createScoredKid(String idKid, String idParent) async {
    final newScored = Scored(
      idScored: generateUuid(),
      idKid: idKid,
      idParent: idParent,
      cash: 0,
      losses: 0,
      wins: 0,
    );

    final response = await repository.createScore(newScored);

    return response;
  }

  Future<bool> changeScoreLoss(String idKid) async {
    const int loss = 1;

    final scoredPrevious = await repository.getScoredById(idKid);

    final int newLoss = scoredPrevious.wins + loss;
    final Scored newScore = Scored(
      idScored: scoredPrevious.idScored,
      idKid: idKid,
      idParent: scoredPrevious.idParent,
      cash: scoredPrevious.cash,
      losses: newLoss,
      wins: scoredPrevious.losses,
    );

    final update = await repository.updateScore(idKid, newScore);

    return update;
  }
}
