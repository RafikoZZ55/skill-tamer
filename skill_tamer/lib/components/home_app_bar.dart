import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/player/player.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final Player player = ref.watch(playerProvider);

    final currentXP = player.xpGainedForNextLevel();
    final remainingXP = player.xpToNextLevel();
    final totalXPForLevel = currentXP + remainingXP;

    final progress = totalXPForLevel == 0 ? 0.0 : currentXP / totalXPForLevel;

    return AppBar(
      title: const Text("SKILL TAMER"),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: scheme.primary.withAlpha(26),
                color: scheme.primary,
                minHeight: 4,
                borderRadius: BorderRadius.zero,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "XP PROGRESS",
                    style: TextStyle(
                      fontSize: 10,
                      color: scheme.primary.withAlpha(128),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Text(
                    "$currentXP / $totalXPForLevel",
                    style: TextStyle(
                      fontSize: 10,
                      color: scheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      actionsPadding:
          const EdgeInsetsDirectional.symmetric(horizontal: 16),
      actions: [
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: scheme.primary.withAlpha(51)),
            ),
            child: Text(
              "LVL ${player.getLevel()}",
              style: TextStyle(
                fontSize: 16,
                color: scheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
        )
      ],
      backgroundColor: Colors.black,
      elevation: 0,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + 20);
}