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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: reward.isActive ? scheme.primary : scheme.outlineVariant,
          width: reward.isActive ? 2.5 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: reward.isActive 
              ? scheme.primary.withOpacity(0.3)
              : Colors.black.withOpacity(0.08),
            blurRadius: reward.isActive ? 12 : 8,
            offset: Offset(0, reward.isActive ? 4 : 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
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
            padding: const EdgeInsets.all(16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '⚡',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Attribute Boost',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Apply to all skills',
                      style: TextStyle(
                        fontSize: 11,
                        color: scheme.onSurface.withOpacity(0.6),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (reward.isActive)
                Chip(
                  label: const Text('Applied', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                  backgroundColor: scheme.primary,
                  labelStyle: TextStyle(color: scheme.onPrimary),
                  side: BorderSide.none,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: reward.attributesBoostAmount.entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: scheme.secondary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  '${e.key.name} +${e.value}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: scheme.onSecondaryContainer,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: scheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '📢',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Session Boost',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Apply to one skill',
                      style: TextStyle(
                        fontSize: 11,
                        color: scheme.onSurface.withOpacity(0.6),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (reward.isActive)
                Chip(
                  label: const Text('Active', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                  backgroundColor: scheme.primary,
                  labelStyle: TextStyle(color: scheme.onPrimary),
                  side: BorderSide.none,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: scheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: scheme.tertiary.withOpacity(0.3),
              ),
            ),
            child: Text(
              'Multiplier: x${reward.sessionBoostMultiplyer.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: scheme.onTertiaryContainer,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Text(
      reward.type.name,
      style: const TextStyle(fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis,
    );
  }

  bool _shouldShowSkillPicker(Reward reward) {
    // Only session boosts need a specific skill target; attribute boosts are global now
    return reward is SessionBoost;
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
