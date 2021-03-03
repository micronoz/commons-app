// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return UserProfile(
    json['id'] as String,
    json['name'] as String,
    json['handle'] as String,
    json['description'] as String,
    json['photoUrl'] as String,
  );
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'handle': instance.handle,
      'photoUrl': instance.photoUrl,
      'description': instance.description,
    };
