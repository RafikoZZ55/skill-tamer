part of '../player.dart';

extension PlayerMissionOperator on Player {
  Mission _generateMission() {
    MissionType missionType = MissionType.getRandom();
    int aditionalPoints = getLevel().clamp(0, 20);
    int remainingPoints = aditionalPoints;
    Map<SkillAttributeType, int> attributeCheck = {};

    for (SkillAttributeType attribute in SkillAttributeType.values) {
      attributeCheck[attribute] = (missionType.baseAttributes[attribute] ?? 0);
    }

    while (remainingPoints > 0) {
      SkillAttributeType attribute = SkillAttributeType.getRandom();
      attributeCheck[attribute] = ((attributeCheck[attribute] ?? 0) + 1).clamp(
        0,
        10,
      );
      remainingPoints--;
    }

    return Mission(type: missionType, attributeCheck: attributeCheck, isComplete: false);
  }

  bool isMissionExpierd() {
    return (nextMissionRefreshAt <= DateTime.now().millisecondsSinceEpoch);
  }

  Map<SkillAttributeType, int> calculateSkillAttributeBoost() {
    List<TemporaryAttributeBoost> boostRewards = rewards
        .whereType<TemporaryAttributeBoost>()
        .where((reward) => reward.isActive == true)
        .toList();
    Map<SkillAttributeType, int> boost = {};

    for (TemporaryAttributeBoost reward in boostRewards) {
      for (SkillAttributeType attribute in reward.attributesBoostAmount.keys) {
        boost[attribute] =
            ((reward.attributesBoostAmount[attribute] ?? 0) +
                    (boost[attribute] ?? 0))
                .clamp(0, 10);
      }
    }

    return boost;
  }

  Player refreshMission() {
    Mission newMission = _generateMission();
    int newNextMissionRefreshAt = DateTime.now().millisecondsSinceEpoch + AppDurations.missionRefreshDuration.inMilliseconds;
    return copyWith(
      currentMission: newMission,
      nextMissionRefreshAt: newNextMissionRefreshAt,
    );
  }

  double computeMissionProbability({required Mission mission, required SkillType a, required SkillType b}) {
    final skillA = skills.firstWhere(
      (s) => s.type == a,
      orElse: () => Skill(type: a),
    );
    final skillB = skills.firstWhere(
      (s) => s.type == b,
      orElse: () => Skill(type: b),
    );
    final boost = calculateSkillAttributeBoost();

    bool allAttributesMet = true;
    mission.attributeCheck.forEach((attr, requiredValue) {
      final val =
          (skillA.attributes[attr] ?? 0) +
          (skillB.attributes[attr] ?? 0) +
          (boost[attr] ?? 0);
      if (val < requiredValue) {
        allAttributesMet = false;
      }
    });

    if (allAttributesMet) {
      return 1.0;
    }

    double totalRatio = 0.0;
    int count = 0;

    mission.attributeCheck.forEach((attr, requiredValue) {
      final val =
          (skillA.attributes[attr] ?? 0) +
          (skillB.attributes[attr] ?? 0) +
          (boost[attr] ?? 0);
      final ratio = requiredValue == 0 ? 1.0 : (val / requiredValue);
      totalRatio += ratio.clamp(0.0, 2.0);
      count++;
    });

    final avg = (count == 0) ? 0.0 : (totalRatio / count);
    return (avg / 2).clamp(0.0, 0.95);
  }

  int calculateMissionXpReward(Mission mission) {
    int totalReq = mission.attributeCheck.values.fold(0, (sum, val) => sum + val);
    int baseXp = 500 + (totalReq * 50);
    int levelBonus = getLevel() * 10;
    return baseXp + levelBonus;
  }

  Reward generateMissionReward() {
    RewardType rewardType = RewardType.getRandom();
    late Reward newReward;
    switch (rewardType) {
      case RewardType.redistributeAttributePoints: newReward = RedistributeAttributePoints();
      break;
      case RewardType.sessionBoost: newReward = SessionBoost(sessionBoostMultiplyer: Random().nextInt(4) / 10 + 1,);
      break;
      case RewardType.temporaryAttributeBoost: newReward = TemporaryAttributeBoost(
        attributesBoostAmount: {SkillAttributeType.getRandom(): 2}
      );
      break;
      case RewardType.instantMission:
      newReward = InstantMission();
      break;
    }
    return newReward;

  }
}
