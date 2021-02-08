import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/club_card.dart';
import 'package:tribal_instinct/pages/clubs/create_club.dart';

class ClubsPage extends StatefulWidget {
  @override
  _ClubsPageState createState() => _ClubsPageState();
}

class _ClubsPageState extends State<ClubsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clubs'),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateClubPage())),
              icon: Icon(Icons.add_rounded))
        ],
      ),
      body: ListView(
        children: [ClubCard()],
      ),
    );
  }
}
