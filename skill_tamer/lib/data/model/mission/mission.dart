import 'package:skill_tamer/data/model/enum/mission_type.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';

class Mission {
  MissionType type;
  Map<SkillAttributeType,int> attributeCheck;

  Mission({
    required this.type,
    required this.attributeCheck,
  });
}