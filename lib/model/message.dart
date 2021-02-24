import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tribal_instinct/managers/user_manager.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/app_user.dart';

class Message {
  final String content;
  final DateTime timestamp;
  final AppUser sender;
  final Activity activity;
  bool isSender; //TODO remove

  Message._(
      {this.content,
      this.timestamp,
      this.sender,
      this.activity,
      this.isSender});

  static Message createMessage(
      BuildContext context, String content, Activity activity) {
    final myMessage = Message._(
        content: content,
        timestamp: DateTime.now(),
        sender: AppUser.of(context),
        activity: activity);
    return myMessage;
  }

  static List<Message> createRandomChat({int count = 10}) {
    final generator = Random.secure();
    final results = List<Message>.empty(growable: true);
    for (var i = 0; i < count; i++) {
      final timestamp = DateTime(generator.nextInt(2021));
      var myMessage = Message._(
          isSender: generator.nextBool(),
          timestamp: timestamp,
          content: 'Lorem ipsum bullshit ${timestamp}',
          activity: null,
          sender: null);
      results.add(myMessage);
    }
    results
        .sort((first, second) => second.timestamp.compareTo(first.timestamp));
    return results;
  }
}
