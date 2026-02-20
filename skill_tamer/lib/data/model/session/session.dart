import 'package:skill_tamer/data/model/enum/skill_type.dart';

class Session {
  int timeStarted;

  int lastSessionCheck;
  SkillType sessionSkill;

  Session({
    required this.timeStarted,
    required this.sessionSkill,
    int? lastSessionCheck
  }): lastSessionCheck = lastSessionCheck ?? timeStarted;

  Session copyWith({
  int? timeStarted,
  int? lastSessionCheck,
  SkillType? sessionSkill,   
  }) {
    return Session(
      timeStarted: timeStarted ?? this.timeStarted, 
      sessionSkill: sessionSkill ?? this.sessionSkill,
      lastSessionCheck: lastSessionCheck ?? this.lastSessionCheck 
    );
  }


  bool isFinnished(){
    return (DateTime.now().millisecondsSinceEpoch - timeStarted >= sessionSkill.recommendedSessionDuration.inMilliseconds) && lastSessionCheck <= DateTime.now().millisecondsSinceEpoch - const Duration(minutes: 15).inMilliseconds;
  }

bool isAbandoned() {
  return DateTime.now().millisecondsSinceEpoch - lastSessionCheck > const Duration(minutes: 15).inMilliseconds;
}

}