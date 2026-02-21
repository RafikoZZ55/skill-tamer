import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/components/skill_card.dart';
import 'package:skill_tamer/data/model/skill/skill.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';


class SkillDeckView extends ConsumerStatefulWidget {
  const SkillDeckView({ super.key });

  @override
  createState() => _SkillDeckViewState();
}

class _SkillDeckViewState extends ConsumerState<SkillDeckView> {
  @override
  Widget build(BuildContext context) {
    List<Skill> skills = ref.watch(playerProvider.select((p) => p.skills));
    
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 3),
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(skills.length, (index) => SkillCard(skillIndex: index)),
            ),
          ),
        ),

      ],
    );
  }
}