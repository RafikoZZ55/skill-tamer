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
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 5,
                children: [
                  Text(
                    skill.type.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.fade
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Lvl ${skill.getLevel()}",
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text(
                skill.type.icon,
                style: const TextStyle(fontSize: 56),
              ),

              const SizedBox(height: 16),

              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  minHeight: 10,
                  value: progress.clamp(0, 1),
                ),
              ),

              const SizedBox(height: 6),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${skill.getXpForNextLevel()} / ${skill.getNextLevelXp()} XP",
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}