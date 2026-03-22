import 'package:skill_tamer/data/model/enum/reward_type.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/player/player.dart';
import 'package:skill_tamer/data/model/reward/reward.dart';

class InstantMission extends Reward {
  InstantMission({
    super.isActive = false,
  }) : super(type: RewardType.instantMission);

  @override
  Player activate({required Player player, required int skillIndex}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    List<Reward> newRewards = List.from(player.rewards);
    newRewards.removeWhere((e) => e == this);

    return player.copyWith(
      nextMissionRefreshAt: now,
      lastRefreshAt: now,
      rewards: newRewards,
    );
  }

  @override
  Reward copyWith({
    bool? isActive,
    double? sessionBoostMultiplyer,
    Map<SkillAttributeType, int>? attributesBoostAmount,
    int? duration,
    int? activationTime,
  }) {
    return InstantMission(
      isActive: isActive ?? this.isActive,
    );
  }
}