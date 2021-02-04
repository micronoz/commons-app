import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/reu_types.dart';

class Reu {
  final String id;
  final String title;
  final String description;
  final String photoUrl;
  final String price;
  final String location;
  final int groupSize;
  final int cohortSize;
  final DateTime dateTime;
  final List<AppUser> attendees;
  final AppUser organizer;
  final ReuHost hostType;
  final ReuMedium mediumType;
  final ReuGroup groupType;

  Reu(
      this.id,
      this.title,
      this.description,
      this.photoUrl,
      this.price,
      this.location,
      this.groupSize,
      this.cohortSize,
      this.dateTime,
      this.attendees,
      this.organizer,
      this.hostType,
      this.mediumType,
      this.groupType);
}
