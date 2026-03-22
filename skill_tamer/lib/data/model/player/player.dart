import 'dart:math';
import 'package:skill_tamer/data/constant/app_durations.dart';
import 'package:skill_tamer/data/model/enum/mission_type.dart';
import 'package:skill_tamer/data/model/enum/reward_type.dart';
import 'package:skill_tamer/data/model/enum/session_status_type.dart';
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
  List<SessionHistory> sessionsHistory;


  Player({
    required this.nextMissionRefreshAt,
    required this.xpGained,
    required this.skills,
    required this.rewards,
    required this.lastRefreshAt,
    this.currentMission,
    this.activeSession,
    required this.sessionsHistory,
  });

  static Player empty(){
    return Player(
      xpGained: 0,
      skills: [], 
      rewards: [], 
      lastRefreshAt: DateTime.now().millisecondsSinceEpoch,
      nextMissionRefreshAt: DateTime.now().millisecondsSinceEpoch,
      sessionsHistory: []
    );
  }

  static Player initial() {
    return Player(
      nextMissionRefreshAt: DateTime.now().millisecondsSinceEpoch, 
      xpGained: 0, 
      skills: SkillType.values.map((e) => Skill(type: e, unspentAttributePoints: 2)).toList(), 
      rewards: [
        InstantMission(),
        RedistributeAttributePoints(),
        SessionBoost(sessionBoostMultiplyer: 0.3),
        SessionBoost(sessionBoostMultiplyer: 0.5),
        SessionBoost(sessionBoostMultiplyer: 0.7),
        SessionBoost(sessionBoostMultiplyer: 0.1),
        SessionBoost(sessionBoostMultiplyer: 0.4),
        TemporaryAttributeBoost(attributesBoostAmount: {SkillAttributeType.cognitive: 2}),
        TemporaryAttributeBoost(attributesBoostAmount: {SkillAttributeType.creative: 2}),
        TemporaryAttributeBoost(attributesBoostAmount: {SkillAttributeType.social: 2}),
      ], 
      lastRefreshAt:  DateTime.now().millisecondsSinceEpoch, 
      sessionsHistory: [
        SessionHistory(
          status: SessionStatusType.completed, 
          duration: 1000 * 60 * 25, 
          skillType: SkillType.archery, 
          completedAt: DateTime.now().millisecondsSinceEpoch - 1000 * 60 * 60 * 5
        ),
        SessionHistory(
          status: SessionStatusType.fullyCompleted, 
          duration: 1000 * 60 * 90, 
          skillType: SkillType.dancing, 
          completedAt: DateTime.now().millisecondsSinceEpoch - 1000 * 60 * 60 * 9
        ),
        SessionHistory(
          status: SessionStatusType.completed, 
          duration: 1000 * 60 * 40, 
          skillType: SkillType.archery, 
          completedAt: DateTime.now().millisecondsSinceEpoch - 1000 * 60 * 60 * 10
        ),
      ]
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
    List<SessionHistory>? sessionsHistory,
  }) {
    return Player(
      activeSession: activeSessionSet ? activeSession : this.activeSession,
      xpGained: xpGained ?? this.xpGained,
      currentMission: currentMission ?? this.currentMission,
      skills: skills ?? List.from(this.skills),
      rewards: rewards ?? List.from(this.rewards),
      lastRefreshAt: lastRefreshAt ?? this.lastRefreshAt,
      nextMissionRefreshAt: nextMissionRefreshAt ?? this.nextMissionRefreshAt, 
      sessionsHistory: sessionsHistory ?? List.from(this.sessionsHistory)
    );
  }

  static const int _baseXp = 1000;
  static const double _growth = 1.12;
  static const int _maxLevel = 50;

  int _xpForLevel(int level) {
    return (_baseXp * pow(_growth, level)).round();
  }

  int getLevel() {
    int level = 0;
    int xpLeft = xpGained;

    while (level < _maxLevel) {
      final needed = _xpForLevel(level);
      if (xpLeft < needed) break;

      xpLeft -= needed;
      level++;
    }

    return level;
  }

  int _totalXPForLevel(int level) {
    int total = 0;
    for (int i = 0; i < level; i++) {
      total += _xpForLevel(i);
    }
    return total;
  }

  int xpGainedForNextLevel() {
    final currentLevel = getLevel();
    final xpUsed = _totalXPForLevel(currentLevel);
    return xpGained - xpUsed;
  }

  int xpToNextLevel() {
    final currentLevel = getLevel();

    if (currentLevel >= _maxLevel) return 0;

    final xpUsed = _totalXPForLevel(currentLevel);
    final xpForNext = _xpForLevel(currentLevel);

    return xpForNext - (xpGained - xpUsed);
  }
}