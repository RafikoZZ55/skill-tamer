import 'package:skill_tamer/data/model/enum/reward_type.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/player/player.dart';
import 'package:skill_tamer/data/model/reward/reward.dart';
import 'package:skill_tamer/data/model/skill/skill.dart';

class RedistributeAttributePoints extends Reward {

  RedistributeAttributePoints({
    bool? isActive
  }) : super(
    type: RewardType.redistributeAttributePoints,
    isActive: isActive ?? false,
  );

  @override
  Player activate({required Player player, int? skillIndex}) {
    if(skillIndex == null) throw Error();
    Player newPlayer = player.copyWith();

    List<Reward> newRewards = List.from(player.rewards);
    newRewards.removeWhere((e) => e == this);

    List<Skill> newSkills = List.from(player.skills);
    Skill newSkill = newSkills[skillIndex].copyWith();
    int spentAttributePoints = 0;

    for(SkillAttributeType attribute in newSkill.attributes.keys){
      spentAttributePoints += newSkill.attributes[attribute]! - newSkill.type.baseAttributes[attribute]!;
      newSkill.attributes[attribute] = newSkill.type.baseAttributes[attribute]!;
    }
    
    newSkill.unspentAttributePoints += spentAttributePoints;
    newSkills[skillIndex] = newSkill;


    return newPlayer.copyWith(
      rewards: newRewards,
      skills: newSkills,
    );
  }
  
  @override
  Reward copyWith({bool? isActive, double? sessionBoostMultiplyer, Map<SkillAttributeType, int>? attributesBoostAmount, int? duration, int? activationTime}) {
    return RedistributeAttributePoints(
      isActive: isActive ?? this.isActive
    );
  }


  
}