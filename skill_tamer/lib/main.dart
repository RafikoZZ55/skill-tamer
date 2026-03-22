import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:skill_tamer/data/hive/mission_state.dart';
import 'package:skill_tamer/data/hive/player_state.dart';
import 'package:skill_tamer/data/hive/reward_state.dart';
import 'package:skill_tamer/data/hive/session_history_state.dart';
import 'package:skill_tamer/data/hive/session_state.dart';
import 'package:skill_tamer/data/hive/skill_state.dart';
import 'package:skill_tamer/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MissionStateAdapter());
  Hive.registerAdapter(SkillStateAdapter());
  Hive.registerAdapter(RewardStateAdapter());
  Hive.registerAdapter(SessionStateAdapter());
  Hive.registerAdapter(SessionHistoryStateAdapter());
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
          seedColor: const Color(0xFF14B8A6),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        cardTheme: CardThemeData(
          color: const Color(0xFF161B22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF30363D), width: 0.7),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D1117),
          centerTitle: true,
          elevation: 0,
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          side: const BorderSide(color: Color(0xFF30363D)),
          selectedColor: const Color(0xFF1F6FEB),
          backgroundColor: const Color(0xFF161B22),
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
          titleSmall: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      title: "Skill Tracker",
      home: HomePage(),
    );
  }
}
