import 'dart:math';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';

enum MissionType {
  emergencySystemFailure(
    name: "Emergency System Failure",
    description: "A critical system has crashed before a major launch.",
    baseAttributes: {
      SkillAttributeType.cognitive: 4,
      SkillAttributeType.creative: 0,
      SkillAttributeType.physical: 0,
      SkillAttributeType.social: 0,
      SkillAttributeType.technical: 6,
    },
  ),

  viralCampaign(
    name: "Viral Campaign",
    description: "Design a campaign that captures everyone's attention.",
    baseAttributes: {
      SkillAttributeType.cognitive: 2,
      SkillAttributeType.creative: 6,
      SkillAttributeType.physical: 0,
      SkillAttributeType.social: 4,
      SkillAttributeType.technical: 0,
    },
  ),

  frontierExpedition(
    name: "Frontier Expedition",
    description: "Explore and secure an uncharted territory.",
    baseAttributes: {
      SkillAttributeType.cognitive: 4,
      SkillAttributeType.creative: 0,
      SkillAttributeType.physical: 6,
      SkillAttributeType.social: 0,
      SkillAttributeType.technical: 0,
    },
  ),

  highStakesNegotiation(
    name: "High Stakes Negotiation",
    description: "Broker a deal between two powerful factions.",
    baseAttributes: {
      SkillAttributeType.cognitive: 4,
      SkillAttributeType.creative: 0,
      SkillAttributeType.physical: 0,
      SkillAttributeType.social: 6,
      SkillAttributeType.technical: 0,
    },
  ),

  prototypeInnovation(
    name: "Prototype Innovation",
    description: "Build a groundbreaking prototype under pressure.",
    baseAttributes: {
      SkillAttributeType.cognitive: 2,
      SkillAttributeType.creative: 4,
      SkillAttributeType.physical: 0,
      SkillAttributeType.social: 0,
      SkillAttributeType.technical: 4,
    },
  ),

  rebuildOutpost(
    name: "Rebuild Outpost",
    description: "Reconstruct a damaged settlement before supplies run out.",
    baseAttributes: {
      SkillAttributeType.cognitive: 0,
      SkillAttributeType.creative: 0,
      SkillAttributeType.physical: 4,
      SkillAttributeType.social: 2,
      SkillAttributeType.technical: 4,
    },
  ),

  decodeAncientArchive(
    name: "Decode Ancient Archive",
    description: "Unravel the secrets hidden within ancient records.",
    baseAttributes: {
      SkillAttributeType.cognitive: 6,
      SkillAttributeType.creative: 0,
      SkillAttributeType.physical: 0,
      SkillAttributeType.social: 0,
      SkillAttributeType.technical: 2,
    },
  ),

  publicShowcase(
    name: "Public Showcase",
    description: "Present your work to a demanding live audience.",
    baseAttributes: {
      SkillAttributeType.cognitive: 0,
      SkillAttributeType.creative: 4,
      SkillAttributeType.physical: 0,
      SkillAttributeType.social: 4,
      SkillAttributeType.technical: 0,
    },
  );

  final String name;
  final String description;
  final Map<SkillAttributeType, int> baseAttributes;

  const MissionType({
    required this.name,
    required this.description,
    required this.baseAttributes,
  });

  static MissionType get({required String missionName}) {
    return MissionType.values.firstWhere((e) => e.name == missionName);
  }

  static MissionType getRandom() {
    return MissionType.values[Random().nextInt(MissionType.values.length)];
  }
}
