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

    return ListView.separated(
      itemCount: rewards.length,  
       padding: EdgeInsetsGeometry.all(15),
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 15), 
      itemBuilder: (BuildContext context, int index) => RewardCard(rewardIndex: index),
    );
  }
}
