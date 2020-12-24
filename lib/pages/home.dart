import 'package:flutter/material.dart';
import 'package:tribal_instinct/pages/challenges/challenges.dart';
import 'package:tribal_instinct/pages/feed.dart';
import 'package:tribal_instinct/pages/profile.dart';
import 'package:tribal_instinct/pages/tribe.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final menuIcons = [
    {'icon': Icons.rss_feed, 'label': 'Feed'},
    {'icon': Icons.festival, 'label': 'Tribe'},
    {'icon': Icons.track_changes, 'label': 'Challenges'},
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

  final _pages = [FeedPage(), TribePage(), ChallengesPage(), ProfilePage()];

  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pageIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 28,
        unselectedItemColor: Theme.of(context).disabledColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: menuIcons,
        currentIndex: _pageIndex,
        onTap: (index) => setState(() => _pageIndex = index),
      ),
    );
  }
}
