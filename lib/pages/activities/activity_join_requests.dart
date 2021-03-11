import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/components/member_request_card.dart';
import 'package:tribal_instinct/model/activity.dart';

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
      user {
        id
        fullName
        handle
      }
    }
  }
''';

final rejectActivityRequestMutation = r'''
  mutation RejectActivityRequest($userId: String!, $activityId: String!) {
    rejectJoinRequest(userId: $userId, activityId: $activityId) {
      id
      attendanceStatus
      user {
        id
        fullName
        handle
      }
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
  Function _refetchA;
  Function _refetchB;
  Future setStatus(BuildContext context, String userId, String mutation) async {
    final client = GraphQLProvider.of(context).value;
    await client.mutate(
      MutationOptions(
          cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
          document: gql(mutation),
          variables: {'userId': userId, 'activityId': widget.activityId},
          onError: (error) => print(error.toString()),
          onCompleted: (something) {
            _refetchA();
            _refetchB();
          }),
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
            options: WatchQueryOptions(
                document: gql(getActivityRequestsQuery),
                variables: {'id': widget.activityId, 'status': 0},
                fetchPolicy: FetchPolicy.cacheAndNetwork),
            builder: (result, {fetchMore, refetch}) {
              _refetchA = refetch;
              if (result.hasException) {
                print(
                    'Exception has occurred in ManageActivityPage: ${result.exception}');
              }
              if (result.isConcrete) {
                final activity = Activity.fromJson(result.data['activity']);

                if (activity.attendees.isNotEmpty) {
                  return Column(
                    children: activity.attendees
                        .map((user) => MemberRequestCard(user, (bool accept) {
                              if (accept) {
                                setStatus(context, user.id,
                                    acceptActivityRequestMutation);
                              } else {
                                setStatus(context, user.id,
                                    rejectActivityRequestMutation);
                              }
                            }))
                        .toList(),
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
            options: WatchQueryOptions(
                document: gql(getActivityRequestsQuery),
                variables: {'id': widget.activityId, 'status': 2},
                fetchPolicy: FetchPolicy.cacheAndNetwork),
            builder: (result, {fetchMore, refetch}) {
              _refetchB = refetch;
              if (result.hasException) {
                print(
                    'Exception has occurred in ManageActivityPage: ${result.exception}');
              }
              if (result.isConcrete) {
                final activity = Activity.fromJson(result.data['activity']);
                if (activity.attendees.isNotEmpty) {
                  return Column(
                    children: activity.attendees
                        .map((user) => MemberRequestCard(
                              user,
                              () {
                                setStatus(context, user.id,
                                    acceptActivityRequestMutation);
                              },
                              isRejected: true,
                            ))
                        .toList(),
                  );
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
