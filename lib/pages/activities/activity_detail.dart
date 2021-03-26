import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/activity_attendance_status.dart';
import 'package:tribal_instinct/model/activity_types.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/pages/activities/manage_activity.dart';
import 'package:tribal_instinct/pages/chat.dart';
import 'package:url_launcher/url_launcher.dart';

final getActivityQuery = r'''
  query GetActivity($id: String!) {
    activity(id: $id) {
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
    await GraphQLProvider.of(context).value.mutate(MutationOptions(
        document: gql(requestToJoinActivity),
        variables: {'id': widget.activityId}));
    await _refetch();
    setState(() {
      _loading = false;
    });
  }

  Future removeUser(BuildContext context, String userId) async {
    final client = GraphQLProvider.of(context).value;
    await client.mutate(MutationOptions(
      document: gql(removeUserFromActivityMutation),
      variables: {'userId': userId, 'activityId': widget.activityId},
      onError: (error) => print(error.toString()),
    ));
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

          Timer(Duration(seconds: 2), () async {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                title: Text('An error has occured...'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  )
                ],
              ),
            ).then((value) => Navigator.of(context).pop());
          });
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

        var isAttending = attendanceStatus == ActivityAttendanceStatus.joined;
        final isAdmin =
            currentUser.profile == activity.organizer && isAttending;

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
            onPressed: () {},
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

        final isOnline = activity.mediumType == ActivityMedium.online;

        return WillPopScope(
          onWillPop: () async => !_absorbing,
          child: AbsorbPointer(
            absorbing: _absorbing,
            child: Stack(
              children: [
                Scaffold(
                  key: _scaffoldKey,
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
                                ? 'in person'
                                : 'online'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText1,
                            textScaleFactor: 1.5,
                          ),
                          if (activity.physicalAddress?.isNotEmpty ?? false)
                            Center(
                              child: TextButton(
                                onLongPress: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text: isOnline
                                          ? activity.eventUrl
                                          : activity.physicalAddress));
                                  final sheet = _scaffoldKey.currentState
                                      .showBottomSheet<void>(
                                          (context) => BottomSheet(
                                              onClosing: () {},
                                              builder: (context) => Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 40,
                                                    color: Colors.blueGrey[100],
                                                    child: Center(
                                                      child: Text(
                                                        'Copied to cliboard',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ),
                                                  )));

                                  Timer(Duration(seconds: 1, milliseconds: 500),
                                      () => sheet.close());
                                },
                                child: Linkify(
                                  options: LinkifyOptions(looseUrl: true),
                                  textWidthBasis: TextWidthBasis.longestLine,
                                  // textAlign: TextAlign.center,
                                  text: (activity.mediumType ==
                                          ActivityMedium.in_person
                                      ? (activity.physicalAddress ?? '')
                                      : (activity.eventUrl ?? '')),
                                  onOpen: (link) async {
                                    print(link.url);
                                    if (await canLaunch(link.url)) {
                                      await launch(link.url);
                                    } else {
                                      throw 'Could not launch $link';
                                    }
                                  },
                                  linkStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                  textScaleFactor: 1.5,
                                ),
                              ),
                            ),
                          if (activity.dateTime != null)
                            Text(
                              'on ' +
                                  _format.format(activity.dateTime.toLocal()),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1,
                              textScaleFactor: 1.5,
                            ),
                          if (activity.description != null) ...[
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                activity.description,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .apply(fontSizeFactor: 1.2),
                              ),
                            )
                          ],
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
                                              Container(
                                                height: 100,
                                                width: 100,
                                                child: Stack(
                                                  children: [
                                                    Center(
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            Colors.blueGrey,
                                                        maxRadius: 40,
                                                        backgroundImage:
                                                            user.photo,
                                                      ),
                                                    ),
                                                    if (isAdmin &&
                                                        user !=
                                                            currentUser.profile)
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
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                title: Text(
                                                                    'Do you want to remove "${user.name}(@${user.handle})"?'),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      removeUser(
                                                                          context,
                                                                          user.id);
                                                                    },
                                                                    child: Text(
                                                                        'Yes',
                                                                        textScaleFactor:
                                                                            1.4),
                                                                  ),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'No',
                                                                        textScaleFactor:
                                                                            1.4,
                                                                      ))
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      )
                                                  ],
                                                ),
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
