import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/activity_types.dart';

class Activity {
  final String id;
  final String title;
  final String description;
  final ActivityMedium mediumType;
  final String location;
  final DateTime dateTime;
  final Set<AppUser> attendees;
  final AppUser organizer;

  Activity(
    this.id,
    this.title,
    this.description,
    this.mediumType,
    this.location,
    this.dateTime,
    this.attendees,
    this.organizer,
  );

  static Activity getDefault() {
    return Activity(
      '1',
      'Book club meeting',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut massa eu tellus pretium porttitor eu eu nunc. Aenean convallis, quam ut porttitor facilisis, nisl ipsum rhoncus dolor, id tempus lacus diam ac urna. Duis ut gravida magna. Aliquam erat volutpat. Pellentesque ut nibh mattis, aliquam dolor sed, condimentum quam. Phasellus elit turpis, interdum ac accumsan eget, rutrum ultricies est. Etiam in urna pharetra, lacinia leo eu, interdum sem. Aliquam nisi ipsum, pretium a blandit a, malesuada et lacus.',
      ActivityMedium.in_person,
      'Peet\'s coffee',
      DateTime.now(),
      {AppUser(), AppUser(), AppUser(), AppUser()},
      AppUser(),
    );
  }
}
