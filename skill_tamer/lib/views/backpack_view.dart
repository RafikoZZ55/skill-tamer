import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'backpack_reward_view.dart';
import 'backpack_skill_view.dart';

enum BackpackTab { skills, rewards }

class BackpackView extends ConsumerStatefulWidget {
  const BackpackView({super.key});

  @override
  ConsumerState<BackpackView> createState() => _BackpackViewState();
}

class _BackpackViewState extends ConsumerState<BackpackView> {
  BackpackTab _selectedTab = BackpackTab.skills;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          SegmentedButton<BackpackTab>(
            segments: const [
              ButtonSegment(
                value: BackpackTab.skills,
                label: Text("Skills"),
                icon: Icon(Icons.auto_awesome),
              ),
              ButtonSegment(
                value: BackpackTab.rewards,
                label: Text("Rewards"),
                icon: Icon(Icons.card_giftcard),
              ),
            ],
            selected: {_selectedTab},
            onSelectionChanged: (selected) {
              setState(() {
                _selectedTab = selected.first;
              });
            },
          ),

          const SizedBox(height: 16),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _selectedTab == BackpackTab.skills
                  ? const BackpackSkillView(key: ValueKey("skills"))
                  : const BackpackRewardView(key: ValueKey("rewards")),
            ),
          ),
        ],
      ),
    );
  }
}