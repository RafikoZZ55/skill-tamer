import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/reward/reward.dart';
import 'package:skill_tamer/data/model/reward/temporary_attribute_boost.dart';
import 'package:skill_tamer/data/model/reward/session_boost.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';

class RewardCard extends ConsumerStatefulWidget {
  const RewardCard({super.key, required this.rewardIndex});
  final int rewardIndex;

  @override
  ConsumerState<RewardCard> createState() => _RewardCardState();
}

class _RewardCardState extends ConsumerState<RewardCard> {
  @override
  Widget build(BuildContext context) {
    final Reward reward = ref.watch(
      playerProvider.select((p) => p.rewards[widget.rewardIndex]),
    );
    final controller = ref.read(playerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: reward.isActive ? scheme.primaryContainer : scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: reward.isActive ? scheme.primary : scheme.outlineVariant,
          width: reward.isActive ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: reward.isActive
              ? null
              : () async {
                  // Check if reward needs skill selection
                  int? selectedSkillIndex;
                  if (_shouldShowSkillPicker(reward)) {
                    selectedSkillIndex = await _showSkillPickerDialog(
                      context,
                      ref,
                    );
                    if (selectedSkillIndex == null) return;
                  }

                  controller.useReward(
                    rewardIndex: widget.rewardIndex,
                    skillIndex: selectedSkillIndex,
                  );
                },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: _buildRewardContent(reward, scheme),
          ),
        ),
      ),
    );
  }

  Widget _buildRewardContent(Reward reward, ColorScheme scheme) {
    if (reward is TemporaryAttributeBoost) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '⚡ Attribute Boost',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (reward.isActive)
                Chip(
                  label: const Text('Active', style: TextStyle(fontSize: 10)),
                  backgroundColor: scheme.primary,
                  labelStyle: TextStyle(color: scheme.onPrimary),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: reward.attributesBoostAmount.entries.map((e) {
              return Chip(
                label: Text(
                  '${e.key.name} +${e.value}',
                  style: const TextStyle(fontSize: 10),
                ),
                backgroundColor: scheme.secondaryContainer,
              );
            }).toList(),
          ),
        ],
      );
    } else if (reward is SessionBoost) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '📢 Session Boost',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (reward.isActive)
                Chip(
                  label: const Text('Active', style: TextStyle(fontSize: 10)),
                  backgroundColor: scheme.primary,
                  labelStyle: TextStyle(color: scheme.onPrimary),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Multiplier: x${reward.sessionBoostMultiplyer.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 12, color: scheme.onSurface),
          ),
        ],
      );
    }

    return Text(
      reward.type.name,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  bool _shouldShowSkillPicker(Reward reward) {
    // Show skill picker for rewards that apply to specific skills
    return reward is SessionBoost || reward is TemporaryAttributeBoost;
  }

  Future<int?> _showSkillPickerDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final player = ref.read(playerProvider);
    return showDialog<int?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Skill'),
        content: SizedBox(
          width: 300,
          child: ListView.builder(
            itemCount: player.skills.length,
            itemBuilder: (context, index) {
              final skill = player.skills[index];
              return ListTile(
                leading: Text(skill.type.icon),
                title: Text(skill.type.name),
                onTap: () => Navigator.pop(context, index),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
