import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:skill_tamer/data/hive/mission_state.dart';
import 'package:skill_tamer/data/hive/player_state.dart';
import 'package:skill_tamer/data/hive/reward_state.dart';
import 'package:skill_tamer/data/hive/session_state.dart';
import 'package:skill_tamer/data/hive/skill_state.dart';
import 'package:skill_tamer/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MissionStateAdapter());
  Hive.registerAdapter(SkillStateAdapter());
  Hive.registerAdapter(RewardStateAdapter());
  Hive.registerAdapter(SessionStateAdapter());
  Hive.registerAdapter(PlayerStateAdapter());

  await Hive.openBox<PlayerState>("player");

  runApp(ProviderScope(child: const Main()));
}

class Main extends StatelessWidget {
const Main({ super.key });

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.tealAccent,
          brightness: Brightness.dark,
        ),
      ),

      title: "Skill Tracker",
      home: HomePage(),
    );
  }
}