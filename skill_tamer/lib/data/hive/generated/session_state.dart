import 'package:hive/hive.dart';

part 'session_state.g.dart';

@HiveType(typeId: 1)
class SessionState {
  @HiveField(0)
  int timeStarted;

  @HiveField(1)
  int sessionDuration;

  @HiveField(2)
  int lastSessionCheck;

  @HiveField(3)
  String sessionSkill;


  SessionState({
    required this.timeStarted,
    required this.sessionDuration,
    required this.lastSessionCheck,
    required this.sessionSkill,
  });
}