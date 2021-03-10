import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  final String id;
  @JsonKey(name: 'fullName')
  final String name;
  final String handle;
  final String photoUrl;
  @JsonKey(ignore: true)
  ImageProvider photo;
  final String description;

  UserProfile(
      this.id, this.name, this.handle, this.description, this.photoUrl) {
    photo = NetworkImage(photoUrl ?? 'https://picsum.photos/250?image=11');
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile.mock()
      : id = '1',
        name = 'Nabi',
        handle = 'nozberkman',
        description =
            'Hello my name is Nabi. I\'m from Cyprus and this is the new app I created for bringing people together.',
        photoUrl = 'https://picsum.photos/250?image=11';

  @override
  bool operator ==(Object other) {
    if (other is UserProfile) {
      return (id == other.id);
    } else {
      return false;
    }
  }

  @override
  int get hashCode => id.hashCode;
}
