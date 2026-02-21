import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';

enum SkillType {
  programming(
    name: "Programming",
    description: "Forge logic into living systems and bend machines to your will. Programming is the craft of transforming abstract thought into structured code that powers applications, games, tools, and entire digital worlds. It sharpens analytical thinking, patience, and problem-solving while rewarding creativity hidden beneath strict logic.",
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
    description: "Channel imagination into color and form. Painting allows you to translate emotion, memory, and vision onto a tangible surface. It cultivates perception, creative instinct, and aesthetic awareness while training the hand to obey the mind’s artistic impulse.",
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
    description: "Shape ideas into stories, arguments, and worlds through the power of language. Writing strengthens clarity of thought, narrative structure, and expressive depth. It is both a technical discipline and a creative art that turns imagination into influence.",
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
    description: "Absorb knowledge, explore distant realities, and refine critical thinking through focused reading. This skill expands vocabulary, comprehension, and analytical ability while exposing you to new perspectives, philosophies, and systems of thought.",
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
    description: "Synchronize body and rhythm to transform movement into expression. Dancing enhances coordination, balance, and stamina while strengthening social presence and emotional confidence. It is physical storytelling driven by music and discipline.",
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
    description: "Combine engineering, mechanics, and programming to bring machines to life. Robotics demands structured thinking, technical precision, and iterative experimentation. It merges abstract logic with tangible construction, creating systems that interact with the physical world.",
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
    description: "Transform raw material into functional craftsmanship. Woodworking develops spatial reasoning, patience, and practical technique while strengthening precision and hands-on problem solving. It balances artistic creativity with structural engineering.",
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
    description: "Master focus, control, and precision through disciplined practice. Archery refines concentration, posture, and steady execution. Each shot demands mental clarity and physical alignment, making it a practice of both body and mind.",
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
