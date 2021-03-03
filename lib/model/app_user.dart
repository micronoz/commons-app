import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/user_profile.dart';

class AppUser {
  UserProfile profile;
  Position location;
  String address;
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

  void updateUserPosition() async {
    print('Updating position');
    location = await Geolocator.getCurrentPosition();
    print(location.toJson());
    var placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    address =
        '${placemarks.first?.subAdministrativeArea}, ${placemarks.first?.administrativeArea}';
  }

  static AppUser fromJson(Map<String, dynamic> json) {
    // TODO: Also get the other fields and change the email field after
    // adding necessary fields to the database.
    final userProfile = UserProfile(
        json['id'],
        json['fullName'],
        json['handle'],
        'https://picsum.photos/250?image=11',
        'Hello my name is Nabi. I\'m from Cyprus and this is the new app I created for bringing people together.');
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
