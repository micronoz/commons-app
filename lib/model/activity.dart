import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/activity_types.dart';

class Activity {
  final String id;
  final String title;
  final String description;
  final ActivityMedium mediumType;
  final String location;
  final DateTime dateTime;
  final int maxGroupSize;
  final String visibility;
  final bool requireApproval;
  final String photoUrl;
  final bool isMatching;
  final int matchingSize;
  final String price;
  final Set<AppUser> attendees;
  final Set<AppUser> invitees;
  final AppUser organizer;
  // final ActivityHost hostType;

  Activity(
    this.id,
    this.title,
    this.description,
    this.photoUrl,
    this.price,
    this.mediumType,
    this.location,
    this.maxGroupSize,
    this.visibility,
    this.requireApproval,
    this.dateTime,
    this.attendees,
    this.invitees,
    this.organizer,
    this.isMatching,
    this.matchingSize,
    // this.hostType,
  );

  static Activity getDefault() {
    return Activity(
      '1',
      'Book club meeting',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut massa eu tellus pretium porttitor eu eu nunc. Aenean convallis, quam ut porttitor facilisis, nisl ipsum rhoncus dolor, id tempus lacus diam ac urna. Duis ut gravida magna. Aliquam erat volutpat. Pellentesque ut nibh mattis, aliquam dolor sed, condimentum quam. Phasellus elit turpis, interdum ac accumsan eget, rutrum ultricies est. Etiam in urna pharetra, lacinia leo eu, interdum sem. Aliquam nisi ipsum, pretium a blandit a, malesuada et lacus.',
      'https://i.imgur.com/pHI6aOe.jpg',
      'Free',
      ActivityMedium.in_person,
      'Peet\'s coffee',
      10,
      'Invite Only',
      false,
      DateTime.now(),
      {AppUser(), AppUser(), AppUser(), AppUser()},
      {},
      AppUser(),
      false,
      null,
      // ActivityHost.hosted
    );
  }
}
