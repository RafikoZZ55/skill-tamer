part of './player_mapper.dart';

extension PlayerMapperToStateOperator on PlayerMapper {

  List<SkillState> _toSkillsState({required List<Skill> skills}){
    List<SkillState> skillsState = [];

    for(Skill skill in skills){
      skillsState.add(_toSkillState(skill: skill));
    }

    return skillsState;
  }

  List<RewardState> _toRewardsState({required List<Reward> rewards}){
    List<RewardState> rewardState = [];

    for(Reward reward in rewards){
      rewardState.add(_toRewardState(reward: reward));
    }

    return rewardState; 
  }


  RewardState _toRewardState({required Reward reward}){
    RewardState rewardState;

    switch (reward.type) {
      case RewardType.redistributeAttributePoints : {
        rewardState = RewardState(
          type: reward.type.name, 
          isActive: reward.isActive,
        );
        break;
      }

      case RewardType.sessionBoost : {
        final sessionBoost = reward as SessionBoost;

        rewardState = RewardState(
          type: sessionBoost.type.name, 
          isActive: sessionBoost.isActive,
          sessionBoostMultiplyer: sessionBoost.sessionBoostMultiplyer,
        );
        break;
      }

      case RewardType.temporaryAttributeBoost : {
        final temporaryAttributeBoost = reward as TemporaryAttributeBoost;

        rewardState = RewardState(
          type: temporaryAttributeBoost.type.name, 
          isActive: temporaryAttributeBoost.isActive,
          activationTime: temporaryAttributeBoost.activationTime,
          attributesBoostAmount: _toSkillAttributeStateMap(attributes: temporaryAttributeBoost.attributesBoostAmount),
          duration: temporaryAttributeBoost.duration,
        );
        break;
      }
    }

    return rewardState;
  }

  SkillState _toSkillState({required Skill skill}){
    return SkillState(
      xpGained: skill.xpGained, 
      type: skill.type.name, 
      attributes: _toSkillAttributeStateMap(attributes: skill.attributes), 
      unspentAttributePoints: skill.unspentAttributePoints,
    );
  }



  MissionState _toCurrentMissionState({required Mission missionState}){
    return MissionState(
      attributeCheck: _toSkillAttributeStateMap(attributes: missionState.attributeCheck),
      type: missionState.type.name,
    );
  }

  SessionState _toActiveSessionState({required Session sessionState}){
    return SessionState(
      timeStarted: sessionState.timeStarted, 
      lastSessionCheck: sessionState.lastSessionCheck, 
      sessionSkill: sessionState.sessionSkill.name,
      );
  }


  Map<String,int> _toSkillAttributeStateMap({required Map<SkillAttributeType,int> attributes}){
    Map<String,int> attributesState = {};

    for(SkillAttributeType attribute in attributes.keys){
      attributesState[attribute.name] = attributes[attribute]!;
    }

    return attributesState;
  }
}