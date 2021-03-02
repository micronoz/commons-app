import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'onboarding_flow.dart';

class OnboardingQuestion extends StatefulWidget {
  OnboardingQuestion({Key key, @required this.questionData}) : super(key: key);

  final QuestionData questionData;
  final formKey = GlobalKey<FormState>();

  @override
  _OnboardingQuestionState createState() => _OnboardingQuestionState();
}

class _OnboardingQuestionState extends State<OnboardingQuestion> {
  String validatedValue;
  String rejectedValue;

// this will be called upon user interaction or re-initiation as commented below
  String validateUnique(String val, GraphQLClient graphQLClient) {
    if (validatedValue == val) {
      return null;
    } else if (rejectedValue == val) {
      return 'This username is already taken.';
    } else {
      initiateAsyncUniqueValidation(val, graphQLClient);
      return 'Validating...';
    }
  }

  Future<void> initiateAsyncUniqueValidation(
      String val, GraphQLClient graphQLClient) async {
    var result = await graphQLClient.query(QueryOptions(
        document: gql(widget.questionData.uniqueCheckQuery),
        fetchPolicy: FetchPolicy.noCache,
        variables: {
          'val': val,
        }));
    final isTaken =
        result.data[widget.questionData.uniqueCheckQueryReturnField];
    if (isTaken) {
      rejectedValue = val;
    } else {
      validatedValue = val;
    }

    widget.formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    final _gqlClient = GraphQLProvider.of(context).value;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 100, bottom: 50),
          child: Text(widget.questionData.question),
        ),
        Container(
          width: 250,
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: widget.formKey,
            child: TextFormField(
              validator: (String val) {
                final validatorResult = widget.questionData.validator(val);
                if (validatorResult == null) {
                  if (widget.questionData.uniqueCheckQuery == null) {
                    return null;
                  } else {
                    return validateUnique(val, _gqlClient);
                  }
                } else {
                  return validatorResult;
                }
              },
              onChanged: (value) => widget.questionData.answer = value,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                errorMaxLines: 2,
                hintText: widget.questionData.hint,
              ),
            ),
          ),
        )
      ],
    );
  }
}
