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

  /// Creates a copy of the mission with any given fields replaced.
  ///
  /// This is used by the controller/operator when marking a mission as
  /// completed or regenerating one. Fields that are not passed will remain
  /// unchanged.
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
