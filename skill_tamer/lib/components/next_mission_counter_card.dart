import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/constant/app_durations.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';

class NextMissionCounterCard extends ConsumerStatefulWidget {
  const NextMissionCounterCard({super.key});

  @override
  createState() => _NextMissionCounterCardState();
}

class _NextMissionCounterCardState
    extends ConsumerState<NextMissionCounterCard> {
  String _nextMissionRefreshTimer = "";
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(AppDurations.oneSecond, (_) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final nextMissionRefreshAt =
          ref.read(playerProvider).nextMissionRefreshAt;

      final difference = nextMissionRefreshAt - currentTime;

      if (!mounted) return;

      if (difference <= 0) {
        setState(() => _nextMissionRefreshTimer = "Refreshing...");
        return;
      }

      final hours = difference ~/ (1000 * 60 * 60);
      final minutes = (difference ~/ (1000 * 60)) % 60;
      final seconds = (difference ~/ 1000) % 60;

      setState(() {
        _nextMissionRefreshTimer = "${hours}h ${minutes}m ${seconds}s";
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0C0C0C),
        border: Border.all(
          color: scheme.primary.withAlpha(51),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, color: scheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEXT MISSION READY IN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: scheme.primary.withAlpha(128),
                    letterSpacing: 1.1,
                  ),
                ),
                Text(
                  _nextMissionRefreshTimer.toUpperCase(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: scheme.primary,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
