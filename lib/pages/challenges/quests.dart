import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/event_card.dart';

class QuestsPage extends StatefulWidget {
  @override
  _QuestsPageState createState() => _QuestsPageState();
}

class _QuestsPageState extends State<QuestsPage>
    with AutomaticKeepAliveClientMixin<QuestsPage> {
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
