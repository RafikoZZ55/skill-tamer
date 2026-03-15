
import 'package:hive/hive.dart';

part 'generated/session_history_state.g.dart';

@HiveType(typeId: 5)
class SessionHistoryState {
  @HiveField(0)
  Duration duration;

  @HiveField(1)
  String skillType;

  @HiveField(2)
  int completedAt;

  SessionHistoryState({
    required this.completedAt,
    required this.duration,
    required this.skillType,
  });

  
}