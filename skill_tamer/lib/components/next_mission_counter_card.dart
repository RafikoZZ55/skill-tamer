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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          const Text(
            '⏱️',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Mission Ready In',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                Text(
                  _nextMissionRefreshTimer,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.secondary,
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
