import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/player/player.dart';
import 'package:skill_tamer/data/riverpod/player/player_controller.dart';

final playerProvider = StateNotifierProvider<PlayerController,Player>((ref) { 
  final PlayerController controler = PlayerController();
  controler.init();

  return controler;
});