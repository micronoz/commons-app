import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tribal_instinct/components/member_card.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/activity_types.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/user_profile.dart';
import 'package:tribal_instinct/pages/chat.dart';

final getActivityQuery = '''
  query GetActivity(\$id: String!) {
    activity(id: \$id) {
      organizer {
        id
      }
      id
      title
      description
      mediumType
      eventDateTime
      eventCoordinates{
        x
        y
      }
      discoveryCoordinates{
        x
        y
      }
      userConnections{
        user {
          id
        }
      }
      physicalAddress
      eventUrl
    }
  }
''';

class ActivityDetailPage extends StatefulWidget {
  final String activityId;
  ActivityDetailPage(this.activityId);
  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  final DateFormat _format = DateFormat.yMMMMEEEEd().add_jm();
  final timeout = const Duration(seconds: 1);

  var isAdmin = false;

  var _absorbing = false;
  var _success = false;
  var _attending = true;

  var _tabIndex = 0;

  final tabs = <Tab>[
    Tab(
      icon: Icon(Icons.message),
      text: 'Messages',
    ),
    Tab(icon: Icon(Icons.details), text: 'Details'),
  ];

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

  // void invite(BuildContext context) {
  //   Navigator.of(context).push(
  //       MaterialPageRoute(builder: (context) => InvitePage(widget.activity)));
  // }

  @override
  Widget build(BuildContext context) {
    print('Activity id: ${widget.activityId}');
    return Query(
      options: QueryOptions(
          document: gql(getActivityQuery),
          pollInterval: Duration(minutes: 1),
          variables: {'id': widget.activityId}),
      builder: (result, {refetch, fetchMore}) {
        if (result.hasException) {
          print('Activity Detail page query exception:');
          print(result.exception);
        }
        if (result.isLoading || result.data == null) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final activity = Activity.fromJson(result.data['activity']);
        final currentUser = AppUser.of(context);
        var tabBar = TabBar(
          tabs: tabs,
          onTap: (index) => setState(() {
            _tabIndex = index;
            if (index == 1) {
              final currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            }
          }),
        );
        currentUser.hydrate();
        isAdmin = currentUser.profile == activity.organizer;
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
                            joinEvent(activity.id);
                          },
                          label: Text(
                            'Sign up for this Activity',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                  appBar: AppBar(
                    title: Text('Activity details'),
                    bottom: PreferredSize(
                      preferredSize: tabBar.preferredSize,
                      child: DefaultTabController(
                        child: tabBar,
                        length: 2,
                        initialIndex: _tabIndex,
                      ),
                    ),
                  ),
                  body: IndexedStack(
                    index: _tabIndex,
                    children: [
                      ChatPage(false, widget.activityId),
                      ListView(
                        children: [
                          Text(
                            activity.title,
                            style: Theme.of(context).textTheme.headline2,
                            textScaleFactor: 0.6,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            (activity.mediumType == ActivityMedium.in_person
                                ? 'in-person' +
                                    (activity.physicalAddress != null
                                        ? ' at ' + activity.physicalAddress
                                        : '')
                                : 'online' +
                                    (activity.eventUrl != null
                                        ? ' at ' + activity.eventUrl
                                        : '')),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText1,
                            textScaleFactor: 1.3,
                          ),
                          if (activity.dateTime != null)
                            Text(
                              'on ' +
                                  _format.format(activity.dateTime?.toLocal()),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1,
                              textScaleFactor: 1.3,
                            ),
                          if (activity.description != null)
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
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 10),
                                  child: Text(
                                    isAdmin ? 'Slots' : 'My Group',
                                    style:
                                        Theme.of(context).textTheme.headline5,
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
                                                backgroundColor:
                                                    Colors.blueGrey,
                                                maxRadius: 35,
                                                backgroundImage: user.photo),
                                            Text(user.name)
                                          ],
                                        ),
                                      ),
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
                              (UserProfile u) =>
                                  currentUser.following.contains(u))),
                          if (!_attending)
                            const SizedBox(
                              height: 60,
                            )
                        ],
                      ),
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
      },
    );
  }
}
