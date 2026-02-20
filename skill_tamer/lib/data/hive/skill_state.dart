import 'package:hive/hive.dart';

part 'generated/skill_state.g.dart';

@HiveType(typeId: 0)
class SkillState {
  @HiveField(0)
  int xpGained;

  @HiveField(1)
  String type;

  @HiveField(2)
  Map<String, int> attributes;

  @HiveField(3)
  int unspentAttributePoints;

  SkillState({
    required this.xpGained,
    required this.type,
    required this.attributes,
    required this.unspentAttributePoints,
  });
}