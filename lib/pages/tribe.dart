import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/tribe_card.dart';

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
        title: isMember
            ? Text('Tribe Hangout')
            : Text('Find a Tribe you belong in'),
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
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Top Tribes in your area'),
                    ...[1, 2, 3]
                        .map((e) => SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TribeCard(),
                            ))
                        .toList(),
                    Text('Tribes with most friends in them'),
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
