import 'package:yuppi_app/features/auth/dominio/entities/parent.dart';
import 'package:yuppi_app/features/clientMail/dominio/repositories/email_repository.dart';
import 'package:yuppi_app/features/rewards/dominio/entities/Reward_model.dart';

class SendRewardUsecase {
  final EmailRepository repository;

  SendRewardUsecase({required this.repository});

  Future<bool> call(
    String reward,
    String email,
    String chilname,
    int cashRest,
    int cantRest,
  ) async {
    await repository.sendRewardNotification(
      email: email,
      childName: chilname,
      rewardName: reward,
      remainingCoins: cashRest,
      remainingThisReward: cantRest,
    );

    return true;
  }
}
