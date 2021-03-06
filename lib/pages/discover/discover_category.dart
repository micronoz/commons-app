import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/components/event_card_small.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/pages/discover/discover_filter.dart';

class DiscoverCategoryPage extends StatefulWidget {
  DiscoverCategoryPage(this._discoverQuery, this._queryVariables,
      this._queryName, this._categoryNames,
      {Key key})
      : super(key: key);
  final List<String> _categoryNames;
  final String _discoverQuery;
  final String _queryName;
  final Map<String, dynamic> _queryVariables;

  @override
  _DiscoverCategoryPageState createState() => _DiscoverCategoryPageState();
}

class _DiscoverCategoryPageState extends State<DiscoverCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          DiscoverFilter(widget._categoryNames),
          Query(
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
