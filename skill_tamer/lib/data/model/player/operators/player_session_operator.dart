part of '../player.dart';

extension PlayerSessionOperator on Player {
  
  Player _generateSession({required SkillType skillType}){
    Session newSession = Session(
      timeStarted: DateTime.now().millisecondsSinceEpoch, 
      sessionSkill: skillType
      );
    
    return copyWith(activeSession: newSession, activeSessionSet: true);
  }

  double _getActiveSessionBoostMultiplyer(){
    List<SessionBoost> activeBoosts = rewards.whereType<SessionBoost>().where((e) => e.isActive == true).toList();
    double totalBoost = 0;

    for(SessionBoost sessionBoost in activeBoosts){
      totalBoost += sessionBoost.sessionBoostMultiplyer;
    }

    return totalBoost;
  }


  int _calculatePartialReward({required Session session}){
    int baseXp = (DateTime.now().millisecondsSinceEpoch - session.timeStarted) ~/ 1000;
    double multiplyer = session.sessionSkill.xpMultiplier + _getActiveSessionBoostMultiplyer();
    return (baseXp + baseXp * multiplyer).toInt();
  }

  int _calculateFullRewards({required Session session}){
    int baseXp = (DateTime.now().millisecondsSinceEpoch - session.timeStarted) ~/ 1000;
    double multiplyer = session.sessionSkill.xpMultiplier + _getActiveSessionBoostMultiplyer() + 0.25;
    return (baseXp + baseXp * multiplyer).toInt();
  }

  int _calculateBeggerRewards({required Session session}){
    int baseXp = (DateTime.now().millisecondsSinceEpoch - session.timeStarted) ~/ 1000;
    double multiplyer = (session.sessionSkill.xpMultiplier + _getActiveSessionBoostMultiplyer()) / 5;
    return (baseXp + baseXp * multiplyer).toInt();
  }

  Player stopSession({bool manual = false}){
    if(activeSession == null) return copyWith();
    Session? session = activeSession;
    int reward;

    if(session!.isFinished()) {reward = _calculateFullRewards(session: session);}
    else if (!manual && session.isAbandoned()) {reward = _calculateBeggerRewards(session: session);}
    else {reward = _calculatePartialReward(session: session);}

    Skill selectedSkill = skills.singleWhere((s) => s.type == session.sessionSkill).copyWith();
    selectedSkill.xpGained += reward;
    List<Skill> newSkills = List.from(skills);
    newSkills.removeWhere((s) => s.type == session.sessionSkill);
    newSkills.add(selectedSkill);

    return copyWith(skills: newSkills, activeSession: null, activeSessionSet: true);
  }


  Player createNewSession({required  SkillType skillType}){
    Player updatedPlayer = this;

    if(activeSession != null) {updatedPlayer = updatedPlayer.stopSession();} 
    updatedPlayer = _generateSession(skillType: skillType);
    
    return updatedPlayer;
  }

  Player updateSessionCheck() {
    if (activeSession == null) return copyWith();
    final updated = activeSession!.copyWith(
        lastSessionCheck: DateTime.now().millisecondsSinceEpoch);
    return copyWith(activeSession: updated, activeSessionSet: true);
  }

}