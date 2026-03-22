import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';
import 'package:skill_tamer/pages/skill_page.dart';
class SkillCard extends ConsumerWidget {
  const SkillCard({
    super.key,
    required this.skillIndex,
  });

  final int skillIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;

    final skill = ref.watch(
      playerProvider.select((p) => p.skills[skillIndex]),
    );

    final progress =
        skill.getXpForNextLevel() / skill.getNextLevelXp();

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SkillPage(skillIndex: skillIndex),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      skill.type.name.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            letterSpacing: 1.2,
                            color: scheme.primary,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: scheme.primary.withAlpha(77)),
                    ),
                    child: Text(
                      "LVL ${skill.getLevel()}",
                      style: TextStyle(
                        color: scheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                skill.type.icon,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'XP PROGRESS',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: scheme.primary.withAlpha(128),
                              letterSpacing: 1.0,
                            ),
                      ),
                      Text(
                        "${skill.getXpForNextLevel()} / ${skill.getNextLevelXp()}",
                        style: TextStyle(
                          fontSize: 10,
                          color: scheme.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    minHeight: 4,
                    value: progress.clamp(0, 1),
                    backgroundColor: scheme.primary.withAlpha(26),
                    color: scheme.primary,
                    borderRadius: BorderRadius.zero,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
