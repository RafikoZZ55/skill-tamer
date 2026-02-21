part of '../player.dart';

extension PlayerSkillOperator on Player {
  
  Player upgradeSkill({required int skillIndex, required SkillAttributeType attribute}){
    Player newPlayer = copyWith();
    List<Skill> newSkills = List.from(newPlayer.skills);
    Skill newSkill = newSkills[skillIndex];
    Map<SkillAttributeType,int> newAttributes = Map.from(newSkill.attributes);


    if((newSkill.unspentAttributePoints > 0)  || (newSkill.attributes[attribute]! < 10)) return newPlayer;

    newAttributes[attribute] = ((newAttributes[attribute] ?? 0) + 1).clamp(0, 10);

    newSkill = newSkill.copyWith(
      unspentAttributePoints: newSkill.unspentAttributePoints - 1,
      attributes: newAttributes,
    );

    newSkills[skillIndex] = newSkill.copyWith();

    return newPlayer.copyWith(
      skills: newSkills,
    );
  }
  

  bool areSkillsEmpty(){
    return skills.isEmpty;
  }


  Player refreshSkills(){
    Player newPlayer = copyWith();
    List<Skill> newSkills = [];

    for(SkillType skillType in SkillType.values){
      newSkills.add(Skill(type: skillType));
    }
    
    return newPlayer.copyWith(skills: newSkills);
  }

  
}