import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/event_card.dart';
import 'package:tribal_instinct/pages/mingles/create_mingle.dart';

class MinglesPage extends StatefulWidget {
  const MinglesPage({Key key}) : super(key: key);
  @override
  _MinglesPageState createState() => _MinglesPageState();
}

class _MinglesPageState extends State<MinglesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mingles'), actions: [
        IconButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CreateMinglePage())),
            icon: Icon(Icons.add_rounded))
      ]),
      body: ListView(
        children: [EventCard(), EventCard(), EventCard()],
      ),
    );
  }
}
