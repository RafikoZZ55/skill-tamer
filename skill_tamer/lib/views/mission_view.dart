import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/mission/mission.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';

class MissionView extends ConsumerStatefulWidget {
  const MissionView({super.key});

  @override
  createState() => _MissionViewState();
}

class _MissionViewState extends ConsumerState<MissionView> {
  late Timer _timer;
  late String _nextMissionRefreshTimer = "";

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final nextMissionRefreshAt =
          ref.read(playerProvider).nextMissionRefreshAt;

      final difference = nextMissionRefreshAt - currentTime;

      if (difference <= 0) {
        setState(() {
          _nextMissionRefreshTimer = "Refreshing...";
        });
        return;
      }

      final hours = difference ~/ (1000 * 60 * 60);
      final minutes = (difference ~/ (1000 * 60)) % 60;
      final seconds = (difference ~/ 1000) % 60;

      setState(() {
        _nextMissionRefreshTimer =
            "${hours}h ${minutes}m ${seconds}s";
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
  
  @override
  Widget build(BuildContext context) {

    Mission? mission = ref.watch(playerProvider.select((p) => p.currentMission));

    return Column(
      children: [
        Text(_nextMissionRefreshTimer),
        
      ],
    );
  }
}