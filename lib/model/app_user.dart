import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AppUser extends ChangeNotifier {
  final String id;
  String name;
  ImageProvider photo;
  String summary;
  Position location;
  String address;

  AppUser._(this.id, this.name, photoUrl, this.summary) {
    this.photo = NetworkImage(
      photoUrl,
    );
  }

  void updateUserPosition() async {
    print('Updating position');
    location = await Geolocator.getCurrentPosition();
    print(location.toJson());
    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    address =
        '${placemarks.first?.subAdministrativeArea}, ${placemarks.first?.administrativeArea}';
  }

  static AppUser fromJson(Map<String, dynamic> json) {
    //TODO Parse json
    return AppUser._(json['id'], "Nabi", "https://picsum.photos/250?image=11",
        "Hello my name is Nabi");
  }

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}
