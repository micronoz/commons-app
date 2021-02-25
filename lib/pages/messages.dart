import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/message_card.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/pages/chat.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    var otherUser = AppUser.mock();
    return Scaffold(
      body: ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) => MessageCard(
          profile: otherUser.profile,
          route: (context) => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatPage(
                true,
                title: '@${otherUser.profile.identifier}',
              ),
            ),
          ),
        ),
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }
}
