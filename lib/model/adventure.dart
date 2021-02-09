import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/adventure_types.dart';
import 'package:tribal_instinct/model/organizer.dart';

class Adventure {
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
  final Organizer organizer;
  final AdventureHost hostType;
  final AdventureMedium mediumType;

  Adventure(
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
  );

  static Adventure getDefault() {
    return Adventure(
        '1',
        'Book club meeting',
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut massa eu tellus pretium porttitor eu eu nunc. Aenean convallis, quam ut porttitor facilisis, nisl ipsum rhoncus dolor, id tempus lacus diam ac urna. Duis ut gravida magna. Aliquam erat volutpat. Pellentesque ut nibh mattis, aliquam dolor sed, condimentum quam. Phasellus elit turpis, interdum ac accumsan eget, rutrum ultricies est. Etiam in urna pharetra, lacinia leo eu, interdum sem. Aliquam nisi ipsum, pretium a blandit a, malesuada et lacus.',
        'https://i.imgur.com/pHI6aOe.jpg',
        'Free',
        'Peet\'s coffee',
        5,
        50,
        DateTime.now(),
        [AppUser(), AppUser()],
        AppUser(),
        AdventureHost.hosted,
        AdventureMedium.in_person);
  }
}
