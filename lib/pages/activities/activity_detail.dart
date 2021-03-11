import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/activity_attendance_status.dart';
import 'package:tribal_instinct/model/activity_types.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/pages/activities/manage_activity.dart';
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
      userConnections{
        id
        attendanceStatus
        user {
          id
          fullName
        }
      }
      ... on InPersonActivity {
        physicalAddress
        discoveryCoordinates {
          x
          y
        }
        eventCoordinates{
          x
          y
        }
      }
      ... on OnlineActivity {
        eventUrl
      }
    }
  }
''';

final requestToJoinActivity = r'''
  mutation RequestToJoinActivity($id: String!) {
    requestToJoinActivity(id: $id) {
      id
      attendanceStatus
    }
  }
''';

final removeUserFromActivityMutation = r'''
  mutation RejectActivityRequest($userId: String!, $activityId: String!) {
    rejectJoinRequest(userId: $userId, activityId: $activityId) {
      id
      attendanceStatus
    }
  }
''';

class ActivityDetailPage extends StatefulWidget {
  final String activityId;
  ActivityDetailPage(this.activityId) : super();
  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  final DateFormat _format = DateFormat.yMMMMEEEEd().add_jm();
  final timeout = const Duration(seconds: 1);

  var _absorbing = false;
  var _loading = false;
  var _refetch;

  var _tabIndex = 0;

  final tabs = <Tab>[
    Tab(
      icon: Icon(Icons.message),
      text: 'Messages',
    ),
    Tab(icon: Icon(Icons.details), text: 'Details'),
  ];

//TODO use locking to prevent race conditions
  Future joinEvent(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    final result = await GraphQLProvider.of(context).value.mutate(
        MutationOptions(
            document: gql(requestToJoinActivity),
            variables: {'id': widget.activityId}));
    await _refetch();
    setState(() {
      _loading = false;
    });
  }

  Future removeUser(BuildContext context, String userId) async {
    final client = GraphQLProvider.of(context).value;
    await client.mutate(
      MutationOptions(
          document: gql(removeUserFromActivityMutation),
          variables: {'userId': userId, 'activityId': widget.activityId},
          onError: (error) => print(error.toString()),
          onCompleted: (something) {
            print('complete');
            print(something);
            _refetch();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      key: Key('ActivityDetail'),
      options: WatchQueryOptions(
          cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
          document: gql(getActivityQuery),
          pollInterval: Duration(minutes: 1),
          variables: {'id': widget.activityId},
          fetchPolicy: FetchPolicy.cacheAndNetwork),
      builder: (result, {refetch, fetchMore}) {
        _refetch = refetch;
        if (result.hasException) {
          print('ActivityDetailPage query exception: ${result.exception}');
        }
        if (!result.isConcrete || result.data == null) {
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
        ActivityAttendanceStatus attendanceStatus;
        if (activity.attendees.contains(currentUser.profile)) {
          final userActivity = activity.attendeeConnections
              .firstWhere((element) => element.user == currentUser.profile);
          attendanceStatus = ActivityAttendanceStatus
              .values[userActivity.attendanceStatus + 1];
        } else {
          attendanceStatus = ActivityAttendanceStatus.not_requested;
        }
        final isAdmin = currentUser.profile == activity.organizer;
        var isAttending = attendanceStatus == ActivityAttendanceStatus.joined;

        FloatingActionButton floatingActionButton;
        if (attendanceStatus == ActivityAttendanceStatus.requested) {
          floatingActionButton = FloatingActionButton.extended(
            backgroundColor: Colors.grey,
            onPressed: null,
            label: Text(
              'Already requested to join',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            ),
          );
        } else if (attendanceStatus == ActivityAttendanceStatus.rejected) {
          floatingActionButton = FloatingActionButton.extended(
            icon: Icon(
              Icons.warning,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
            label: Text(
              'Rejected from this activity',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            ),
          );
        } else if (attendanceStatus == ActivityAttendanceStatus.joined) {
        } else {
          floatingActionButton = FloatingActionButton.extended(
            backgroundColor: Colors.green,
            onPressed: () async {
              await joinEvent(context);
            },
            label: Text(
              'Sign up for this Activity',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            ),
          );
        }
        var joinRequestCount = 0;
        if (isAdmin) {
          joinRequestCount = activity.attendeeConnections
              .where((con) =>
                  con.attendanceStatus + 1 ==
                  ActivityAttendanceStatus.requested.index)
              .length;
        }
        return WillPopScope(
          onWillPop: () async => !_absorbing,
          child: AbsorbPointer(
            absorbing: _absorbing,
            child: Stack(
              children: [
                Scaffold(
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: floatingActionButton,
                  appBar: AppBar(
                    actions: [
                      if (isAdmin)
                        TextButtonTheme(
                          data: TextButtonThemeData(
                              style: TextButton.styleFrom(
                            primary: Colors.black,
                          )),
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ManageActivityPage(widget.activityId)));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (joinRequestCount > 0)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: ShapeDecoration(
                                            shape: CircleBorder(),
                                            color: Colors.red),
                                        child: Center(
                                            child: Text(
                                          joinRequestCount.toString(),
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.edit),
                                  ),
                                ],
                              )),
                        )
                    ],
                    title: Text('Activity details'),
                    bottom: isAttending
                        ? PreferredSize(
                            preferredSize: tabBar.preferredSize,
                            child: DefaultTabController(
                              length: 2,
                              initialIndex: _tabIndex,
                              child: tabBar,
                            ),
                          )
                        : null,
                  ),
                  body: IndexedStack(
                    index: _tabIndex,
                    children: [
                      if (isAttending) ChatPage(false, widget.activityId),
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
                          if (isAttending)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, top: 10),
                                  child: Text(
                                    'Participants',
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
                                      ...activity.attendeeConnections
                                          .where((ua) =>
                                              ua.attendanceStatus + 1 ==
                                              ActivityAttendanceStatus
                                                  .joined.index)
                                          .map(
                                        (ua) {
                                          final user = ua.user;
                                          return Column(
                                            children: [
                                              if (isAdmin)
                                                Container(
                                                  height: 100,
                                                  width: 100,
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.blueGrey,
                                                          maxRadius: 35,
                                                          backgroundImage:
                                                              user.photo,
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: IconButton(
                                                          iconSize: 25,
                                                          icon: Container(
                                                            height: 25,
                                                            width: 25,
                                                            decoration:
                                                                ShapeDecoration(
                                                              shape:
                                                                  CircleBorder(),
                                                              color: Colors
                                                                  .blueGrey,
                                                            ),
                                                            child: Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onPressed: () {
                                                            showCupertinoDialog(
                                                                barrierDismissible:
                                                                    true,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                          title:
                                                                              Text('Do you want to remove "${user.name}"?'),
                                                                          actions: [
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                                removeUser(context, user.id);
                                                                              },
                                                                              child: Text('Yes', textScaleFactor: 1.4),
                                                                            ),
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Text(
                                                                                  'No',
                                                                                  textScaleFactor: 1.4,
                                                                                ))
                                                                          ],
                                                                        ));
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              else
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Colors.blueGrey,
                                                  maxRadius: 35,
                                                  backgroundImage: user.photo,
                                                ),
                                              Text(user.name)
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          if (!isAttending)
                            const SizedBox(
                              height: 60,
                            )
                        ],
                      ),
                    ],
                  ),
                ),
                if (_loading)
                  SafeArea(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
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
