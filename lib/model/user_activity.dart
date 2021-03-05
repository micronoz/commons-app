import 'package:json_annotation/json_annotation.dart';
import 'package:tribal_instinct/model/user_profile.dart';

part 'user_activity.g.dart';

@JsonSerializable()
class UserActivity {
  final int attendanceStatus;
  final bool isOrganizing;
  final UserProfile user;

  UserActivity(this.attendanceStatus, this.isOrganizing, this.user);

  factory UserActivity.fromJson(Map<String, dynamic> json) =>
      _$UserActivityFromJson(json);

  Map<String, dynamic> toJson() => _$UserActivityToJson(this);
}
