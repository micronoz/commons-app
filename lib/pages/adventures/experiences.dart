import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/event_card.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/pages/adventures/create_adventure.dart';

class ExperiencesPage extends StatefulWidget {
  @override
  _ExperiencesPageState createState() => _ExperiencesPageState();
}

class _ExperiencesPageState extends State<ExperiencesPage> {
  final myUser = AppUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateAdventurePage())),
              icon: Icon(Icons.add_rounded))
        ],
        title: Text('Experiences'),
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
