import 'dart:math';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/enum/skill_type.dart';

class Skill {
  int xpGained;
  final SkillType type;
  Map<SkillAttributeType, int> attributes;
  int unspentAttributePoints;

  Skill({
    int? xpGained,
    required this.type,
    Map<SkillAttributeType, int>? attributes,
    int? unspentAttributePoints,
  })  : xpGained = xpGained ?? 0,
        attributes = attributes ?? type.baseAttributes,
        unspentAttributePoints = unspentAttributePoints ?? 0;


  Skill copyWith({
    int? xpGained,
    SkillType? type,
    Map<SkillAttributeType, int>? attributes,
    int? unspentAttributePoints
  }) {
    return Skill(
      type: type ?? this.type,
      xpGained: xpGained ?? this.xpGained,
      attributes: attributes ?? Map.from(this.attributes),
      unspentAttributePoints: unspentAttributePoints ?? this.unspentAttributePoints,
    );
  }

  int getLevel() {
    int level = 0;
    int xpLeft = xpGained;
    int xpForNext = 3000;
    double growth = 1.15;

    while (level < 15 && xpLeft >= xpForNext) {
      xpLeft -= xpForNext;
      level++;
      xpForNext = (xpForNext * growth).round();
    }
    return level;
  }

  int getNextLevelXp(){
    int currentLevel = getLevel();
    int xpForNext = 3000;
    double growth = 1.15;    
    return (xpForNext * pow(growth, currentLevel)).round();
  }

  int getXpForNextLevel(){
    int xpUsed = 0;
    int currentLevel = getLevel();
    int xpForNext = 3000;
    double growth = 1.15;
    
    while(currentLevel > 0){
      xpForNext = (xpForNext * growth).round();
      xpUsed += xpForNext;
      currentLevel--;
    }

    return xpGained - xpUsed;
  }

  
}
