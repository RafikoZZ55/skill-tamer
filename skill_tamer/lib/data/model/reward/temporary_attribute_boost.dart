import 'package:skill_tamer/data/model/enum/reward_type.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/player/player.dart';
import 'package:skill_tamer/data/model/reward/reward.dart';
import 'package:skill_tamer/data/model/reward/temporary_reward.dart';

class TemporaryAttributeBoost extends TemporaryReward {
  Map<SkillAttributeType,int> attributesBoostAmount;


  TemporaryAttributeBoost({
    required this.attributesBoostAmount,
    super.activationTime,
    bool? isActive,
  }) : super(
    type: RewardType.temporaryAttributeBoost,
    duration: Duration(days: 1).inMilliseconds,
    isActive: isActive ?? false,
  );

  @override
  Player activate({required Player player, int? skillIndex}) {
    // apply attribute amounts to the global boost map (stacking)
    Map<SkillAttributeType,int> newBoost = Map.from(player.totalSkillBoost);
    for (final attr in attributesBoostAmount.keys) {
      newBoost[attr] = ((newBoost[attr] ?? 0) + attributesBoostAmount[attr]!).clamp(0, 10);
    }

    Player newPlayer = player.copyWith(totalSkillBoost: newBoost);

    // mark reward active too for compatibility
    List<Reward> newRewards = List.from(newPlayer.rewards);
    int rewardIndex = newRewards.indexOf(this);
    if (rewardIndex != -1) {
      newRewards[rewardIndex] = newRewards[rewardIndex].copyWith(
        isActive: true,
        activationTime: DateTime.now().millisecondsSinceEpoch,
      );
    }

    return newPlayer.copyWith(rewards: newRewards);
  }
  
  @override
  Reward copyWith({bool? isActive, double? sessionBoostMultiplyer, Map<SkillAttributeType, int>? attributesBoostAmount, int? duration, int? activationTime}) {
    return TemporaryAttributeBoost(
      attributesBoostAmount: attributesBoostAmount ?? Map.from(this.attributesBoostAmount),
      isActive: isActive ?? this.isActive,
      activationTime: activationTime ?? this.activationTime
    );
  }

}