import 'package:skill_tamer/data/model/enum/reward_type.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/player/player.dart';
import 'package:skill_tamer/data/model/reward/reward.dart';

class SessionBoost extends Reward {
  double sessionBoostMultiplyer;

  SessionBoost({
    required this.sessionBoostMultiplyer,
    bool? isActive,
  }) : super(
    isActive: isActive ?? false,
    type: RewardType.sessionBoost,
  );

  @override
  Player activate({required Player player, int? skillIndex}) {
    Player newPlayer = player.copyWith();
    List<Reward> newRewards = List.from(newPlayer.rewards);
    int rewardIndex = newRewards.indexOf(this);
    newRewards[rewardIndex] = newRewards[rewardIndex].copyWith(isActive: true);
    
    return newPlayer.copyWith(rewards: newRewards);
  }

  @override
  Reward copyWith({bool? isActive, double? sessionBoostMultiplyer, Map<SkillAttributeType, int>? attributesBoostAmount, int? duration, int? activationTime}) {
    return SessionBoost(
      sessionBoostMultiplyer: sessionBoostMultiplyer ?? this.sessionBoostMultiplyer, 
      isActive: isActive ?? this.isActive
    );
  }


}