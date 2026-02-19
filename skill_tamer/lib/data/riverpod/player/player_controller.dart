
import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/player/player.dart';


class PlayerController extends StateNotifier<Player> {
  PlayerController(): super(Player.empty());

  Timer? _timer;


  Future<void> init() async{
    _timer = Timer( Duration(seconds: 1), () => _onTick());
  }


  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }



  void _save(){

  }


  void _onTick(){
    if(state.isMissionExpierd()) state = state.refreshMission();
  }

  void upgradeSkill({required int skillIndex, required SkillAttributeType attribute}){
    state = state.upgradeSkill(skillIndex: skillIndex, attribute: attribute);
  }
}