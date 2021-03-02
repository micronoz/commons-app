import 'package:geolocator/geolocator.dart';
import 'package:tribal_instinct/model/activity_types.dart';
import 'user_profile.dart';

class Activity {
  final String id;
  final String title;
  final String description;
  final ActivityMedium mediumType;
  final String address;
  final Position location;
  final DateTime dateTime;
  final Set<UserProfile> attendees;
  final UserProfile organizer;

  Activity(
    this.id,
    this.title,
    this.description,
    this.mediumType,
    this.address,
    this.location,
    this.dateTime,
    this.attendees,
    this.organizer,
  );

  static Activity fromJSON(Map<String, dynamic> json) {
    ActivityMedium mediumType;
    switch (json['mediumType']) {
      case 'in_person':
        mediumType = ActivityMedium.in_person;
        break;
      case 'online':
        mediumType = ActivityMedium.online;
        break;
      default:
        throw Exception('Medium Type not an expected string.');
    }
    final fetchedEventTime = json['eventDateTime'];
    var dateTime;
    if (fetchedEventTime != null) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(json['eventDateTime']),
          isUtc: true);
    }
    // print(json['location']);
    var x = json['location']['x'];
    var y = json['location']['y'];
    if (x.runtimeType == int) {
      x = x.toDouble();
    }
    if (y.runtimeType == int) {
      y = y.toDouble();
    }
    final location = Position(longitude: x, latitude: y);
    return Activity(
      json['id'],
      json['title'],
      json['description'],
      mediumType,
      json['address'],
      location,
      dateTime,
      //TODO: Get attendees and organizer
      {
        UserProfile.mock(),
        UserProfile.mock(),
        UserProfile.mock(),
      },
      UserProfile.mock(),
    );
  }

  static Activity getDefault() {
    return Activity(
      '1',
      'Book club meeting',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut massa eu tellus pretium porttitor eu eu nunc. Aenean convallis, quam ut porttitor facilisis, nisl ipsum rhoncus dolor, id tempus lacus diam ac urna. Duis ut gravida magna. Aliquam erat volutpat. Pellentesque ut nibh mattis, aliquam dolor sed, condimentum quam. Phasellus elit turpis, interdum ac accumsan eget, rutrum ultricies est. Etiam in urna pharetra, lacinia leo eu, interdum sem. Aliquam nisi ipsum, pretium a blandit a, malesuada et lacus.',
      ActivityMedium.in_person,
      'Peet\'s coffee',
      Position(latitude: 4.8, longitude: 5),
      DateTime.now(),
      {
        UserProfile.mock(),
        UserProfile.mock(),
        UserProfile.mock(),
      },
      UserProfile.mock(),
    );
  }
}
