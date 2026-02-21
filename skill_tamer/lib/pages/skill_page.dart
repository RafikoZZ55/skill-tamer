import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/enum/skill_attribute_type.dart';
import 'package:skill_tamer/data/model/skill/skill.dart';
import 'package:skill_tamer/data/riverpod/player/player_controller.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';

class SkillPage extends ConsumerStatefulWidget {
  const SkillPage({ super.key, required this.skillIndex });
  final int skillIndex;

  @override
  createState() => _SkillPageState();
}

class _SkillPageState extends ConsumerState<SkillPage> {
  @override
  Widget build(BuildContext context) {  
    final ColorScheme scheme = Theme.of(context).colorScheme;
    Skill skill = ref.watch(playerProvider.select((p) => p.skills[widget.skillIndex]));
    PlayerController playerController = ref.read(playerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(skill.type.name),
        backgroundColor: scheme.onPrimary,
        titleTextStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        actionsPadding: EdgeInsets.all(8),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text("lvl ${skill.getLevel()}",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: scheme.onPrimary,
              ),
              ),
            ),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(child: Text(skill.type.description, style: TextStyle(fontSize: 12.5, fontStyle: FontStyle.italic))),
                Text(skill.type.icon, style: TextStyle(fontSize: 100)),
              ],
            ),

            Divider(),
            LinearProgressIndicator(
              value: skill.getXpForNextLevel() / skill.getNextLevelXp(),
            ),
            Text("${skill.getXpForNextLevel()} / ${skill.getNextLevelXp()}xp"),

            Divider(),
            ...List.generate(skill.attributes.length, (index) {
              SkillAttributeType attributeType = skill.attributes.keys.toList()[index];
              int level = skill.attributes[attributeType]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${attributeType.name}: $level/10"),
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 16,
                          style: IconButton.styleFrom(
                            backgroundColor: scheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          onPressed: (skill.unspentAttributePoints > 0 && level < 10)
                              ? () => playerController.upgradeSkill(
                                    skillIndex: widget.skillIndex,
                                    attribute: attributeType,
                                  )
                              : null,
                          icon: Icon(Icons.add, color: scheme.onPrimary),
                        ),
                      )
                    ],
                    ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: level / 10,
                  ),
                  const SizedBox(height: 10),
                ],
              ); 
            }),
            Text("points: ${skill.unspentAttributePoints}",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            ),
            Divider(),
            Text("session duration: ${skill.type.recommendedSessionDuration.inMinutes} minutes",
              style: TextStyle(
                color: scheme.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text("session xp multiplyer: ${skill.type.xpMultiplier}",
              style: TextStyle(
                color: scheme.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}