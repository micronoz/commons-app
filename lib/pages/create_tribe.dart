import 'package:flutter/material.dart';

class CreateTribePage extends StatefulWidget {
  @override
  _CreateTribePageState createState() => _CreateTribePageState();
}

class _CreateTribePageState extends State<CreateTribePage> {
  int currentStep = 0;
  goTo(int step) {
    setState(() => currentStep = step);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Tribe'),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        steps: [
          Step(
            state: StepState.complete,
            isActive: true,
            content: Text('Name your Tribe (This cannot be changed!)'),
            title: Text('Name'),
          ),
          Step(
            content: Text('Name your Tribe (This cannot be changed!)'),
            title: Text('Name'),
          )
        ],
      ),
    );
  }
}
