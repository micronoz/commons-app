import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/reu_types.dart';

class Reu {
  String id;
  String name;
  String description;
  String photoUrl;
  String price;
  List<AppUser> attendees;
  AppUser organizer;
  ReuHost hostType;
  ReuMedium mediumType;
  ReuGroup groupType;
}
