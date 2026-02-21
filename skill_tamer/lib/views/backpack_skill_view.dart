import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/components/skill_card.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';


class BackpackSkillView extends ConsumerStatefulWidget {
  const BackpackSkillView({ super.key });

  @override
  _BackpackSkillViewState createState() => _BackpackSkillViewState();
}

class _BackpackSkillViewState extends ConsumerState<BackpackSkillView> {
  @override
  Widget build(BuildContext context) {
        final skills = ref.watch(playerProvider.select((p) => p.skills));

    return GridView.builder(
      itemCount: skills.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85, 
      ),
      itemBuilder: (context, index) {
        return SkillCard(skillIndex: index);
      },
    );
  }
}