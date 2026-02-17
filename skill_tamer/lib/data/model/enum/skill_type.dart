import 'package:skill_tamer/data/model/enum/skill_attribute.dart';

enum SkillType {
  programing(
    name: "Programing",
    description: "",
    icon: "🖥️",
    recommendedSessionDuration: Duration(hours: 2),
    xpMultiplyer: 1.1,
    baseAttributes: {
      SkillAttribute.cognitive: 1,
      SkillAttribute.creative: 4,
      SkillAttribute.physical: 0,
      SkillAttribute.social: 0,
      SkillAttribute.technical: 5,
    }
  ),
  
  painting(
    name: "Painting",
    description: "",
    icon: "🖌️",
    recommendedSessionDuration: Duration(hours: 1, minutes: 30),
    xpMultiplyer: 1.09,
    baseAttributes: {
      SkillAttribute.cognitive: 3,
      SkillAttribute.creative: 6,
      SkillAttribute.physical: 0,
      SkillAttribute.social: 1,
      SkillAttribute.technical: 0,
    }
  ),

  writing(
    name: "Writing",
    description: "",
    icon: "✒️",
    recommendedSessionDuration: Duration(hours: 1),
    xpMultiplyer: 1.15,
    baseAttributes: {
      SkillAttribute.cognitive: 1,
      SkillAttribute.creative: 7,
      SkillAttribute.physical: 0,
      SkillAttribute.social: 2,
      SkillAttribute.technical: 0,
    }
  ),

  reading(
    name: "Reading",
    description: "",
    icon: "📖",
    recommendedSessionDuration: Duration(hours: 1, minutes: 45),
    xpMultiplyer: 1.2,
    baseAttributes: {
      SkillAttribute.cognitive: 5,
      SkillAttribute.creative: 5,
      SkillAttribute.physical: 0,
      SkillAttribute.social: 0,
      SkillAttribute.technical: 0
    }
  ),

  dancing(
    name: "Dancing",
    description: "",
    icon: "💃🏼",
    recommendedSessionDuration: Duration(minutes: 45),
    xpMultiplyer: 1.15,
    baseAttributes: {
      SkillAttribute.cognitive: 1,
      SkillAttribute.creative: 1,
      SkillAttribute.physical: 6,
      SkillAttribute.social: 2,
      SkillAttribute.technical:0,
    }
  ),

  robotics(
    name: "Robotics",
    description: "",
    icon: "🤖",
    recommendedSessionDuration: Duration(hours: 2),
    xpMultiplyer: 1.2,
    baseAttributes: {
      SkillAttribute.cognitive: 1,
      SkillAttribute.creative: 2,
      SkillAttribute.physical: 1,
      SkillAttribute.social: 0,
      SkillAttribute.technical: 6,
    }
  ),

  woodworking(
    name: "Robotics",
    description: "",
    icon: "🪓",
    recommendedSessionDuration: Duration(hours: 2, minutes: 30),
    xpMultiplyer: 1.1,
    baseAttributes: {
      SkillAttribute.cognitive: 2,
      SkillAttribute.creative: 3,
      SkillAttribute.physical: 4,
      SkillAttribute.social: 0,
      SkillAttribute.technical: 1,
    }
  ),
  archery(
    name: "Archery",
    description: "",
    icon: "🏹",
    recommendedSessionDuration: Duration(hours: 1),
    xpMultiplyer: 1.25,
    baseAttributes: {
      SkillAttribute.cognitive: 3,
      SkillAttribute.creative: 0,
      SkillAttribute.physical: 6,
      SkillAttribute.social: 1,
      SkillAttribute.technical: 0,
    }
  );

  final String name;
  final String icon;
  final String description;
  final Map<SkillAttribute,int> baseAttributes;
  final Duration recommendedSessionDuration;
  final double xpMultiplyer;

  const SkillType({
    required this.name,
    required this.icon,
    required this.description,
    required this.baseAttributes,
    required this.recommendedSessionDuration,
    required this.xpMultiplyer,
  });

}