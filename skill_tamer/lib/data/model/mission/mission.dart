import 'package:skill_tamer/data/model/enum/mission_type.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';

class Mission {
  MissionType type;
  Map<SkillAttributeType, int> attributeCheck;
  bool isComplete;

  Mission({
    required this.type,
    required this.attributeCheck,
    required this.isComplete,
  });

  Mission copyWith({
    MissionType? type,
    Map<SkillAttributeType, int>? attributeCheck,
    bool? isComplete,
  }) {
    return Mission(
      type: type ?? this.type,
      attributeCheck: attributeCheck ?? Map.from(this.attributeCheck),
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
