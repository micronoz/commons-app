import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tribal_instinct/model/activity_types.dart';
import 'package:tribal_instinct/model/user_activity.dart';
import 'user_profile.dart';

part 'activity.g.dart';

//TODO: Separate PhysicalActivity and Online Activity maybe
@JsonSerializable()
class Activity {
  final String id;
  final String title;
  final String description;
  final ActivityMedium mediumType;
  final String physicalAddress;
  final String eventUrl;
  @JsonKey(fromJson: _locationFromJson, toJson: _locationToJson)
  final Position discoveryCoordinates;
  @JsonKey(fromJson: _locationFromJson, toJson: _locationToJson)
  final Position eventCoordinates;
  @JsonKey(
      name: 'eventDateTime',
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson)
  final DateTime dateTime;
  @JsonKey(defaultValue: {}, name: 'userConnections')
  final Set<UserActivity> attendeeConnections;
  Set<UserProfile> _attendeeSet;
  Set<UserProfile> get attendees {
    _attendeeSet ??= attendeeConnections?.map((e) => e.user)?.toSet();
    return _attendeeSet;
  }

  final UserProfile organizer;

  Activity(
    this.id,
    this.title,
    this.description,
    this.mediumType,
    this.physicalAddress,
    this.eventUrl,
    this.discoveryCoordinates,
    this.eventCoordinates,
    this.dateTime,
    this.attendeeConnections,
    this.organizer,
  );

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  static Position _locationFromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Position(
        longitude: json['x']?.toDouble(), latitude: json['y']?.toDouble());
  }

  static Map<String, double> _locationToJson(Position location) {
    return {'x': location?.latitude, 'y': location?.longitude};
  }

  static DateTime _dateTimeFromJson(String json) {
    if (json == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(int.parse(json), isUtc: true);
  }

  static String _dateTimeToJson(DateTime dateTime) {
    return dateTime?.toIso8601String();
  }

  static Activity getDefault() {
    return Activity(
      '1',
      'Book club meeting',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut massa eu tellus pretium porttitor eu eu nunc. Aenean convallis, quam ut porttitor facilisis, nisl ipsum rhoncus dolor, id tempus lacus diam ac urna. Duis ut gravida magna. Aliquam erat volutpat. Pellentesque ut nibh mattis, aliquam dolor sed, condimentum quam. Phasellus elit turpis, interdum ac accumsan eget, rutrum ultricies est. Etiam in urna pharetra, lacinia leo eu, interdum sem. Aliquam nisi ipsum, pretium a blandit a, malesuada et lacus.',
      ActivityMedium.in_person,
      'Peet\'s coffee',
      null,
      Position(latitude: 42.37003, longitude: -71.11666),
      null,
      DateTime.now(),
      {
        // UserProfile.mock(),
        // UserProfile.mock(),
        // UserProfile.mock(),
      },
      UserProfile.mock(),
    );
  }
}
