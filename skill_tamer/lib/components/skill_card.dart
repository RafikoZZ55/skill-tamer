import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/skill/skill.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';

class SkillCard extends ConsumerStatefulWidget {
  const SkillCard({ super.key, required this.skillIndex });
  final int skillIndex;

  @override
  _SkillCardState createState() => _SkillCardState();
}

class _SkillCardState extends ConsumerState<SkillCard> {
  @override
  Widget build(BuildContext context) {

    Skill skill = ref.watch(playerProvider.select((p) => p.skills[widget.skillIndex]));

    return Card(
      child: Column(
        children: [
          Text(skill.type.name)
        ],
      ),
    );
  }
}