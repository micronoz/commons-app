import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/components/event_card_small.dart';
import 'package:tribal_instinct/managers/activity_manager.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/discover_types.dart';
import 'package:tribal_instinct/pages/activities/create_activity.dart';
import 'package:tribal_instinct/pages/discover/discover.dart';
import 'package:provider/provider.dart';

final getMyActivitiesQuery = '''
  query {
    user {
      activityConnections {
        ...activityFields
        isOrganizing
        attendanceStatus
      }
    }
  }

  fragment activityFields on UserActivity {
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

class ExperiencesPage extends StatefulWidget {
  @override
  _ExperiencesPageState createState() => _ExperiencesPageState();
}

class _ExperiencesPageState extends State<ExperiencesPage> {
  var registered = false;
  var refetch;
  ActivityManager activityManager;

  @override
  void dispose() {
    super.dispose();
    activityManager.removeListener(refetch);
  }

  @override
  Widget build(BuildContext context) {
    activityManager = context.read<ActivityManager>();
    if (!registered && refetch != null) {
      context.read<ActivityManager>().addListener(refetch);
      registered = true;
    }
    return Consumer<ActivityManager>(builder: (context, manager, child) {
      print('Rebuilding activities page');
      return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateActivityPage())),
                  icon: Icon(Icons.add_rounded))
            ],
            title: Text('Experiences'),
          ),
          body: Query(
              key: Key('activitiesQuery'),
              options: WatchQueryOptions(
                fetchResults: true,
                eagerlyFetchResults: true,
                document: gql(getMyActivitiesQuery),
                cacheRereadPolicy: CacheRereadPolicy.ignoreAll,
                fetchPolicy: FetchPolicy.cacheAndNetwork,
              ),
              builder: (QueryResult result, {fetchMore, refetch}) {
                if (result.isLoading && !result.isConcrete) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                print(result);
                refetch = refetch;

                final activities = (result.data['user']['activityConnections']
                        as List<dynamic>)
                    .map((a) => Activity.fromJson(a['activity']));
                return ListView(
                  children: [
                    Container(
                      child: Align(
                        heightFactor: 1.5,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Colors.blue[400],
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    DiscoverPage(DiscoverType.experiences)));
                          },
                          child: Text(
                            'Discover Events',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
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
              }));
    });
  }
}
