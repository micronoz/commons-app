// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  return Activity(
    json['id'] as String,
    json['title'] as String,
    json['description'] as String,
    _$enumDecode(_$ActivityMediumEnumMap, json['mediumType']),
    json['physicalAddress'] as String,
    json['eventUrl'] as String,
    Activity._locationFromJson(
        json['discoveryCoordinates'] as Map<String, dynamic>),
    Activity._dateTimeFromJson(json['eventDateTime'] as String),
    (json['userConnections'] as List)
            ?.map((e) => e == null
                ? null
                : UserActivity.fromJson(e as Map<String, dynamic>))
            ?.toSet() ??
        {},
    json['organizer'] == null
        ? null
        : UserProfile.fromJson(json['organizer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'mediumType': _$ActivityMediumEnumMap[instance.mediumType],
      'physicalAddress': instance.physicalAddress,
      'eventUrl': instance.eventUrl,
      'discoveryCoordinates':
          Activity._locationToJson(instance.discoveryCoordinates),
      'eventDateTime': Activity._dateTimeToJson(instance.dateTime),
      'userConnections': instance.attendeeConnections?.toList(),
      'organizer': instance.organizer,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

const _$ActivityMediumEnumMap = {
  ActivityMedium.online: 'online',
  ActivityMedium.in_person: 'in_person',
};
