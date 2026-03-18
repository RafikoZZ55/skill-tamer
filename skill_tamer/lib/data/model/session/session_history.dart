import 'package:skill_tamer/data/model/enum/session_status_type.dart';
import 'package:skill_tamer/data/model/enum/skill_type.dart';

class SessionHistory {
  int duration;
  SkillType skillType;
  int completedAt;
  SessionStatusType status;

  SessionHistory({
    required this.status,
    required this.duration,
    required this.skillType,
    required this.completedAt,
  });
  
}