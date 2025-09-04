import 'package:yuppi_app/features/rewards/dominio/entities/Reward_model.dart';
import 'package:yuppi_app/features/rewards/dominio/repositories/reward_repository.dart';



class GetRewardsStatusp {

  final RewardRepository repository;

  GetRewardsStatusp({required this.repository});

  Future<List<RewardModel>> getListRewardStatusP(String idKid) async{
    return await repository.getRewardStatusP(idKid);
  }
}