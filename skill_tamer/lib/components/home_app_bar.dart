import 'package:flutter/material.dart';


class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
const HomeAppBar({ super.key});

  @override
  Widget build(BuildContext context){
    ColorScheme scheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Text("Skill Timer"),
      titleTextStyle: TextStyle(
        color: scheme.onPrimary,
        fontSize: 25,
        fontWeight: FontWeight.bold
      ),
      backgroundColor: scheme.primary,
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}