import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/event_card_small.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/discover_types.dart';
import 'package:tribal_instinct/pages/activities/create_activity.dart';
import 'package:tribal_instinct/pages/discover/discover.dart';

class ExperiencesPage extends StatefulWidget {
  @override
  _ExperiencesPageState createState() => _ExperiencesPageState();
}

class _ExperiencesPageState extends State<ExperiencesPage> {
  final myUser = AppUser.mock();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateActivityPage())),
              icon: Icon(Icons.add_rounded))
        ],
        title: Text('Experiences'),
      ),
      body: ListView(
        children: [
          Container(
            child: Align(
              heightFactor: 1.5,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                color: Colors.blue[400],
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          DiscoverPage(DiscoverType.experiences)));
                },
                child: Text(
                  'Discover Events',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Text(
            'I\'m hosting',
            style: Theme.of(context).textTheme.headline1,
            textScaleFactor: 0.4,
          ),
          EventCardSmall(Activity.getDefault()),
          Text(
            'I\'m attending',
            style: Theme.of(context).textTheme.headline1,
            textScaleFactor: 0.4,
          ),
          Text(
            'Past',
            style: Theme.of(context).textTheme.headline1,
            textScaleFactor: 0.4,
          ),
        ],
      ),
    );
  }
}
