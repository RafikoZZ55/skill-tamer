import 'package:hive/hive.dart';

part 'generated/session_state.g.dart';

@HiveType(typeId: 1)
class SessionState {
  @HiveField(0)
  int timeStarted;

  @HiveField(1)
  int lastSessionCheck;

  @HiveField(2)
  String sessionSkill;


  SessionState({
    required this.timeStarted,
    required this.lastSessionCheck,
    required this.sessionSkill,
  });
}