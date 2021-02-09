import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:tribal_instinct/components/member_card.dart';
import 'package:tribal_instinct/model/adventure.dart';
import 'package:tribal_instinct/model/adventure_types.dart';

class AdventureDetailPage extends StatefulWidget {
  @override
  _AdventureDetailPageState createState() => _AdventureDetailPageState();
}

class _AdventureDetailPageState extends State<AdventureDetailPage> {
  final DateFormat _format = DateFormat();
  final adventure = Adventure.getDefault();
  final String _id = '1';
  final timeout = const Duration(seconds: 1);

  var _absorbing = false;
  var _success = false;
  var _attending = false;

  void joinEvent(id) {
    Timer(timeout, () {
      setState(() {
        _absorbing = false;
        _success = false;
        _attending = true;
      });
    });

    setState(() {
      _absorbing = true;
      _success = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_absorbing,
      child: AbsorbPointer(
        absorbing: _absorbing,
        child: Stack(
          children: [
            Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: _attending
                  ? null
                  : FloatingActionButton.extended(
                      backgroundColor: Colors.green,
                      onPressed: () {
                        joinEvent(_id);
                      },
                      label: Text(
                        'Sign up for this Adventure',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                    ),
              appBar: AppBar(
                title: Text('Adventure details'),
              ),
              body: ListView(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      adventure.photoUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    adventure.title,
                    style: Theme.of(context).textTheme.headline2,
                    textScaleFactor: 0.6,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    (adventure.mediumType == AdventureMedium.in_person
                            ? 'in-person at '
                            : 'online at ') +
                        adventure.location,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                    textScaleFactor: 1.3,
                  ),
                  Text(
                    adventure.hostType == AdventureHost.self_hosted
                        ? 'without a host present'
                        : 'with host present',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                    textScaleFactor: 1.3,
                  ),
                  Text(
                    'on ' + _format.format(adventure.dateTime.toLocal()),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                    textScaleFactor: 1.3,
                  ),
                  Text(
                    'Available space: ${adventure.cohortSize - adventure.attendees.length}/${adventure.cohortSize}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                    textScaleFactor: 1.3,
                  ),
                  Text(
                    'Price: ' + adventure.price,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                    textScaleFactor: 1.3,
                  ),
                  Text(
                    adventure.description,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  if (_attending)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, top: 10),
                          child: Text(
                            'My Group',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blueGrey,
                                  maxRadius: 30,
                                ),
                                Text('Nabi')
                              ],
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blueGrey,
                                  maxRadius: 30,
                                ),
                                Text('Unassigned')
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      'Participants',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  ...adventure.attendees.map(
                    (m) => MemberCard(
                      m,
                    ),
                  ),
                  if (!_attending)
                    const SizedBox(
                      height: 60,
                    )
                ],
              ),
            ),
            if (_success)
              SafeArea(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Center(
                    child: Icon(
                      Icons.check_circle,
                      size: 100,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
