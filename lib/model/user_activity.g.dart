// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserActivity _$UserActivityFromJson(Map<String, dynamic> json) {
  return UserActivity(
    json['attendanceStatus'] as int,
    json['isOrganizing'] as bool,
    json['user'] == null
        ? null
        : UserProfile.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserActivityToJson(UserActivity instance) =>
    <String, dynamic>{
      'attendanceStatus': instance.attendanceStatus,
      'isOrganizing': instance.isOrganizing,
      'user': instance.user,
    };
