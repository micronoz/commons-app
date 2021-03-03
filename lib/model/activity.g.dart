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
    _$enumDecodeNullable(_$ActivityMediumEnumMap, json['mediumType']),
    json['address'] as String,
    Activity._loctionFromJson(json['location'] as Map<String, dynamic>),
    Activity._dateTimeFromJson(json['eventDateTime'] as String),
    (json['attendees'] as List)
            ?.map((e) => e == null
                ? null
                : UserProfile.fromJson(e as Map<String, dynamic>))
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
      'address': instance.address,
      'location': Activity._locationToJson(instance.location),
      'eventDateTime': Activity._dateTimeToJson(instance.dateTime),
      'attendees': instance.attendees?.toList(),
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

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ActivityMediumEnumMap = {
  ActivityMedium.online: 'online',
  ActivityMedium.in_person: 'in_person',
};
