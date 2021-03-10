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

class ManageActivityPage extends StatefulWidget {
  final String activityId;
  ManageActivityPage(this.activityId, {Key key}) : super(key: key);

  @override
  _ManageActivityPageState createState() => _ManageActivityPageState();
}

class _ManageActivityPageState extends State<ManageActivityPage> {
  Function refetch;

  Future setStatus(BuildContext context, String userId, String mutation) async {
    final client = GraphQLProvider.of(context).value;
    await client.mutate(
      MutationOptions(
          document: gql(mutation),
          variables: {'userId': userId, 'activityId': widget.activityId},
          onError: (error) => print(error.toString()),
          onCompleted: (something) => refetch()),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.activityId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Activity'),
      ),
      body: Query(
          options: WatchQueryOptions(
              document: gql(getActivityRequestsQuery),
              variables: {'id': widget.activityId, 'status': 0},
              fetchPolicy: FetchPolicy.cacheAndNetwork),
          builder: (result, {fetchMore, refetch}) {
            this.refetch = refetch;
            if (result.hasException) {
              print(
                  'Exception has occurred in ManageActivityPage: ${result.exception}');
            }
            if (result.isConcrete) {
              final activity = Activity.fromJson(result.data['activity']);

              return ListView(
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
            }
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }),
    );
  }
}
