import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/reward/redistribute_attribute_points.dart';
import 'package:skill_tamer/data/model/reward/reward.dart';
import 'package:skill_tamer/data/model/reward/temporary_attribute_boost.dart';
import 'package:skill_tamer/data/model/reward/session_boost.dart';
import 'package:skill_tamer/data/model/reward/instant_mission.dart';
import 'package:skill_tamer/data/constant/app_durations.dart';
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
    final reward = ref.watch(
      playerProvider.select((p) => p.rewards[widget.rewardIndex]),
    );

    final controller = ref.read(playerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    final rewardType = reward.type;

    final isActive = reward.isActive;

    return AnimatedContainer(
      duration: AppDurations.shortAnimationDuration,
      padding: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        color: isActive ? scheme.primary : Colors.transparent,
      ),
      child: Material(
        color: isActive ? const Color(0xFF111111) : const Color(0xFF0A0A0A),
        child: InkWell(
          onTap: isActive
              ? null
              : () async {
                  int? selectedSkillIndex;
                  if (reward is RedistributeAttributePoints) {
                    selectedSkillIndex = await _showSkillPickerDialog(context, ref);
                    if (selectedSkillIndex == null) return;
                  }

                  controller.useReward(
                    rewardIndex: widget.rewardIndex,
                    skillIndex: selectedSkillIndex ?? 0,
                  );
                },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isActive ? Colors.black : scheme.primary.withAlpha(26),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildContent(reward, rewardType, scheme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      Reward reward,
      rewardType,
      ColorScheme scheme,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: scheme.primary.withAlpha(13),
                border: Border.all(color: scheme.primary.withAlpha(26)),
              ),
              child: Text(
                rewardType.icon,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rewardType.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    rewardType.description,
                    style: TextStyle(
                      fontSize: 10,
                      color: scheme.primary.withAlpha(128),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            if (reward.isActive)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: scheme.primary,
                ),
                child: const Text(
                  "ACTIVE",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              )
          ],
        ),

        const SizedBox(height: 16),

        if (reward is TemporaryAttributeBoost)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: reward.attributesBoostAmount.entries.map((e) {
              return _chip(
                scheme,
                "${e.key.name.toUpperCase()} +${e.value}",
              );
            }).toList(),
          ),

        if (reward is SessionBoost)
          _highlightBox(
            scheme,
            "XP MULTIPLIER X${reward.sessionBoostMultiplyer.toStringAsFixed(2)}",
          ),

        if (reward is RedistributeAttributePoints)
          _highlightBox(
            scheme,
            "SELECT SKILL FOR REDISTRIBUTION",
          ),

        if (reward is InstantMission)
          _highlightBox(
            scheme,
            "INSTANT MISSION REFRESH",
          ),
      ],
    );
  }

  Widget _chip(ColorScheme scheme, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primary.withAlpha(26),
        border: Border.all(color: scheme.primary.withAlpha(51)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: scheme.primary,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _highlightBox(ColorScheme scheme, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.primary.withAlpha(13),
        border: Border.all(color: scheme.primary.withAlpha(26)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: scheme.primary,
          letterSpacing: 1.1,
        ),
      ),
    );
  }


  Future<int?> _showSkillPickerDialog(BuildContext context,WidgetRef ref) async {
    final player = ref.read(playerProvider);

    return showDialog<int?>(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero),
        title: const Text('Select Skill'),
        content: SizedBox(
          width: 300,
          child: ListView.builder(
            shrinkWrap: true,
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
      ),
    );
  }
}