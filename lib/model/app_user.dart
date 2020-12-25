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
    if (!["", null].contains(photoUrl))
      this.photo = NetworkImage(
        photoUrl,
        // loadingBuilder: (context, child, progress) {
        //   if (progress == null) return child;
        //   return Center(
        //     child: CircularProgressIndicator(
        //       value: progress.expectedTotalBytes != null
        //           ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes
        //           : null,
        //     ),
        //   );
        // },
      );
    else
      this.photo = AssetImage('assets/profile_photo.png');
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
    // return AppUser._(
    //     json['id'], json['name'], json['photoUrl'], json['summary']);

    return AppUser._(json['id'], "Nabi", "", "Hello my name is Nabi");
  }

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}
