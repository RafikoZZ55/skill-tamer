

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

  Player refreshMission(){
    Mission newMission = _generateMission();
    int newCurrentMissionRefreshAt = DateTime.now().millisecondsSinceEpoch + Duration(hours: 1).inMilliseconds;
    return copyWith(currentMission: newMission, currentMissionRefreshAt: newCurrentMissionRefreshAt);
  }

  Reward _generateReward(){
    int rewardIndex = Random().nextInt(3);
    Reward reward;

    switch (rewardIndex){
      case 0: {
        reward = RedistributeAttributePoints();
        break;
      }
      case 1: {
        double procentage = Random().nextDouble();
        double sesionBoostMultiplyer = 1;

        if(procentage <= 25){sesionBoostMultiplyer += 0.05;}
        else if (procentage <= 50) {sesionBoostMultiplyer += 0.1;}
        else if (procentage <= 90) {sesionBoostMultiplyer += 0.15;}
        else {sesionBoostMultiplyer += 0.2;}

        reward = SessionBoost(
          sessionBoostMultiplyer: sesionBoostMultiplyer, 
          isActive: false,
        );
        break;
      }
      case 2: {
        Map<SkillAttributeType,int> attributesBoostAmount = {};
        int boostAmount = 2 + getLevel() ~/4;
        attributesBoostAmount[SkillAttributeType.getRandom()] = boostAmount;

        reward = TemporaryAttributeBoost(
          attributesBoostAmount: attributesBoostAmount, 
        );
        break;
      }
      default: {
        double procentage = Random().nextDouble();
        double sesionBoostMultiplyer = 1;

        if(procentage <= 25){sesionBoostMultiplyer += 0.05;}
        else if (procentage <= 50) {sesionBoostMultiplyer += 0.1;}
        else if (procentage <= 90) {sesionBoostMultiplyer += 0.15;}
        else {sesionBoostMultiplyer += 0.2;}

        reward = SessionBoost(
          sessionBoostMultiplyer: sesionBoostMultiplyer, 
          isActive: false,
        );
      }

    }
    return reward;
  }


}