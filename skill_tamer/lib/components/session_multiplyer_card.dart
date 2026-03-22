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

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: totalMultiplier > 0 ? const Color(0xFF111111) : Colors.black,
        border: Border.all(
          color: totalMultiplier > 0 ? Colors.white : Colors.white.withAlpha(26),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.flash_on, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                'SESSION MULTIPLIER',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white.withAlpha(179),
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          Text(
            'X${(1.0 + totalMultiplier).toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}