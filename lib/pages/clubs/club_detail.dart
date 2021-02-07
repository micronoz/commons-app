import 'package:flutter/material.dart';
import 'package:tribal_instinct/model/club.dart';

class ClubDetailPage extends StatefulWidget {
  @override
  _ClubDetailPageState createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {
  @override
  Widget build(BuildContext context) {
    var _tribeModel = Club();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Join Tribe'),
        icon: Icon(Icons.hvac_rounded), //TODO Find handshake icon
        onPressed: () {
          print('Join Tribe button');
        },
      ),
      appBar: AppBar(
        title: Text('Tribe Tour'),
      ),
      body: ListView(
        children: [
          Image.network(_tribeModel.photoUrl),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Container(
                    //   width: 60,
                    //   height: 60,
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     image: DecorationImage(
                    //         image: NetworkImage(_tribeModel.mainPhoto),
                    //         fit: BoxFit.fill),
                    //   ),
                    // ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          _tribeModel.title,
                          style: Theme.of(context).textTheme.headline1,
                          textScaleFactor: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _tribeModel.description,
                  style: Theme.of(context).textTheme.bodyText1,
                  textScaleFactor: 1.3,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
