import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/event_card.dart';
import 'package:tribal_instinct/pages/adventures/create_adventure.dart';

class AdventuresPage extends StatefulWidget {
  const AdventuresPage({Key key}) : super(key: key);
  @override
  _AdventuresPageState createState() => _AdventuresPageState();
}

class _AdventuresPageState extends State<AdventuresPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adventures'), actions: [
        IconButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CreateAdventurePage())),
            icon: Icon(Icons.add_rounded))
      ]),
      body: ListView(
        children: [EventCard(), EventCard(), EventCard()],
      ),
    );
  }
}
