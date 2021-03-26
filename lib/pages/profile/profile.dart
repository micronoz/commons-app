import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:tribal_instinct/managers/user_manager.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/user_profile.dart';
import 'package:tribal_instinct/pages/profile/edit_profile.dart';

class ProfilePage extends StatefulWidget {
  final UserProfile profile;

  ProfilePage({this.profile}) : super();

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final profile = widget.profile ?? AppUser.of(context).profile;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('@${profile.handle}'),
        actions: [
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditProfilePage())))
        ],
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
                          image: profile.photo, fit: BoxFit.fill),
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
            Text(profile.name, style: Theme.of(context).textTheme.headline6),
            const SizedBox(
              height: 10,
            ),
            if (profile.description != null) ...[
              Text(profile.description,
                  style: Theme.of(context).textTheme.headline6),
              const SizedBox(
                height: 10,
              )
            ],
            Text(
              'Past events',
              style: Theme.of(context).textTheme.headline3,
              textScaleFactor: 0.5,
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
