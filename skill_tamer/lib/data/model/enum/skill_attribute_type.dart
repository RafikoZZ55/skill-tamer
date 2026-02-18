import 'dart:math';

enum SkillAttributeType {
  cognitive,
  creative,
  physical,
  social,
  technical;


  static SkillAttributeType get({ required String skillAttributeName}){
    return SkillAttributeType.values.singleWhere((e) => e.name == skillAttributeName);
  }

  static SkillAttributeType getRandom(){
    return SkillAttributeType.values.toList()[Random().nextInt( SkillAttributeType.values.length)];
  }
}
