import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/components/member_request_card.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/activity_attendance_status.dart';

final getActivityRequestsQuery = r'''
  query GetActivityRequests($id: String!, $status: Int) {
    activity(id: $id) {
      id
      userConnections(status: $status) {
        id
        attendanceStatus
        user {
          id
          fullName
          handle
        }
      }
    }
  }
''';

final acceptActivityRequestMutation = r'''
  mutation AcceptActivityRequest($userId: String!, $activityId: String!) {
    acceptJoinRequest(userId: $userId, activityId: $activityId) {
      id
      attendanceStatus
    }
  }
''';

final rejectActivityRequestMutation = r'''
  mutation RejectActivityRequest($userId: String!, $activityId: String!) {
    rejectJoinRequest(userId: $userId, activityId: $activityId) {
      id
      attendanceStatus
    }
  }
''';

class ActivityJoinRequestsPage extends StatefulWidget {
  final String activityId;
  ActivityJoinRequestsPage(this.activityId) : super();
  @override
  _ActivityJoinRequestsPageState createState() =>
      _ActivityJoinRequestsPageState();
}

class _ActivityJoinRequestsPageState extends State<ActivityJoinRequestsPage> {
  Future setStatus(BuildContext context, String userId, String mutation) async {
    final client = GraphQLProvider.of(context).value;
    await client.mutate(
      MutationOptions(
          cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
          document: gql(mutation),
          variables: {'userId': userId, 'activityId': widget.activityId},
          onError: (error) => print(error.toString()),
          fetchPolicy: FetchPolicy.cacheAndNetwork),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          'Requests',
          style: Theme.of(context).textTheme.headline5,
        ),
        Query(
            key: Key('Requests'),
            options: WatchQueryOptions(
                cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
                document: gql(getActivityRequestsQuery),
                variables: {'id': widget.activityId, 'status': 0},
                fetchPolicy: FetchPolicy.cacheAndNetwork),
            builder: (result, {fetchMore, refetch}) {
              if (result.hasException) {
                print(
                    'Exception has occurred in ManageActivityPage: ${result.exception}');
              }
              if (result.isConcrete) {
                final activity = Activity.fromJson(result.data['activity']);
                final children = activity.attendeeConnections
                    .where((ua) =>
                        ua.attendanceStatus + 1 ==
                        ActivityAttendanceStatus.requested.index)
                    .map((ua) => MemberRequestCard(ua.user, (bool accept) {
                          if (accept) {
                            setStatus(context, ua.user.id,
                                acceptActivityRequestMutation);
                          } else {
                            setStatus(context, ua.user.id,
                                rejectActivityRequestMutation);
                          }
                        }))
                    .toList();
                if (children.isNotEmpty) {
                  return Column(
                    children: children,
                  );
                } else {
                  return Center(
                    child: Text(
                      'All done!',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  );
                }
              }
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }),
        Text(
          'Rejected',
          style: Theme.of(context).textTheme.headline5,
        ),
        Query(
            key: Key('Rejected'),
            options: WatchQueryOptions(
                cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
                document: gql(getActivityRequestsQuery),
                variables: {'id': widget.activityId, 'status': 2},
                fetchPolicy: FetchPolicy.cacheAndNetwork),
            builder: (result, {fetchMore, refetch}) {
              if (result.hasException) {
                print(
                    'Exception has occurred in ManageActivityPage: ${result.exception}');
              }
              if (result.isConcrete) {
                final activity = Activity.fromJson(result.data['activity']);
                final children = activity.attendeeConnections
                    .where((ua) =>
                        ua.attendanceStatus + 1 ==
                        ActivityAttendanceStatus.rejected.index)
                    .map(
                      (ua) => MemberRequestCard(
                        ua.user,
                        () {
                          setStatus(context, ua.user.id,
                              acceptActivityRequestMutation);
                        },
                        isRejected: true,
                      ),
                    )
                    .toList();
                if (children.isNotEmpty) {
                  return Column(children: children);
                } else {
                  return Center(
                    child: Text(
                      'No one here :)',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  );
                }
              }
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }),
      ],
    );
  }
}
