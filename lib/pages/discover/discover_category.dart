import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/components/event_card_small.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/activity_types.dart';
import 'package:tribal_instinct/pages/discover/discover_filter.dart';

class DiscoverCategoryPage extends StatefulWidget {
  DiscoverCategoryPage(this._discoverQuery, this._queryVariables,
      this._queryName, this._categoryNames, this._mediumType,
      {Key key})
      : super(key: key);
  final List<String> _categoryNames;
  final String _discoverQuery;
  final String _queryName;
  final Map<String, dynamic> _queryVariables;
  final ActivityMedium _mediumType;

  @override
  _DiscoverCategoryPageState createState() => _DiscoverCategoryPageState();
}

class _DiscoverCategoryPageState extends State<DiscoverCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          DiscoverFilter(widget._categoryNames),
          Query(
            key: UniqueKey(),
            options: QueryOptions(
              document: gql(widget._discoverQuery),
              variables: widget._queryVariables,
            ),
            builder: (QueryResult result,
                {VoidCallback refetch, FetchMore fetchMore}) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return Text('Loading');
              }
              List activities = result.data[widget._queryName];
              if (activities.isEmpty) {
                return Text(
                    'There are currently no events matching your criteria.');
              }
              return ListView.builder(
                  itemCount: activities.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final fetchedActivity = activities[index];
                    if (widget._mediumType == ActivityMedium.in_person) {
                      final activity =
                          Activity.fromJson(fetchedActivity['activity']);
                      var distance = fetchedActivity['distance'];
                      if (distance.runtimeType == int) {
                        distance = distance.toDouble();
                      }
                      return EventCardSmall(activity, distance: distance);
                    } else {
                      final activity = Activity.fromJson(fetchedActivity);
                      return EventCardSmall(activity);
                    }
                  });
            },
          ),
        ],
      ),
    );
  }
}
