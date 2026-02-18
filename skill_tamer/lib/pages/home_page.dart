import 'package:flutter/material.dart';
import 'package:skill_tamer/components/home_app_bar.dart';


class HomePage extends StatelessWidget {
const HomePage({ super.key });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: HomeAppBar(),
      body: DefaultTabController(
        length: 3, 
        child: Column(
          children: [

            TabBarView(
              children: [
                
              ]
            ),

            TabBar(
              tabs: [

              ]
            )
          ],
        ),
      )
    );
  }
}