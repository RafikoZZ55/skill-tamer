import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/skill/skill.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';
import 'package:skill_tamer/pages/skill_page.dart';

class SkillCard extends ConsumerStatefulWidget {
  const SkillCard({ super.key, required this.skillIndex });
  final int skillIndex;

  @override
  createState() => _SkillCardState();
}

class _SkillCardState extends ConsumerState<SkillCard> {

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    Skill skill = ref.watch(playerProvider.select((p) => p.skills[widget.skillIndex]));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(skill.type.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                ),
                
                Container(
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    child: Text("lvl ${skill.getLevel().toString()}",
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  ),
                )
              
              ],
            ),
        
            Text(
              skill.type.icon,
              style: TextStyle(
                fontSize: 50
              ),
            ),

            LinearProgressIndicator(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              value: (skill.getXpForNextLevel() / skill.getNextLevelXp()),
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${skill.getXpForNextLevel()} / ${skill.getNextLevelXp()}xp",
              style: TextStyle(
                fontSize: 12.5,
                color: scheme.primary
              ),
              ),
           
              FilledButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SkillPage(skillIndex: widget.skillIndex)));
                }, 
                child: Text("View")
              ),
            ],
          )
          ],
        ),
      ),
    );
  }
}