import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/reward/temporary_reward.dart';

class TemporaryAttributeBoost extends TemporaryReward {
  Map<SkillAttributeType,int> attributesBoostAmount;


  TemporaryAttributeBoost({
    required this.attributesBoostAmount,
    super.activationTime,
    bool? isActive,
  }) : super(
    description: "Boost your stats for short time",
    icon: "🥳",
    name: "Attribute Boost",
    duration: Duration(days: 1).inMilliseconds,
    isActive: isActive ?? false,
  );
}