import 'package:flutter/material.dart';
import 'package:tribal_instinct/pages/activities/manage_activity_join_requests.dart';
import 'package:tribal_instinct/pages/activities/edit_activity.dart';

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

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print(widget.activityId);
    var tabBar = TabBar(
      tabs: tabs,
      onTap: (index) => setState(() {
        _tabIndex = index;
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }),
    );
    return Scaffold(
      key: _scaffoldKey,
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
        children: [
          ManageActivityJoinRequestsPage(widget.activityId),
          EditActivityPage(widget.activityId, _scaffoldKey)
        ],
      ),
    );
  }
}
