import 'package:skill_tamer/data/model/skill/skill.dart';

class Player {
  List<Skill> skills;


  Player({
    required this.skills,
  });


  Player copyWith({
    List<Skill>? skills
  }) {
    return Player(
      skills: skills ?? List.from(this.skills),
    );
  }
}