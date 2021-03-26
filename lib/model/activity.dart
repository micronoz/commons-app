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
  @JsonKey(nullable: false)
  final ActivityMedium mediumType;
  final String physicalAddress;
  final String eventUrl;
  @JsonKey(fromJson: _locationFromJson, toJson: _locationToJson)
  final Position discoveryCoordinates;
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

  bool get isOnline {
    return mediumType == ActivityMedium.online;
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
}
