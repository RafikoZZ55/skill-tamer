
part of './player_mapper.dart';

extension PlayerMapperFromStateOperator on PlayerMapper {



  List<Skill> _fromSkillsState({required List<SkillState> skillsState}){
    List<Skill> skills = [];

    for(SkillState skillState in skillsState){
      skills.add(_fromSkillState(skillState: skillState));
    }

    return skills;
  }

  List<Reward> _fromRewardsState({required List<RewardState> rewardsState}){
    List<Reward> rewards = [];

    for(RewardState rewardState in rewardsState){
      rewards.add(_fromRewardState(rewardState: rewardState));
    }

    return rewards;
  }

  Reward _fromRewardState({required RewardState rewardState}){
    Reward reward;

    switch (RewardType.get(rewardName: rewardState.type)){
      case RewardType.sessionBoost : {
        reward = SessionBoost(
          sessionBoostMultiplyer: rewardState.sessionBoostMultiplyer ?? 0,
          isActive: rewardState.isActive
        );
        break;
      }
      
      case RewardType.redistributeAttributePoints: {
        reward = RedistributeAttributePoints(
          isActive: rewardState.isActive,
        );
        break;
      }

      case RewardType.temporaryAttributeBoost: {
        reward = TemporaryAttributeBoost(
          attributesBoostAmount: _fromSkillAttributeStateMap(attributesState: rewardState.attributesBoostAmount!),
          activationTime: rewardState.activationTime,
          isActive: rewardState.isActive,
        );
      }
    }
    
    return reward;
  }

  Skill _fromSkillState({required SkillState skillState}){
    return Skill(
      type: SkillType.get(skillName: skillState.type),
      attributes: _fromSkillAttributeStateMap(attributesState: skillState.attributes),
      unspentAttributePoints: skillState.unspentAttributePoints,
      xpGained: skillState.xpGained,
    );
  }

  Mission _formCurrentMissionState({required MissionState missionState}){
    return Mission(
      type: MissionType.get(missionName: missionState.type), 
      attributeCheck: _fromSkillAttributeStateMap(attributesState: missionState.attributeCheck),
    );
  }

  Session _fromActiveSessionState({required SessionState sessionState}){
    return Session(
      timeStarted: sessionState.timeStarted, 
      sessionSkill: SkillType.get(skillName: sessionState.sessionSkill),
      lastSessionCheck: sessionState.lastSessionCheck
    );
  }

  Map<SkillAttributeType,int> _fromSkillAttributeStateMap({required Map<String,int> attributesState}){
    Map<SkillAttributeType,int> attributes = {};

    for(String attributeState in attributesState.keys){
      attributes[SkillAttributeType.get(skillAttributeName: attributeState)] = attributesState[attributeState]!;
    }

    return attributes;
  }

}