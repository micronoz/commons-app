import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/components/event_card_small.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/activity_types.dart';
import 'package:tribal_instinct/model/discover_types.dart';
import 'package:tribal_instinct/model/user_profile.dart';

String discoverActivitiesQuery = '''
  query DiscoverActivities {
    discoverActivities {
      id
      title
      description
      physicalAddress
      organizer {
        handle
        id
      }
      discoveryCoordinates {
        x
        y
      }
      mediumType
      eventDateTime
    }
  }
''';

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
              print('Query discovery page');
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return Text('Loading');
              }
              List activities = result.data['discoverActivities'];

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

                    final _activity = Activity.fromJson(_fetchedActivity);

                    return EventCardSmall(_activity);
                  });
            },
          ),
        ],
      ),
    );
  }
}
