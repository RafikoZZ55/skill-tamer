import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/reward/session_boost.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';

class SessionMultiplyerCard extends ConsumerStatefulWidget {
  const SessionMultiplyerCard({ super.key });

  @override
  createState() => _SessionMultiplyerCardState();
}

class _SessionMultiplyerCardState extends ConsumerState<SessionMultiplyerCard> {
  @override
  Widget build(BuildContext context) {
    final player = ref.read(playerProvider);
    final sessionBoosts = player.rewards.whereType<SessionBoost>().where((r) => r.isActive).toList();
    double totalMultiplier = sessionBoosts.fold(0.0, (sum, boost) => sum + boost.sessionBoostMultiplyer);
    ColorScheme scheme = Theme.of(context).colorScheme;

    return Card(
      color: totalMultiplier > 0
          ? scheme.secondaryContainer
          : scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '📢 Session Multiplier:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'x${(1.0 + totalMultiplier).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: scheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}