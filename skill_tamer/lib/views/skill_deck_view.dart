import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/player/player.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';


class SkillDeckView extends ConsumerStatefulWidget {
  const SkillDeckView({ super.key });

  @override
  createState() => _SkillDeckViewState();
}

class _SkillDeckViewState extends ConsumerState<SkillDeckView> {
  @override
  Widget build(BuildContext context) {
    Player player = ref.watch(playerProvider);
    
    return Container(
      child: Text("hi ${player.lastRefreshAt}, ${player.currentMission!.type.name}, ${player.nextMissionRefreshAt}"),
    );
  }
}