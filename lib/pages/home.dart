import 'package:flutter/material.dart';
import 'package:tribal_instinct/pages/clubs/clubs.dart';
import 'package:tribal_instinct/pages/feed.dart';
import 'package:tribal_instinct/pages/activities/activities.dart';
import 'package:tribal_instinct/pages/profile.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(builder: (context) => HomePage());
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final menuIcons = <Map<String, Object>>[
    {'icon': Icons.rss_feed, 'label': 'Feed'},
    {'icon': Icons.calendar_today, 'label': 'Experiences'},
    //  {'icon': Icons.group, 'label': 'Clubs'},
    {'icon': Icons.supervisor_account, 'label': 'Profile'}
  ]
      .map(
        (i) => BottomNavigationBarItem(
            icon: Icon(
              i['icon'] as IconData,
            ),
            label: i['label']),
      )
      .toList(growable: false);

  final _pages = [
    FeedPage(),
    ExperiencesPage(),
    //ClubsPage(),
    ProfilePage(),
  ];

  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pageIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 14,
        selectedFontSize: 14,
        iconSize: 28,
        unselectedItemColor: Theme.of(context).disabledColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: menuIcons,
        currentIndex: _pageIndex,
        onTap: (index) => setState(() => _pageIndex = index),
      ),
    );
  }
}
