import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/tribe_card.dart';
import 'package:tribal_instinct/pages/create_tribe.dart';

class TribePage extends StatefulWidget {
  @override
  _TribePageState createState() => _TribePageState();
}

class _TribePageState extends State<TribePage> {
  bool isMember; //TODO Needs to listen
  String tribeId; //TODO Needs to listen

  @override
  Widget build(BuildContext context) {
    isMember = false;

    return Scaffold(
      appBar: AppBar(
        title:
            isMember ? Text('Tribe Hangout') : Text('Join or Create a Tribe'),
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Center(
            child: Text(
              'Enter Tribe code',
              style: Theme.of(context).textTheme.bodyText1,
              textScaleFactor: 1.5,
            ),
          ),
          Row(
            children: [
              Spacer(
                flex: 1,
              ),
              Expanded(
                child: Form(
                  child: TextFormField(),
                ),
                flex: 8,
              ),
              Spacer(
                flex: 1,
              )
            ],
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => print('Join team'),
              child: Text('Join'),
            ),
          ),
          Divider(
            thickness: 10,
          ),
          Center(
            child: Text(
              'Create a Tribe',
              style: Theme.of(context).textTheme.bodyText1,
              textScaleFactor: 1.5,
            ),
          ),
          IconButton(
              icon: Stack(children: [
                Icon(Icons.festival),
                Positioned(
                  child: Text(
                    '+',
                    textScaleFactor: 1.1,
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  top: 0,
                  right: 0,
                )
              ]),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CreateTribePage()));
              }),
          Divider(
            thickness: 10,
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Top Tribes in your area',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    ...[1, 2, 3]
                        .map((e) => SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TribeCard(),
                            ))
                        .toList(),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Tribes with most friends in them',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    ...[1, 2, 3]
                        .map((e) => SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TribeCard(
                                extras: Text('Has 4 friends'),
                              ),
                            ))
                        .toList(),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
