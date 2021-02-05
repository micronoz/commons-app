import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/event_card.dart';
import 'package:tribal_instinct/model/app_user.dart';

class MyAdventuresPage extends StatefulWidget {
  @override
  _MyAdventuresPageState createState() => _MyAdventuresPageState();
}

class _MyAdventuresPageState extends State<MyAdventuresPage> {
  final myUser = AppUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Adventures'),
      ),
      body: ListView(
        children: [
          Text(
            'I\'m hosting',
            style: Theme.of(context).textTheme.headline1,
            textScaleFactor: 0.4,
          ),
          EventCard(),
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
