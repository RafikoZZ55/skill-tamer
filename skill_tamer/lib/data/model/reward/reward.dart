import 'package:skill_tamer/data/model/enum/reward_type.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/player/player.dart';

abstract class Reward {
  bool isActive;
  RewardType type;

  Reward({
    required this.isActive,
    required this.type,
  });
  
  Player activate({required Player player, int? skillIndex});

  Reward copyWith({
  bool? isActive,
  double? sessionBoostMultiplyer,
  Map<SkillAttributeType,int>? attributesBoostAmount,
  int? duration,
  int? activationTime,
  });
}