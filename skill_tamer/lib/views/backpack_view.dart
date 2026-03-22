import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/constant/app_durations.dart';
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
            style: SegmentedButton.styleFrom(
              backgroundColor: Colors.black,
              selectedBackgroundColor: Colors.white,
              selectedForegroundColor: Colors.black,
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withAlpha(51)),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            segments: const [
              ButtonSegment(
                value: BackpackTab.skills,
                label: Text("SKILLS", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                icon: Icon(Icons.auto_awesome, size: 16),
              ),
              ButtonSegment(
                value: BackpackTab.rewards,
                label: Text("REWARDS", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                icon: Icon(Icons.card_giftcard, size: 16),
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
              duration: AppDurations.shortAnimationDuration,
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
