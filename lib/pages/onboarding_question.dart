import 'package:flutter/material.dart';
import 'package:tribal_instinct/pages/onboarding_flow.dart';

class OnboardingQuestion extends StatefulWidget {
  OnboardingQuestion({Key key, @required this.questionData}) : super(key: key);

  final QuestionData questionData;
  final formKey = GlobalKey<FormState>();

  @override
  _OnboardingQuestionState createState() => _OnboardingQuestionState();
}

class _OnboardingQuestionState extends State<OnboardingQuestion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 100, bottom: 50),
          child: Text(widget.questionData.question),
        ),
        Container(
          width: 200,
          child: Form(
            key: widget.formKey,
            child: TextFormField(
              validator: widget.questionData.validator,
              onChanged: (value) => widget.questionData.answer = value,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: widget.questionData.hint,
              ),
            ),
          ),
        )
      ],
    );
  }
}
