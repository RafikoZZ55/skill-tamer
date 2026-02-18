import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';

enum SkillType {
  programming(
    name: "Programming",
    description: "Design and build software systems.",
    icon: "🖥️",
    recommendedSessionDuration: Duration(hours: 2),
    xpMultiplier: 0.15,
    baseAttributes: {
      SkillAttributeType.cognitive: 4,
      SkillAttributeType.creative: 2,
      SkillAttributeType.physical: 0,
      SkillAttributeType.social: 0,
      SkillAttributeType.technical: 6,
    },
  ),

  painting(
    name: "Painting",
    description: "Express ideas visually through art.",
    icon: "🖌️",
    recommendedSessionDuration: Duration(hours: 1, minutes: 30),
    xpMultiplier: 0.10,
    baseAttributes: {
      SkillAttributeType.cognitive: 2,
      SkillAttributeType.creative: 6,
      SkillAttributeType.physical: 1,
      SkillAttributeType.social: 1,
      SkillAttributeType.technical: 2,
    },
  ),

  writing(
    name: "Writing",
    description: "Communicate thoughts through structured text.",
    icon: "✒️",
    recommendedSessionDuration: Duration(hours: 1),
    xpMultiplier: 0.12,
    baseAttributes: {
      SkillAttributeType.cognitive: 4,
      SkillAttributeType.creative: 5,
      SkillAttributeType.physical: 0,
      SkillAttributeType.social: 2,
      SkillAttributeType.technical: 1,
    },
  ),

  reading(
    name: "Reading",
    description: "Absorb and analyze written knowledge.",
    icon: "📖",
    recommendedSessionDuration: Duration(hours: 1, minutes: 30),
    xpMultiplier: 0.08,
    baseAttributes: {
      SkillAttributeType.cognitive: 6,
      SkillAttributeType.creative: 2,
      SkillAttributeType.physical: 0,
      SkillAttributeType.social: 1,
      SkillAttributeType.technical: 3,
    },
  ),

  dancing(
    name: "Dancing",
    description: "Express rhythm through coordinated movement.",
    icon: "💃🏼",
    recommendedSessionDuration: Duration(minutes: 45),
    xpMultiplier: 0.14,
    baseAttributes: {
      SkillAttributeType.cognitive: 1,
      SkillAttributeType.creative: 2,
      SkillAttributeType.physical: 7,
      SkillAttributeType.social: 2,
      SkillAttributeType.technical: 0,
    },
  ),

  robotics(
    name: "Robotics",
    description: "Build and program mechanical systems.",
    icon: "🤖",
    recommendedSessionDuration: Duration(hours: 2),
    xpMultiplier: 0.18,
    baseAttributes: {
      SkillAttributeType.cognitive: 3,
      SkillAttributeType.creative: 2,
      SkillAttributeType.physical: 1,
      SkillAttributeType.social: 0,
      SkillAttributeType.technical: 6,
    },
  ),

  woodworking(
    name: "Woodworking",
    description: "Craft functional or artistic wooden structures.",
    icon: "🪓",
    recommendedSessionDuration: Duration(hours: 2, minutes: 30),
    xpMultiplier: 0.13,
    baseAttributes: {
      SkillAttributeType.cognitive: 2,
      SkillAttributeType.creative: 3,
      SkillAttributeType.physical: 5,
      SkillAttributeType.social: 0,
      SkillAttributeType.technical: 2,
    },
  ),

  archery(
    name: "Archery",
    description: "Develop precision and physical control.",
    icon: "🏹",
    recommendedSessionDuration: Duration(hours: 1),
    xpMultiplier: 0.16,
    baseAttributes: {
      SkillAttributeType.cognitive: 3,
      SkillAttributeType.creative: 0,
      SkillAttributeType.physical: 7,
      SkillAttributeType.social: 1,
      SkillAttributeType.technical: 1,
    },
  );

  final String name;
  final String icon;
  final String description;
  final Map<SkillAttributeType, int> baseAttributes;
  final Duration recommendedSessionDuration;
  final double xpMultiplier;

  const SkillType({
    required this.name,
    required this.icon,
    required this.description,
    required this.baseAttributes,
    required this.recommendedSessionDuration,
    required this.xpMultiplier,
  });

  static SkillType get({required String skillName}) {
    return SkillType.values.singleWhere((e) => e.name == skillName);
  }
}
