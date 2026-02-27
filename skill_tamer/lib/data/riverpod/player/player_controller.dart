import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:skill_tamer/data/hive/player_state.dart';
import 'package:skill_tamer/data/mapper/player_mapper.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/enum/skill_type.dart';
import 'dart:math';
import 'package:skill_tamer/data/model/reward/reward.dart';
import 'package:skill_tamer/data/model/player/player.dart';

class MissionOutcome {
  final bool success;
  final Reward? reward;
  MissionOutcome(this.success, {this.reward});
}

class PlayerController extends StateNotifier<Player> {
  PlayerController() : super(Player.empty());

  Timer? _timer;
  final PlayerMapper _playerMapper = PlayerMapper();
  late final Box<PlayerState> _playerBox;

  Future<void> init() async {
    _playerBox = Hive.box<PlayerState>("player");
    _loadFromHive();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  void _loadFromHive() {
    Player player;

    if (_playerBox.isEmpty || _playerBox.getAt(0) == null) {
      Player newPlayer = Player.empty();
      newPlayer = newPlayer.refreshMission();
      newPlayer = newPlayer.refreshSkills();
      player = newPlayer.copyWith();
    } else {
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

  void _save() {
    PlayerState playerState = _playerMapper.toState(player: state);
    if (_playerBox.isEmpty) {
      _playerBox.add(playerState);
    } else {
      _playerBox.putAt(0, playerState);
    }
  }

  void _setState({required Player player}) {
    state = player.copyWith();
    _save();
  }

  void _onTick() {
    if (state.isMissionExpierd()) _setState(player: state.refreshMission());
    if (state.areSkillsEmpty()) _setState(player: state.refreshSkills());

    _setState(
      player: state.copyWith(
        lastRefreshAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  void upgradeSkill({
    required int skillIndex,
    required SkillAttributeType attribute,
  }) {
    _setState(
      player: state.upgradeSkill(skillIndex: skillIndex, attribute: attribute),
    );
    _save();
  }

  void createNewSession({required SkillType skillType}) {
    _setState(player: state.createNewSession(skillType: skillType));
    _save();
  }

  void stopSession({bool manual = false}) {
    _setState(player: state.stopSession(manual: manual));
    _save();
  }

  void updateSessionCheck() {
    _setState(player: state.updateSessionCheck());
    _save();
  }

  void addReward({required Reward reward}) {
    Player newPlayer = state.copyWith();
    List<Reward> newRewards = List.from(newPlayer.rewards);
    newRewards.add(reward);
    _setState(player: newPlayer.copyWith(rewards: newRewards));
    _save();
  }

  void useReward({required int rewardIndex, int? skillIndex}) {
    _setState(player: state.useReward(rewardIndex: rewardIndex, skillIndex: skillIndex));
    _save();
  }

  void completeMissionResult({required bool success, Reward? reward}) {
    Player newPlayer = state.copyWith();

    if (reward != null) {
      List<Reward> newRewards = List.from(newPlayer.rewards);
      newRewards.add(reward);
      newPlayer = newPlayer.copyWith(rewards: newRewards);
    }

    // Award XP for successful mission
    int xpReward = 0;
    if (success && newPlayer.currentMission != null) {
      xpReward = newPlayer.calculateMissionXpReward(newPlayer.currentMission!);
      newPlayer = newPlayer.copyWith(xpGained: newPlayer.xpGained + xpReward);
    }

    // Lock mission until timer expires (next refresh in 1 hour)
    final nextRefresh =
        DateTime.now().millisecondsSinceEpoch +
        Duration(hours: 1).inMilliseconds;
    newPlayer = newPlayer.copyWith(
      currentMission: null,
      nextMissionRefreshAt: nextRefresh,
    );

    _setState(player: newPlayer);
    _save();
  }

  MissionOutcome attemptMission({required SkillType a, required SkillType b}) {
    final mission = state.currentMission;
    if (mission == null) {
      return MissionOutcome(false);
    }

    final prob = state.computeMissionProbability(mission, a, b);
    final success = Random().nextDouble() < prob;
    Reward? reward;
    if (success) {
      reward = state.generateMissionReward(mission);
    }

    completeMissionResult(success: success, reward: reward);
    return MissionOutcome(success, reward: reward);
  }
}
