abstract class EmailRepository {
  Future<void> sendRegistrationEmail({
    required String email,
    required String name,
  });

  Future<void> sendRewardNotification({
    required String email,
    required String childName,
    required String rewardName,
    required int remainingCoins,
    required int remainingThisReward,
  });
}
