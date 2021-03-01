import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tribal_instinct/managers/user_manager.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/pages/feed.dart';
import 'package:tribal_instinct/pages/activities/activities.dart';
import 'package:tribal_instinct/pages/chats.dart';
import 'package:tribal_instinct/pages/onboarding_flow.dart';
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
    {'icon': Icons.chat, 'label': 'Chats'},
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
    ChatsPage(),
    ProfilePage(),
  ];

  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    //AppUser is null when the user has not yet been created and fetched.
    final appUser = context.watch<AppUser>();
    return Scaffold(
      body: appUser == null
          ? FutureBuilder(
              future: UserManager.of(context).appUserResolver.value,
              builder: (context, state) {
                if (state.connectionState == ConnectionState.waiting ||
                    state.connectionState == ConnectionState.none) {
                  return Center(child: CircularProgressIndicator());
                }
                return OnboardingFlow();
              })
          : IndexedStack(
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
