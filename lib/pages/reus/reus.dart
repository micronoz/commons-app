import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/event_card.dart';
import 'package:tribal_instinct/pages/reus/create_reu.dart';

class ReusPage extends StatefulWidget {
  const ReusPage({Key key}) : super(key: key);
  @override
  _ReusPageState createState() => _ReusPageState();
}

class _ReusPageState extends State<ReusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reus'), actions: [
        IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CreateReuPage())),
            icon: Icon(Icons.add_rounded))
      ]),
      body: ListView(
        children: [EventCard(), EventCard(), EventCard()],
      ),
    );
  }
}
