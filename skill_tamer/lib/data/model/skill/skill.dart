import 'package:skill_tamer/data/model/enum/skill_attribute.dart';
import 'package:skill_tamer/data/model/enum/skill_type.dart';

class Skill {
  int xpGained;
  final SkillType type;
  Map<SkillAttribute, int> attributes;

  Skill({
    int? xpGained,
    required this.type,
    Map<SkillAttribute, int>? attributes,
  })  : xpGained = xpGained ?? 0,
        attributes = attributes ?? type.baseAttributes;

  int calculateLevel(){
    return 1;
  }

  int calculateExpToNextLevel(){
    return 1;
  }


  Skill copyWith({
    int? xpGained,
    SkillType? type,
    Map<SkillAttribute, int>? attributes
  }) {
    return Skill(
      type: type ?? this.type,
      xpGained: xpGained ?? this.xpGained,
      attributes: attributes ?? Map.from(this.attributes),
    );
  }
}
