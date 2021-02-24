import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/components/event_card_small.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/activity_types.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/discover_types.dart';

String discoverActivitiesQuery = """
  query DiscoverActivities {
    discoverActivities {
      title
      description
      address
      mediumType
      eventDateTime
    }
  }
""";

class DiscoverCategoryPage extends StatefulWidget {
  final DiscoverType type;
  DiscoverCategoryPage(this.type, {Key key}) : super(key: key);

  @override
  _DiscoverCategoryPageState createState() => _DiscoverCategoryPageState();
}

class _DiscoverCategoryPageState extends State<DiscoverCategoryPage> {
  final List<String> _cast = <String>[
    'All',
    'Hang Out',
    'Study',
    'Sports',
    'Other',
  ];
  final List<String> _filters = <String>[];

  Iterable<Widget> get categoryWidgets sync* {
    for (final category in _cast) {
      yield Padding(
        padding: const EdgeInsets.all(1.0),
        child: FilterChip(
          selectedColor: Colors.blue,
          showCheckmark: false,
          visualDensity: VisualDensity.comfortable,
          label: Text(category),
          selected: category == 'All'
              ? _filters.isEmpty
              : _filters.contains(category),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                if (category == 'All') {
                  _filters.clear();
                } else {
                  _filters.add(category);
                }
              } else {
                if (category != 'All') {
                  _filters.removeWhere((String name) {
                    return name == category;
                  });
                }
              }
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceEvenly,
            children: categoryWidgets.toList(),
          ),
          // ...
          Query(
            options: QueryOptions(
              document: gql(discoverActivitiesQuery),
              pollInterval: Duration(seconds: 1),
            ),
            builder: (QueryResult result,
                {VoidCallback refetch, FetchMore fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return Text('Loading');
              }
              List activities = result.data['discoverActivities'];
              print(activities);

              if (activities.isEmpty) {
                return Text(
                    'There are currently no events matching your criteria.');
              }
              return ListView.builder(
                  itemCount: activities.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final _fetchedActivity = activities[index];
                    // return Text('a');
                    final _id = _fetchedActivity['id'];
                    final _title = _fetchedActivity['title'];
                    final _description = _fetchedActivity['description'];
                    ActivityMedium _mediumType;
                    //TODO: Switch this value to an enum (or int)
                    switch (_fetchedActivity['mediumType']) {
                      case 'online':
                        _mediumType = ActivityMedium.online;
                        break;
                      case 'in_person':
                        _mediumType = ActivityMedium.in_person;
                        break;
                      default:
                        _mediumType = null;
                    }
                    final _location = _fetchedActivity['address'];
                    final _dateTime =
                        DateTime(int.parse(_fetchedActivity['eventDateTime']));
                    //TODO: Actually get attendees and organizer
                    final _activity = Activity(
                        _id,
                        _title,
                        _description,
                        _mediumType,
                        _location,
                        _dateTime,
                        {AppUser(), AppUser()},
                        AppUser());
                    return EventCardSmall(_activity);
                  });
            },
          ),
          // EventCardSmall(Activity.getDefault()),
          // EventCardSmall(Activity.getDefault()),
          // EventCardSmall(Activity.getDefault()),
        ],
      ),
    );
  }
}
