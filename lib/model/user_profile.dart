import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  final String id;
  @JsonKey(name: 'fullName')
  final String name;
  final String firstName;
  final String lastName;
  final String handle;
  final String photoUrl;
  @JsonKey(ignore: true)
  ImageProvider photo;
  final String bio;

  UserProfile(this.id, this.name, this.handle, this.bio, this.photoUrl,
      this.firstName, this.lastName) {
    photo = NetworkImage(photoUrl ?? 'https://picsum.photos/250?image=11');
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  UserProfile.mock()
      : id = '1',
        name = 'Nabi',
        firstName = 'Nabi',
        lastName = 'Oz',
        handle = 'nozberkman',
        bio =
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
