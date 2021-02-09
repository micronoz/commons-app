import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/club_card.dart';
import 'package:tribal_instinct/model/discover_types.dart';
import 'package:tribal_instinct/pages/clubs/create_club.dart';
import 'package:tribal_instinct/pages/discover/discover.dart';

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
                      builder: (context) => DiscoverPage(DiscoverType.clubs)));
                },
                child: Text(
                  'Discover Clubs',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          ClubCard()
        ],
      ),
    );
  }
}
