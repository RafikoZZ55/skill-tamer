import 'package:flutter/material.dart';
import 'package:skill_tamer/components/home_app_bar.dart';
import 'package:skill_tamer/views/mission_view.dart';
import 'package:skill_tamer/views/session_timer_view.dart';
import 'package:skill_tamer/views/skill_deck_view.dart';


class HomePage extends StatelessWidget {
const HomePage({ super.key });

  static final List<Widget> views = [
    SkillDeckView(),
    MissionView(),
    SessionTimerView(),
  ];

  static final List<Tab> tabs = [
    Tab(
      text: "Skills",
    ),
    Tab(
      text: "Mission",
    ),
    Tab(
      text: "Session",
    ),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: HomeAppBar(),
      body: DefaultTabController(
        length: 3, 
        child: Column(
          children: [
            Expanded(child: TabBarView( children: views )),
            TabBar( tabs: tabs ),
          ],
        ),
      )
    );
  }
}