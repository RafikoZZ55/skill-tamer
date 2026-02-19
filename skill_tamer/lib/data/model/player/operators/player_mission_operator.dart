

part of '../player.dart';


extension PlayerMissionOperator on Player {

  Mission _generateMission(){
    MissionType missionType = MissionType.getRandom();
    int aditionalPoints = getLevel().clamp(0, 20);
    int remainingPoints = aditionalPoints;
    Map<SkillAttributeType,int> attributeCheck = {};

    for (SkillAttributeType attribute in SkillAttributeType.values) {
        attributeCheck[attribute] = (missionType.baseAttributes[attribute] ?? 0);
    }

    while (remainingPoints > 0){
      SkillAttributeType attribute = SkillAttributeType.getRandom();
      attributeCheck[attribute] = ((attributeCheck[attribute] ?? 0) + 1).clamp(0, 10);
      remainingPoints--;
    }

    return Mission(
      type: missionType, 
      attributeCheck: attributeCheck,
    );

  }

  bool isMissionExpierd(){
    return currentMissionRefreshAt > DateTime.now().millisecondsSinceEpoch;
  }

  Map<SkillAttributeType,int> calculateSkillAttributeBoost(){
    List<TemporaryAttributeBoost> boostRewards = rewards.whereType<TemporaryAttributeBoost>().where((reward) => reward.isActive == true).toList();
    Map<SkillAttributeType,int> boost = {};

    for(TemporaryAttributeBoost reward in boostRewards){
      for(SkillAttributeType attribute in reward.attributesBoostAmount.keys){
        boost[attribute] = ((reward.attributesBoostAmount[attribute] ?? 0) + (boost[attribute] ?? 0)).clamp(0, 10);
      }
    }

    return boost;
  }

  Player refreshMission(){
    Mission newMission = _generateMission();
    int newCurrentMissionRefreshAt = DateTime.now().millisecondsSinceEpoch + Duration(hours: 1).inMilliseconds;
    return copyWith(currentMission: newMission, currentMissionRefreshAt: newCurrentMissionRefreshAt);
  }




}