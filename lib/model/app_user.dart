import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/organizer.dart';

class AppUser extends ChangeNotifier implements Organizer {
  final String id;
  String name;
  @override
  String identifier;
  ImageProvider photo;
  String description;
  Position location;
  String address;
  Set<AppUser> followers;
  Set<AppUser> following;
  Set<Activity> activities;

  AppUser._(
      this.id, this.name, this.identifier, String photoUrl, this.description) {
    photo = NetworkImage(
      photoUrl,
    );
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
    //TODO Parse json
    return AppUser._(
        json['id'],
        'Nabi',
        'nozberkman',
        'https://picsum.photos/250?image=11',
        'Hello my name is Nabi. I\'m from Cyprus and this is the new app I created for bringing people together.');
  }

  AppUser() : id = '1' {
    name = 'Nabi';
    identifier = 'nozberkman';
    description =
        'Hello my name is Nabi. I\'m from Cyprus and this is the new app I created for bringing people together.';
    photo = NetworkImage('https://picsum.photos/250?image=11');
  }

  AppUser hydrate() {
    following = {AppUser(), AppUser()};
    return this;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
      };

  @override
  bool operator ==(Object other) {
    if (other is AppUser) {
      return (id == other.id);
    } else {
      return false;
    }
  }

  @override
  int get hashCode => id.hashCode;
}
