// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return UserProfile(
      json['id'] as String,
      json['fullName'] as String,
      json['handle'] as String,
      json['description'] as String,
      json['photoUrl'] as String,
      json['firstName'] as String,
      json['lastName'] as String);
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.name,
      'handle': instance.handle,
      'photoUrl': instance.photoUrl,
      'description': instance.bio,
    };
