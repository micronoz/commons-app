// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  
  return Message(
    message: json['message'] as String,
    timestamp: Message._dateTimeFromJson(json['createdAt'] as String),
    sender: UserProfile.fromJson(json['sender'] as Map<String, dynamic>),
    activity: json['activity'] == null
        ? null
        : Activity.fromJson(json['activity'] as Map<String, dynamic>),
  )..isSender = json['isSender'] as bool;
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'message': instance.message,
      'createdAt': Message._dateTimeToJson(instance.timestamp),
      'sender': instance.sender,
      'activity': instance.activity,
      'isSender': instance.isSender,
    };
