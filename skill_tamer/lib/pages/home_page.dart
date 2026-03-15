import 'package:flutter/material.dart';
import 'package:skill_tamer/components/home_app_bar.dart';
import 'package:skill_tamer/views/mission_view.dart';
import 'package:skill_tamer/views/session_history_view.dart';
import 'package:skill_tamer/views/session_timer_view.dart';
import 'package:skill_tamer/views/backpack_view.dart';


class HomePage extends StatelessWidget {
const HomePage({ super.key });

  static final List<Widget> views = [
    BackpackView(),
    MissionView(),
    SessionTimerView(),
    SessionHistoryView(),
  ];

  static final List<Tab> tabs = [
    Tab(
      text: "Backpack",
    ),
    Tab(
      text: "Mission",
    ),
    Tab(
      text: "Session",
    ),
    Tab(
      text: "History",
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            Expanded(
              child: TabBarView(children: views),
            ),
            Material(
              elevation: 2,
              child: TabBar(
                tabs: tabs,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
