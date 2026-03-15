import 'package:skill_tamer/data/model/enum/skill_type.dart';

class SessionHistory {
  Duration duration;
  SkillType skillType;
  int completedAt;

  SessionHistory({
    required this.duration,
    required this.skillType,
    required this.completedAt,
  });
  
}