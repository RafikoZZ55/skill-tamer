import 'package:flutter/material.dart';


class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
const HomeAppBar({ super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;

    return AppBar(
      title: const Row(
        children: [
          Text("Skill Tamer"),
        ],
      ),
      titleTextStyle: TextStyle(
        color: scheme.onPrimary,
        fontSize: 26,
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
