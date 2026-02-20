
import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:skill_tamer/data/hive/player_state.dart';
import 'package:skill_tamer/data/mapper/player_mapper.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/player/player.dart';


class PlayerController extends StateNotifier<Player> {
  PlayerController(): super(Player.empty());

  Timer? _timer;
  final PlayerMapper _playerMapper = PlayerMapper();
  late final Box<PlayerState> _playerBox;


  Future<void> init() async{
    _playerBox = Hive.box<PlayerState>("player");
    _loadFromHive();
    _startTimer();
  }

  void _startTimer(){
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _loadFromHive() {
    Player player;

    if(_playerBox.isEmpty || _playerBox.getAt(0) == null) {
      Player newPlayer = Player.empty();
      newPlayer = newPlayer.refreshMission();
      newPlayer = newPlayer.refreshSkills();
      player = newPlayer.copyWith();
    }
    else {
      PlayerState? playerState = _playerBox.getAt(0);
      player = _playerMapper.fromState(playerState: playerState!);
    }

    state = player.copyWith();
  }


  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _save();
  }



  void _save(){
    PlayerState playerState = _playerMapper.toState(player: state);
    if(_playerBox.isEmpty) {_playerBox.add(playerState);}
    else {_playerBox.putAt(0, playerState);}
  }

  void _setState({required Player player}){
    state = player.copyWith();
    _save();
  }


  void _onTick(){
    if(state.isMissionExpierd()) _setState(player: state.refreshMission());
    if(state.areSkillsEmpty()) _setState(player: state.refreshSkills());

    _setState(player: state.copyWith(lastRefreshAt: DateTime.now().millisecondsSinceEpoch));
  }

  void upgradeSkill({required int skillIndex, required SkillAttributeType attribute}){
    _setState(player: state.upgradeSkill(skillIndex: skillIndex, attribute: attribute));
  }
  
}