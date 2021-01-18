import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/event_card.dart';

class AlliancesPage extends StatefulWidget {
  @override
  _AlliancesPageState createState() => _AlliancesPageState();
}

class _AlliancesPageState extends State<AlliancesPage>
    with AutomaticKeepAliveClientMixin<AlliancesPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: ListView(
        children: [EventCard(), EventCard(), EventCard()],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
