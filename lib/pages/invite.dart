import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/member_card.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/user_profile.dart';

class InvitePage extends StatefulWidget {
  InvitePage(this.activity) : super();
  final Activity activity;
  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = AppUser.of(context).hydrate();

    return Scaffold(
      appBar: AppBar(
        title: Text('Invite Friends'),
      ),
      body: ListView(
        children: [
          ...currentUser.following
              .where((u) => !widget.activity.attendees.contains(u))
              .map((e) => MemberCard(e, '', 'Invite',
                  (UserProfile u) => widget.activity.attendees.contains(u)))
        ],
      ),
    );
  }
}
