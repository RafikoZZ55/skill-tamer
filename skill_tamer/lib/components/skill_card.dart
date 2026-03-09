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
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.surfaceContainerHigh,
              scheme.surface,
            ],
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SkillPage(skillIndex: skillIndex),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Expanded(
                      child: Text(
                        skill.type.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: scheme.primary.withAlpha(60),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "Lvl ${skill.getLevel()}",
                        style: TextStyle(
                          color: scheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                    skill.type.icon,
                    style: const TextStyle(fontSize: 48),
                  ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Experience',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          "${skill.getXpForNextLevel()} / ${skill.getNextLevelXp()}",
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: progress.clamp(0, 1),
                        backgroundColor: scheme.surfaceContainerHighest,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(scheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
