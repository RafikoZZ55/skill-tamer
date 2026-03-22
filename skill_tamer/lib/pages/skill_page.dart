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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(skill.type.name.toUpperCase()),
        backgroundColor: Colors.black,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          color: scheme.primary,
        ),
        iconTheme: IconThemeData(color: scheme.primary),
        actionsPadding: const EdgeInsets.only(right: 16),
        actions: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: scheme.primary, width: 2),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Text(
              "LVL ${skill.getLevel()}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: scheme.primary,
              ),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      skill.type.description.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        color: scheme.primary.withAlpha(153),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    skill.type.icon,
                    style: const TextStyle(fontSize: 80),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    "XP PROGRESSION",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: scheme.primary, letterSpacing: 1.5),
                  ),
                  Text(
                    "${skill.getXpForNextLevel()} / ${skill.getNextLevelXp()} XP",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: scheme.primary.withAlpha(179)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.zero,
                child: LinearProgressIndicator(
                  value: skill.getXpForNextLevel() / skill.getNextLevelXp(),
                  minHeight: 8,
                  backgroundColor: scheme.primary.withAlpha(26),
                  valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                ),
              ),

              const SizedBox(height: 32),
              Text(
                "ATTRIBUTES",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 0, 255, 213), letterSpacing: 2.0),
              ),
              const SizedBox(height: 8),
              Container(height: 1, color: scheme.primary.withAlpha(51)),
              const SizedBox(height: 8),
              ...List.generate(skill.attributes.length, (index) {
                SkillAttributeType attributeType = skill.attributes.keys.toList()[index];
                int level = skill.attributes[attributeType]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${attributeType.name.toUpperCase()}: $level / 10",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: scheme.primary),
                        ),
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: (skill.unspentAttributePoints > 0 && level < 10)
                                ? () => playerController.upgradeSkill(
                                      skillIndex: widget.skillIndex,
                                      attribute: attributeType,
                                    )
                                : null,
                            icon: Icon(
                              Icons.add_box_outlined,
                              color: (skill.unspentAttributePoints > 0 && level < 10) ? scheme.primary : scheme.primary.withAlpha(51),
                              size: 24,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.zero,
                      child: LinearProgressIndicator(
                        value: level / 10,
                        backgroundColor: scheme.primary.withAlpha(13),
                        valueColor: AlwaysStoppedAnimation<Color>(scheme.primary.withAlpha(204)),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              }),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: scheme.primary.withAlpha(51)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "AVAILABLE POINTS",
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: scheme.primary.withAlpha(128), letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${skill.unspentAttributePoints}",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: scheme.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow("RECOMMENDED DURATION", "${skill.type.recommendedSessionDuration.inMinutes} MIN",scheme),
                  const SizedBox(height: 8),
                  _infoRow("XP MULTIPLIER", "X${skill.type.xpMultiplier}",scheme),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, dynamic scheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: scheme.primary.withAlpha(102),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: scheme.primary,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}
