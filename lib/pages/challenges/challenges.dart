import 'package:flutter/material.dart';
import 'package:tribal_instinct/pages/challenges/battles.dart';
import 'package:tribal_instinct/pages/challenges/quests.dart';

import 'alliances.dart';

class ChallengesPage extends StatefulWidget {
  @override
  _ChallengesPageState createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Events'),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Alliance',
                ),
                Tab(
                  text: 'Battle',
                ),
                Tab(
                  text: 'Quest',
                )
              ],
            ),
          ),
          body: TabBarView(
              children: [AlliancesPage(), BattlesPage(), QuestsPage()]),
        ));
  }
}
