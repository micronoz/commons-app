import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/components/member_card.dart';
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
  mutation AcceptActivityRequest($userId: String!) {
    
  }
''';

final rejectActivityRequestMutation = r'''
  mutation RejectActivityRequest($userId: String!) {
    
  }
''';

class ManageActivityPage extends StatefulWidget {
  final String activityId;
  ManageActivityPage(this.activityId, {Key key}) : super(key: key);

  @override
  _ManageActivityPageState createState() => _ManageActivityPageState();
}

class _ManageActivityPageState extends State<ManageActivityPage> {
  Future accept(String userId) async {}

  Future reject(String userId) async {}

  @override
  Widget build(BuildContext context) {
    print(widget.activityId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Activity'),
      ),
      body: Query(
          options: QueryOptions(
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

              return ListView(
                children: activity.attendees
                    .map((e) => MemberRequestCard(e, () {}))
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
