import 'dart:math';
import 'package:skill_tamer/data/constant/app_durations.dart';
import 'package:skill_tamer/data/model/enum/mission_type.dart';
import 'package:skill_tamer/data/model/enum/reward_type.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/enum/skill_type.dart';
import 'package:skill_tamer/data/model/mission/mission.dart';
import 'package:skill_tamer/data/model/reward/instant_mission.dart';
import 'package:skill_tamer/data/model/reward/redistribute_attribute_points.dart';
import 'package:skill_tamer/data/model/reward/reward.dart';
import 'package:skill_tamer/data/model/reward/session_boost.dart';
import 'package:skill_tamer/data/model/reward/temporary_attribute_boost.dart';
import 'package:skill_tamer/data/model/session/session.dart';
import 'package:skill_tamer/data/model/session/session_history.dart';
import 'package:skill_tamer/data/model/skill/skill.dart';

part 'operators/player_mission_operator.dart';
part 'operators/player_session_operator.dart';
part 'operators/player_reward_operator.dart';
part 'operators/player_skill_operator.dart';

class Player {
  int xpGained;
  List<Skill> skills;
  List<Reward> rewards;
  int lastRefreshAt;
  Mission? currentMission;
  int nextMissionRefreshAt;
  Session? activeSession;
  List<SessionHistory> sessionHistory;


  Player({
    required this.nextMissionRefreshAt,
    required this.xpGained,
    required this.skills,
    required this.rewards,
    required this.lastRefreshAt,
    this.currentMission,
    this.activeSession,
    required this.sessionHistory,
  });

  static Player empty(){
    return Player(
      xpGained: 0,
      skills: [], 
      rewards: [], 
      lastRefreshAt: DateTime.now().millisecondsSinceEpoch,
      nextMissionRefreshAt: DateTime.now().millisecondsSinceEpoch,
      sessionHistory: []
    );
  }

  Player copyWith({
    Session? activeSession,
    bool activeSessionSet = false,
    List<Skill>? skills,
    List<Reward>? rewards,
    int? lastRefreshAt,
    Mission? currentMission,
    int? xpGained,
    int? nextMissionRefreshAt,
    Map<SkillAttributeType,int>? totalSkillBoost,
    List<SessionHistory>? sessionHistory,
  }) {
    return Player(
      activeSession: activeSessionSet ? activeSession : this.activeSession,
      xpGained: xpGained ?? this.xpGained,
      currentMission: currentMission ?? this.currentMission,
      skills: skills ?? List.from(this.skills),
      rewards: rewards ?? List.from(this.rewards),
      lastRefreshAt: lastRefreshAt ?? this.lastRefreshAt,
      nextMissionRefreshAt: nextMissionRefreshAt ?? this.nextMissionRefreshAt, 
      sessionHistory: sessionHistory ?? List.from(this.sessionHistory)
    );
  }

  int getLevel() {
    int level = 0;
    int xpLeft = xpGained;
    int xpForNext = 1000;
    double growth = 1.12;

    while (level < 50 && xpLeft >= xpForNext) {
      xpLeft -= xpForNext;
      level++;
      xpForNext = (xpForNext * growth).round();
    }
    return level;
  }

  int _totalXPForLevel(int level) {
    int total = 0;
    for (int i = 0; i < level; i++) {
      total += (1000 * pow(1.12, i)).round();
    }
    return total;
  }

  int xpGainedForNextLevel() {
    int level = getLevel();
    int xpUsed = _totalXPForLevel(level);
    return xpGained - xpUsed;
  }

  int xpToNextLevel() {
    int level = getLevel();
    int totalForNext = _totalXPForLevel(level + 1);
    return totalForNext - xpGained;
  }
}
