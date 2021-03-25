import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/components/event_card_small.dart';
import 'package:tribal_instinct/managers/activity_manager.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/pages/activities/create_activity.dart';
import 'package:tribal_instinct/pages/discover/discover.dart';
import 'package:provider/provider.dart';

final getMyActivitiesQuery = '''
  query {
    user {
      ...activityConnectionFields
    }
  }

  fragment activityConnectionFields on User {
    activityConnections {
      ...activityFields
    }
  }

  fragment activityFields on UserActivity {
    id
    isOrganizing
    attendanceStatus
    activity {
      id
      title
      eventDateTime
      organizer {
        id
        handle
      }
      description
    }
  }
''';

class ActivitiesPage extends StatefulWidget {
  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  ActivityManager activityManager;
  @override
  Widget build(BuildContext context) {
    return Consumer<ActivityManager>(builder: (context, manager, child) {
      final key = UniqueKey();
      var queryBody = Query(
          key: key,
          options: WatchQueryOptions(
            fetchResults: true,
            eagerlyFetchResults: true,
            document: gql(getMyActivitiesQuery),
            fetchPolicy: FetchPolicy.cacheAndNetwork,
          ),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.isLoading && !result.isConcrete) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final activities =
                (result.data['user']['activityConnections'] as List<dynamic>)
                    .map((a) => Activity.fromJson(a['activity']));
            return ListView(
              children: [
                Text(
                  'I\'m hosting',
                  style: Theme.of(context).textTheme.headline1,
                  textScaleFactor: 0.4,
                ),
                ...activities.map((a) => EventCardSmall(a)),
                Text(
                  'I\'m attending',
                  style: Theme.of(context).textTheme.headline1,
                  textScaleFactor: 0.4,
                ),
                Text(
                  'Past',
                  style: Theme.of(context).textTheme.headline1,
                  textScaleFactor: 0.4,
                ),
              ],
            );
          });

      return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateActivityPage())),
                  icon: Icon(Icons.add_rounded))
            ],
            title: Text('My Activities'),
          ),
          body: queryBody);
    });
  }
}
