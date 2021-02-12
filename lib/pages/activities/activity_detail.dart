import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:tribal_instinct/components/member_card.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/activity_types.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/pages/invite.dart';

class ActivityDetailPage extends StatefulWidget {
  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  final DateFormat _format = DateFormat();
  final activity = Activity.getDefault();
  final String _id = '1';
  final timeout = const Duration(seconds: 1);

  final currentUser = AppUser(); //TODO REMOVE
  var isAdmin = false;

  var _absorbing = false;
  var _success = false;
  var _attending = true;

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

  void invite(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => InvitePage(activity)));
  }

  @override
  Widget build(BuildContext context) {
    currentUser.hydrate();
    var availableSpots = activity.cohortSize - activity.attendees.length;
    isAdmin = currentUser == activity.organizer;
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
                        'Sign up for this Activity',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                    ),
              appBar: AppBar(
                title: Text('Activity details'),
              ),
              body: ListView(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      activity.photoUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    activity.title,
                    style: Theme.of(context).textTheme.headline2,
                    textScaleFactor: 0.6,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    (activity.mediumType == ActivityMedium.in_person
                            ? 'in-person at '
                            : 'online at ') +
                        activity.location,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                    textScaleFactor: 1.3,
                  ),
                  // Text(
                  //   activity.hostType == ActivityHost.self_hosted
                  //       ? 'without a host present'
                  //       : 'with host present',
                  //   textAlign: TextAlign.center,
                  //   style: Theme.of(context).textTheme.bodyText1,
                  //   textScaleFactor: 1.3,
                  // ),
                  Text(
                    'on ' + _format.format(activity.dateTime.toLocal()),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                    textScaleFactor: 1.3,
                  ),
                  Text(
                    'Available space: ${activity.cohortSize - activity.attendees.length}/${activity.cohortSize}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                    textScaleFactor: 1.3,
                  ),
                  Text(
                    'Price: ' + activity.price,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                    textScaleFactor: 1.3,
                  ),
                  Text(
                    activity.description,
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
                            isAdmin ? 'Slots' : 'My Group',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.spaceEvenly,
                            runSpacing: 10,
                            spacing: 35,
                            children: [
                              ...activity.attendees.map(
                                (user) => Column(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Colors.blueGrey,
                                        maxRadius: 35,
                                        backgroundImage: user.photo),
                                    Text(user.name)
                                  ],
                                ),
                              ),
                              ...List.generate(availableSpots, (index) => null)
                                  .map((e) => isAdmin
                                      ? Column(
                                          children: [
                                            InkWell(
                                              onTap: () => invite(context),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Colors.blueGrey,
                                                maxRadius: 35,
                                                child: Text(
                                                  '+',
                                                  textScaleFactor: 3,
                                                ),
                                              ),
                                            ),
                                            Text('Add')
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.blueGrey,
                                              maxRadius: 35,
                                              child: Text(
                                                '?',
                                                textScaleFactor: 3,
                                              ),
                                            ),
                                            Text('null')
                                          ],
                                        ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      'Participants',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  ...activity.attendees.map((m) => MemberCard(
                      m,
                      'Unfollow',
                      'Follow',
                      (AppUser u) => currentUser.following.contains(u))),

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
