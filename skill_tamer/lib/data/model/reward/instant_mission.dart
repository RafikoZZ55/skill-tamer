import 'package:skill_tamer/data/model/enum/reward_type.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/player/player.dart';
import 'package:skill_tamer/data/model/reward/reward.dart';

class InstantMission extends Reward {
  InstantMission({
    bool? isActive,
  }): super(isActive: isActive ?? false, type: RewardType.instantMission);

  @override
  Player activate({required Player player, int? skillIndex}) {
    return player.copyWith(
        nextMissionRefreshAt: DateTime.now().millisecondsSinceEpoch, 
        lastRefreshAt: DateTime.now().millisecondsSinceEpoch
    );
  }

  @override
  Reward copyWith({bool? isActive, double? sessionBoostMultiplyer, Map<SkillAttributeType, int>? attributesBoostAmount, int? duration, int? activationTime}) {
    return InstantMission(
      isActive: this.isActive,
    );
  }

}