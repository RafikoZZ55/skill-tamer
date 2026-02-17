import 'package:flutter/material.dart';
import 'package:skill_tamer/pages/home_page.dart';

void main() {
  runApp(const Main());
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