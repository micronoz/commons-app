import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/user_profile.dart';

// @JsonSerializable()
class AppUser {
  // @JsonKey(nullable: false)
  UserProfile profile;
  Position location;
  Set<UserProfile> followers;
  Set<UserProfile> following;
  Set<Activity> activities;

  AppUser._(this.profile);

  AppUser.mock() {
    profile = UserProfile.mock();
  }

  static AppUser of(BuildContext context) {
    return Provider.of<AppUser>(context, listen: false);
  }

  static AppUser fromJson(Map<String, dynamic> json) {
    // TODO: Also get the other fields and change the email field after
    // adding necessary fields to the database.
    final userProfile = UserProfile.fromJson(json);
    return AppUser._(userProfile);
  }

  AppUser hydrate() {
    following = {UserProfile.mock(), UserProfile.mock()};
    return this;
  }

  Map<String, dynamic> toJson() => {
        'id': profile.id,
      };

  @override
  bool operator ==(Object other) {
    if (other is AppUser) {
      return (profile.id == other.profile.id);
    } else {
      return false;
    }
  }

  @override
  int get hashCode => profile.id.hashCode;
}
