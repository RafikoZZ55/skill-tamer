import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/components/reward_card.dart';
import 'package:skill_tamer/data/model/reward/reward.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';

class BackpackRewardView extends ConsumerStatefulWidget {
  const BackpackRewardView({ super.key });

  @override
  createState() => _BackpackRewardViewState();
}

class _BackpackRewardViewState extends ConsumerState<BackpackRewardView> {
  @override
  Widget build(BuildContext context) {
    List<Reward> rewards = ref.watch(playerProvider.select((p) => p.rewards));

    return GridView.builder(
      itemCount: rewards.length,
       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),     
      itemBuilder: (context, index) => RewardCard(rewardIndex: index),
    );
  }
}
