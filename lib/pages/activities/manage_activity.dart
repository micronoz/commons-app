import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/components/member_request_card.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/pages/activities/activity_join_requests.dart';

class ManageActivityPage extends StatefulWidget {
  final String activityId;
  final Function callback;
  ManageActivityPage(this.activityId, {Key key, this.callback})
      : super(key: key);

  @override
  _ManageActivityPageState createState() => _ManageActivityPageState();
}

class _ManageActivityPageState extends State<ManageActivityPage> {
  var _tabIndex = 0;
  final tabs = <Tab>[
    Tab(
      icon: Icon(Icons.group),
      text: 'Requests',
    ),
    Tab(icon: Icon(Icons.edit_attributes), text: 'Edit details'),
  ];

  @override
  Widget build(BuildContext context) {
    print(widget.activityId);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Activity'),
        bottom: PreferredSize(
          preferredSize: tabBar.preferredSize,
          child: DefaultTabController(
            length: 2,
            initialIndex: _tabIndex,
            child: tabBar,
          ),
        ),
      ),
      body: IndexedStack(
        index: _tabIndex,
        children: [ActivityJoinRequestsPage(widget.activityId)],
      ),
    );
  }
}
