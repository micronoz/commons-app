import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/managers/user_manager.dart';
import 'onboarding_question.dart';

String createUserMutation = """
  mutation CreateUser(\$firstName: String!, \$lastName: String!, \$handle: String!) {
    createUser(firstName: \$firstName, lastName: \$lastName, handle: \$handle) {
      id
    }
  }
""";

class QuestionData {
  final String question;
  final String hint;
  final String Function(String) validator;

  String answer;

  QuestionData(this.question, this.hint, this.validator);
}

String _genericValidator(String val) {
  if (val.isNotEmpty) {
    return null;
  }
  return 'Please enter a value';
}

//TODO: Write more specific validators
final List<QuestionData> data = [
  QuestionData('What is your first name?', 'First Name', _genericValidator),
  QuestionData('How about your last name?', 'Last Name', _genericValidator),
  QuestionData("Let's choose a username now", 'Username', _genericValidator),
];

class OnboardingFlow extends StatefulWidget {
  OnboardingFlow({Key key}) : super(key: key);

  // static MaterialPageRoute route() {
  // return MaterialPageRoute(builder: (context) => OnboardingFlow());
  // }

  @override
  _OnboardingFlowState createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _pageIndex = 0;

  AnimatedContainer createCircle({int index}) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 100),
        margin: EdgeInsets.only(right: 4),
        height: 5,
        width: _pageIndex == index ? 15 : 5, // current indicator is wider
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(3)));
  }

  final _pages = data.map((e) => OnboardingQuestion(questionData: e)).toList();
  @override
  Widget build(BuildContext context) {
    var currentFocus = FocusScope.of(context);

    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 55, left: 10),
            child: Row(
              children: [
                BackButton(
                  onPressed: () {
                    if (_pageIndex > 0) {
                      setState(() {
                        _pageIndex--;
                      });
                    } else {
                      UserManager.of(context).logout();
                    }
                    currentFocus.unfocus();
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            )),
        IndexedStack(
          children: _pages,
          index: _pageIndex,
        ),
        Padding(
          padding: EdgeInsets.only(top: 50),
        ),
        Mutation(
            options: MutationOptions(
              document: gql(createUserMutation),
              onCompleted: (dynamic resultData) {
                print('Created User.');
                UserManager.of(context).fetchUserProfile();
              },
            ),
            builder: (
              RunMutation runMutation,
              QueryResult result,
            ) {
              return RaisedButton(
                child: Text('Next'),
                onPressed: () {
                  if (!_pages[_pageIndex].formKey.currentState.validate()) {
                    return;
                  }
                  if (_pageIndex < _pages.length - 1) {
                    setState(() {
                      _pageIndex++;
                    });
                  } else {
                    runMutation({
                      'firstName': _pages[0].questionData.answer,
                      'lastName': _pages[1].questionData.answer,
                      'handle': _pages[2].questionData.answer,
                    });
                  }
                  currentFocus.unfocus();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0),
                    side: BorderSide(color: Colors.grey)),
              );
            }),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  _pages.length, (index) => createCircle(index: index)),
            )),
      ],
    );
  }
}
