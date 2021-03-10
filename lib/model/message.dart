import 'dart:math';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/user_profile.dart';

part 'message.g.dart';

@JsonSerializable(nullable: false)
class Message {
  final String message;
  @JsonKey(
    name: 'createdAt',
    fromJson: _dateTimeFromJson,
    toJson: _dateTimeToJson,
  )
  final DateTime timestamp;
  final UserProfile sender;
  @JsonKey(nullable: true)
  final Activity activity;
  final String id;
  bool isSender;

  Message({this.message, this.timestamp, this.sender, this.activity, this.id});

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  static Message createMessage(
      BuildContext context, String content, Activity activity) {
    final myMessage = Message(
        message: content,
        timestamp: DateTime.now(),
        sender: AppUser.of(context).profile,
        activity: activity);
    return myMessage;
  }

  static DateTime _dateTimeFromJson(String json) {
    if (json == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(int.parse(json), isUtc: true);
  }

  static String _dateTimeToJson(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  @override
  bool operator ==(Object other) {
    if (other is Message) {
      return (id == other.id);
    } else {
      return false;
    }
  }

  @override
  int get hashCode => id.hashCode;
}
