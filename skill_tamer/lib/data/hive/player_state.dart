import 'package:hive/hive.dart';
import 'package:skill_tamer/data/hive/mission_state.dart';
import 'package:skill_tamer/data/hive/reward_state.dart';
import 'package:skill_tamer/data/hive/session_state.dart';
import 'package:skill_tamer/data/hive/skill_state.dart';

part 'generated/player_state.g.dart';

@HiveType(typeId: 4)
class PlayerState {

  @HiveField(0)
  int xpGained;

  @HiveField(1)
  List<SkillState> skills;

  @HiveField(2)
  List<RewardState> rewards;

  @HiveField(3)
  int lastRefreshAt;

  @HiveField(4)
  MissionState? currentMission;

  @HiveField(5)
  int nextMissionRefreshAt;

  @HiveField(6)
  SessionState? activeSession;

  PlayerState({
    required this.xpGained,
    required this.skills,
    required this.rewards,
    required this.lastRefreshAt,
    required this.nextMissionRefreshAt,
    this.currentMission,
    this.activeSession,
  });

}