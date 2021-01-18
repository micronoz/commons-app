import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/event_card.dart';

class AlliancesPage extends StatefulWidget {
  @override
  _AlliancesPageState createState() => _AlliancesPageState();
}

class _AlliancesPageState extends State<AlliancesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [EventCard(), EventCard(), EventCard()],
      ),
    );
  }
}
