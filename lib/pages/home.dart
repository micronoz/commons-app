import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tribal_instinct/managers/user_manager.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/onboarding/onboarding_flow.dart';
import 'package:tribal_instinct/pages/feed.dart';
import 'package:tribal_instinct/pages/activities/activities.dart';
import 'package:tribal_instinct/pages/chats.dart';
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
    {'icon': Icons.public, 'label': 'Discover'},
    {'icon': Icons.calendar_today, 'label': 'Activities'},
    // {'icon': Icons.chat, 'label': 'Chats'},
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

  int _pageIndex = 0;

  bool _showingDialog = false;

  @override
  Widget build(BuildContext context) {
    //AppUser is null when the user has not yet been created and fetched.
    final appUser = context.watch<AppUser>();
    final isAppUserNull = appUser == null;

    if (isAppUserNull && !_showingDialog) {
      UserManager.of(context).fetchUserProfile().catchError(
        (error) async {
          _showingDialog = true;
          print(error);
          Timer(
            Duration(seconds: 1),
            () => showDialog(
              barrierColor: Colors.brown[200],
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                title: Center(
                  child: Icon(Icons.error),
                ),
                content: Text(
                    'Error encoutnered while fetching user profile. Check your internet connection and try again.'),
                actions: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _showingDialog = false;
                      });
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Retry'),
                  )
                ],
              ),
            ),
          );
        },
      );
    }
    return Scaffold(
      body: isAppUserNull
          ? FutureBuilder(
              future: UserManager.of(context).appUserResolver.value,
              builder: (context, state) {
                if (!_showingDialog &&
                    state.connectionState == ConnectionState.done) {
                  return OnboardingFlow();
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })
          : IndexedStack(
              index: _pageIndex,
              children: [
                FeedPage(),
                ActivitiesPage(),
                // ChatsPage(),
                ProfilePage(),
              ],
            ),
      bottomNavigationBar: isAppUserNull
          ? null
          : BottomNavigationBar(
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
