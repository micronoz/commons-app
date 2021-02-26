import 'package:flutter/material.dart';
import 'package:tribal_instinct/managers/user_manager.dart';
import 'package:tribal_instinct/model/app_user.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final appUser = AppUser.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(appUser.profile.identifier),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: appUser.profile.photo, fit: BoxFit.fill),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '1500',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Followers')
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '1500',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Following')
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '1500',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('SocialCapital')
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Past events',
              style: Theme.of(context).textTheme.headline3,
              textScaleFactor: 0.8,
            ),
            const SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                UserManager.of(context).logout();
              },
              child: Text('Logout'),
            )
          ],
        ),
      ),
    );
  }
}
