import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_tamer/data/model/player/player.dart';
import 'package:skill_tamer/data/riverpod/player/player_provider.dart';


class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
const HomeAppBar({ super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    Player player = ref.watch(playerProvider);

    return AppBar(
      title: Text("Skill Tamer"),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(4.0),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               LinearProgressIndicator(
                  value: player.xpGainedForNextLevel() / player.xpToNextLevel(),
                  backgroundColor: const Color.fromARGB(120, 0, 0, 0),
                  color: scheme.onPrimary,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(10),
                ),
                Text(
                  " ${player.xpGainedForNextLevel()} / ${player.xpToNextLevel()}xp",
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.w600
                  ),
                )
            ],
          ),
        )
      ),
      actionsPadding: EdgeInsetsDirectional.symmetric(horizontal: 10),
      actions: [
        Text(
          "${player.getLevel()} lvl",
          style: TextStyle(
            fontSize: 24,
            color: scheme.onPrimary,
            fontWeight: FontWeight.w600

          ),
          )
      ],
      titleTextStyle: TextStyle(
        color: scheme.onPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: scheme.primary,
      elevation: 1,
      centerTitle: false,
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
