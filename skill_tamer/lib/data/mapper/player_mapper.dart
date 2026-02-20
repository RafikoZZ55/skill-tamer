
import 'package:skill_tamer/data/hive/session_state.dart';
import 'package:skill_tamer/data/hive/mission_state.dart';
import 'package:skill_tamer/data/hive/player_state.dart';
import 'package:skill_tamer/data/hive/reward_state.dart';
import 'package:skill_tamer/data/hive/skill_state.dart';
import 'package:skill_tamer/data/model/enum/mission_type.dart';
import 'package:skill_tamer/data/model/enum/reward_type.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/enum/skill_type.dart';
import 'package:skill_tamer/data/model/mission/mission.dart';
import 'package:skill_tamer/data/model/player/player.dart';
import 'package:skill_tamer/data/model/reward/redistribute_attribute_points.dart';
import 'package:skill_tamer/data/model/reward/reward.dart';
import 'package:skill_tamer/data/model/reward/session_boost.dart';
import 'package:skill_tamer/data/model/reward/temporary_attribute_boost.dart';
import 'package:skill_tamer/data/model/session/session.dart';
import 'package:skill_tamer/data/model/skill/skill.dart';

part './player_mapper_from_state_operator.dart';
part './player_mapper_to_state_operator.dart';

class PlayerMapper {

  Player fromState({required PlayerState playerState}){
    return Player(
      nextMissionRefreshAt: playerState.nextMissionRefreshAt, 
      xpGained: playerState.xpGained, 
      skills: _fromSkillsState(skillsState: playerState.skills), 
      rewards: _fromRewardsState(rewardsState: playerState.rewards), 
      lastRefreshAt: playerState.lastRefreshAt,
      currentMission: playerState.currentMission == null ? null : _formCurrentMissionState(missionState: playerState.currentMission!),
      activeSession: playerState.activeSession == null ? null : _fromActiveSessionState(sessionState: playerState.activeSession!),
    );
  }

  PlayerState toState({required Player player}){
    return PlayerState(
      xpGained: player.xpGained, 
      skills: _toSkillsState(skills: player.skills), 
      rewards: _toRewardsState(rewards: player.rewards), 
      lastRefreshAt: player.lastRefreshAt, 
      nextMissionRefreshAt: player.nextMissionRefreshAt,
      currentMission: player.currentMission == null ? null : _toCurrentMissionState(missionState: player.currentMission!),
      activeSession: player.activeSession == null? null: _toActiveSessionState(sessionState: player.activeSession!),
    );
  }

}