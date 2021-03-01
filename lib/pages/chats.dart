import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/message_card.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/pages/chat.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    var otherUser = AppUser.mock();
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [IconButton(icon: Icon(Icons.create), onPressed: () {})],
      ),
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
        separatorBuilder: (context, index) => Divider(
          thickness: 2,
        ),
      ),
    );
  }
}
