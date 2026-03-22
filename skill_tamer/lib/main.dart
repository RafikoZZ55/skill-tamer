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
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 207, 207, 207),
          surface: Color(0xFF0C0C0C),
          onSurface: Color(0xFFFFFFFF),
          secondary: Color.fromARGB(255, 255, 0, 221),
          //secret color he he 
        ),
        scaffoldBackgroundColor: const Color(0xFF000000),
        cardTheme: CardThemeData(
          color: const Color(0xFF0C0C0C),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Color(0xFF00FFF2).withAlpha(51), width: 1.0),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF0C0C0C),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Color(0xFF00FFF2), width: 2),
          ),
          titleTextStyle: TextStyle(
            color: const Color(0xFF00FFF2),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF00FFF2),
          thickness: 0.5,
          space: 24,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: const Color(0xFF00FFF2),
          linearTrackColor: Color(0xFF00FFF2).withAlpha(26),
          refreshBackgroundColor: const Color(0xFF0C0C0C),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF000000),
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF00FFF2),
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 3.0,
          ),
          iconTheme: IconThemeData(color: Color(0xFF00FFF2)),
        ),
        chipTheme: ChipThemeData(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          side: const BorderSide(color: Color(0xFF00FFF2)),
          selectedColor: const Color(0xFF00FFF2),
          secondarySelectedColor: const Color(0xFF00FFF2),
          backgroundColor: Colors.transparent,
          labelStyle: const TextStyle(color: Color(0xFF00FFF2), fontWeight: FontWeight.bold),
          secondaryLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Color(0xFF00FFF2), fontWeight: FontWeight.bold, letterSpacing: 1.0),
          titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          titleSmall: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF00FFF2)),
      ),

      title: "Skill Tracker",
      home: HomePage(),
    );
  }
}
