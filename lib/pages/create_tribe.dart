import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/custom_step.dart';

class CreateTribePage extends StatefulWidget {
  @override
  _CreateTribePageState createState() => _CreateTribePageState();
}

class _CreateTribePageState extends State<CreateTribePage> {
  bool cancelling = false;
  int currentStep = 0;
  List<Step> steps;
  List<CustomStepState> stepStates = [CustomStepState(isActive: true)] +
      [1].map((e) => CustomStepState()).toList();
  bool complete = false;
  final formSpacing = const SizedBox(
    height: 20,
  );

  String tribeName;
  String tribeMotto;
  String tribeSummary;

  void next() {
    print('Next called');
    currentStep + 1 != steps.length
        ? goTo(currentStep + 1)
        : setState(() => complete = true);
  }

  void cancel() {
    setState(() {
      cancelling = true;
    });
  }

  void goTo(int step) {
    print('Goto called');
    var chooseStep = (steps[currentStep] as CustomStep);
    var stepState = stepStates[currentStep];
    setState(() {
      if (!chooseStep.validate()) {
        stepState.state = StepState.error;
      } else {
        chooseStep.save();
        stepState.isActive = false;
        stepState.state = StepState.complete;
        currentStep = step;
        stepStates[currentStep].isActive = true;
      }
    });
  }

  //TODO Move customstep content rendering to build method and map content to customstep
  @override
  Widget build(BuildContext context) {
    steps = [
      CustomStep(
        isActive: stepStates[0].isActive,
        state: stepStates[0].state,
        form: true,
        formKey: stepStates[0].formKey,
        content: Column(
          key: stepStates[0].key,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name your Tribe',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextFormField(
              initialValue: tribeName,
              validator: (value) => value.isEmpty ? '*Required' : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSaved: (newValue) => tribeName = newValue,
              onChanged: (newValue) => tribeName = newValue,
            ),
            formSpacing,
            Text(
              'State your Tribe\'s motto',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextFormField(
              initialValue: tribeMotto,
              validator: (value) => value.isEmpty ? '*Required' : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSaved: (newValue) => tribeMotto = newValue,
              onChanged: (newValue) => tribeMotto = newValue,
            ),
            formSpacing,
            Text(
              'Describe your Tribe',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            TextFormField(
              initialValue: tribeSummary,
              validator: (value) => value.isEmpty ? '*Required' : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSaved: (newValue) => tribeSummary = newValue,
              onChanged: (newValue) => tribeSummary = newValue,
            ),
            formSpacing,
            Text(
              '*Note: All of the above can be changed in the future',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
        title: Text('Genesis'),
      ),
      CustomStep(
        form: true,
        formKey: stepStates[1].formKey,
        state: stepStates[1].state,
        isActive: stepStates[1].isActive,
        content: Text('Name your Tribe'),
        title: Text('Overall'),
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Tribe'),
      ),
      body: cancelling
          ? AlertDialog(
              title: Text('Are you sure you want to cancel?'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Yes')),
                TextButton(
                    onPressed: () => setState(() => cancelling = false),
                    child: Text('No'))
              ],
            )
          : Stepper(
              currentStep: currentStep,
              onStepTapped: goTo,
              onStepContinue: next,
              onStepCancel: cancel,
              type: StepperType.horizontal,
              steps: steps,
            ),
    );
  }
}
