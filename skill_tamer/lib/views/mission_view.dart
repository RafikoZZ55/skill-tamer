import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/mission/mission.dart';
import 'package:skill_tamer/data/model/enum/skill_type.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';
import 'package:skill_tamer/data/model/reward/temporary_attribute_boost.dart';

class MissionView extends ConsumerStatefulWidget {
  const MissionView({super.key});

  @override
  createState() => _MissionViewState();
}

class _MissionViewState extends ConsumerState<MissionView> {
  late Timer _timer;
  late String _nextMissionRefreshTimer = "";
  SkillType? _selectedA;
  SkillType? _selectedB;
  bool _activating = false;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final nextMissionRefreshAt = ref
          .read(playerProvider)
          .nextMissionRefreshAt;

      final difference = nextMissionRefreshAt - currentTime;

      if (difference <= 0) {
        setState(() {
          _nextMissionRefreshTimer = "Refreshing...";
        });
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
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final Mission? mission = ref.watch(
      playerProvider.select((p) => p.currentMission),
    );
    final controller = ref.read(playerProvider.notifier);

    return mission != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_nextMissionRefreshTimer),
              const SizedBox(height: 12),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mission.type.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(mission.type.description),
                      const SizedBox(height: 8),
                      const Text(
                        'Requirements:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: mission.attributeCheck.entries.map((e) {
                          return Chip(label: Text('${e.key.name}: ${e.value}'));
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildSelectionSlot(context, 'Slot A', _selectedA, (
                      SkillType? value,
                    ) {
                      setState(() {
                        _selectedA = value;
                      });
                    }),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildSelectionSlot(context, 'Slot B', _selectedB, (
                      SkillType? value,
                    ) {
                      setState(() {
                        _selectedB = value;
                      });
                    }),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      (_selectedA == null || _selectedB == null || _activating)
                      ? null
                      : () async {
                          setState(() {
                            _activating = true;
                          });

                          final outcome = controller.attemptMission(
                            a: _selectedA!,
                            b: _selectedB!,
                          );

                          setState(() {
                            _activating = false;
                            _selectedA = null;
                            _selectedB = null;
                          });

                          showDialog<void>(
                            context: context,
                            builder: (_) {
                              String message;
                              if (outcome.success) {
                                if (outcome.reward != null) {
                                  if (outcome.reward
                                      is TemporaryAttributeBoost) {
                                    final boost =
                                        outcome.reward
                                            as TemporaryAttributeBoost;
                                    final attrs = boost
                                        .attributesBoostAmount
                                        .entries
                                        .map((e) => '${e.key.name} +${e.value}')
                                        .join(', ');
                                    message =
                                        'You succeeded and received a temporary boost: $attrs';
                                  } else {
                                    message =
                                        'You succeeded and received a reward.';
                                  }
                                } else {
                                  message = 'You succeeded.';
                                }
                              } else {
                                message = 'You failed the mission.';
                              }
                              return AlertDialog(
                                title: Text(
                                  outcome.success
                                      ? 'Mission Completed'
                                      : 'Mission Failed',
                                ),
                                content: Text(message),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                  child: _activating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Activate Mission'),
                ),
              ),

              const SizedBox(height: 12),
            ],
          )
        : const SizedBox();
  }

  Widget _buildSelectionSlot(
    BuildContext context,
    String title,
    SkillType? selected,
    ValueChanged<SkillType?> onSelected,
  ) {
    return OutlinedButton(
      onPressed: () async {
        final selectedSkill = await showModalBottomSheet<SkillType>(
          context: context,
          isScrollControlled: true,
          builder: (_) => _SkillSelectionSheet(),
        );

        if (selectedSkill != null) onSelected(selectedSkill);
      },
      child: selected == null
          ? Text(title)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(selected.icon, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Text(selected.name),
              ],
            ),
    );
  }
}

class _SkillSelectionSheet extends StatelessWidget {
  const _SkillSelectionSheet();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Skill",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 5),
          Expanded(
            child: GridView.builder(
              itemCount: SkillType.values.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 4.5,
              ),
              itemBuilder: (context, index) {
                final skill = SkillType.values[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Navigator.pop(context, skill),
                  child: Container(
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          skill.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Text(skill.icon, style: const TextStyle(fontSize: 36)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
