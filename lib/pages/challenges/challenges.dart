import 'package:flutter/material.dart';
import 'package:tribal_instinct/pages/challenges/quests.dart';

import 'alliances.dart';

class ChallengesPage extends StatefulWidget {
  const ChallengesPage({Key key}) : super(key: key);
  @override
  _ChallengesPageState createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final List<Tab> tabs = <Tab>[
    Tab(
      text: 'Alliance',
    ),
    Tab(
      text: 'Quest',
    )
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _tabController.index == 1 ? Colors.orange : null,
        title: Text('Events'),
        bottom: TabBar(
          tabs: tabs,
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        children: [AlliancesPage(), QuestsPage()],
        controller: _tabController,
      ),
    );
  }
}
