import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/reward/reward.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';


class RewardCard extends ConsumerStatefulWidget {
  const RewardCard({ super.key, required this.rewardIndex });
  final int rewardIndex;

  @override
  createState() => _RewardCardState();
}

class _RewardCardState extends ConsumerState<RewardCard> {

  @override
  Widget build(BuildContext context) {
    Reward reward = ref.watch(playerProvider.select((p) => p.rewards[widget.rewardIndex]));

    return Card(

    );
  }
}