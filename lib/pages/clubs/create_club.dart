import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/custom_step.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tribal_instinct/pages/create_summary.dart';

class CreateClubPage extends StatefulWidget {
  @override
  _CreateClubPageState createState() => _CreateClubPageState();
}

// TODO get rid of step form

class _CreateClubPageState extends State<CreateClubPage> {
  int currentStep = 0;
  List<Step> steps;
  List<CustomStepState> stepStates = [
        CustomStepState(isActive: true, title: Text('Groundwork'))
      ] +
      ['Visual'].map((e) => CustomStepState(title: Text(e))).toList();
  bool complete = false;
  final formSpacing = const SizedBox(
    height: 20,
  );

  String tribeName;
  String tribeSubtitle;
  String tribeSummary;

  final ImagePicker _picker = ImagePicker();
  PickedFile _pickedImage;

  void next(BuildContext context) {
    print('Next called');
    currentStep + 1 != steps.length
        ? goTo(currentStep + 1)
        : goTo(currentStep)
            ? Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateTribeSummaryPage(
                      tribeName: tribeName,
                      tribeSubtitle: tribeSubtitle,
                      tribeSummary: tribeSummary,
                      imagePath: _pickedImage.path,
                    )))
            : null;
  }

  bool goTo(int step) {
    print('Goto called');
    if (step > currentStep + 1) return false;
    var chooseStep = (steps[currentStep] as CustomStep);
    var stepState = stepStates[currentStep];
    if (!chooseStep.validate()) {
      setState(() {
        stepState.state = StepState.error;
      });
      return false;
    } else {
      setState(() {
        chooseStep.save();
        stepState.isActive = false;
        stepState.state = StepState.complete;
        currentStep = step;
        stepStates[currentStep].isActive = true;
      });
      return true;
    }
  }

  void exitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure you want to cancel?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Yes')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(), child: Text('No'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var stepContent = [
      Column(
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
            onSaved: (newValue) =>
                tribeName = newValue, //TODO Check if name available
          ),
          formSpacing,
          Text(
            'Subtitle for your Tribe',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          TextFormField(
            initialValue: tribeSubtitle,
            validator: (value) => value.isEmpty ? '*Required' : null,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSaved: (newValue) => tribeSubtitle = newValue,
          ),
          formSpacing,
          Text(
            'Describe your Tribe',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          TextFormField(
            initialValue: tribeSummary,
            onSaved: (newValue) => tribeSummary = newValue,
          ),
          formSpacing,
          Text(
            '*Note: All of the above can be changed in the future',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pickedImage == null
              ? Text(
                  'Add a Tribe photo',
                  style: Theme.of(context).textTheme.bodyText1,
                )
              : AspectRatio(
                  aspectRatio: 1,
                  child: Image.file(
                    File(_pickedImage.path),
                    fit: BoxFit.cover,
                  ),
                ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                try {
                  _pickedImage =
                      await _picker.getImage(source: ImageSource.gallery);
                } catch (e) {
                  print(e);
                }
                setState(() {});
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo),
                  Text('${_pickedImage == null ? 'Pick' : 'Change'} Photo')
                ],
              ),
            ),
          ),
          FormField(
            builder: (state) => const SizedBox(),
            validator: (value) =>
                _pickedImage == null ? 'You must pick an image' : null,
          ),
        ],
      ),
    ];
    assert(stepStates.length == stepContent.length);
    steps = stepContent
        .asMap()
        .entries
        .map((contentPair) => CustomStep(
              isActive: stepStates[contentPair.key].isActive,
              state: stepStates[contentPair.key].state,
              form: true,
              formKey: stepStates[contentPair.key].formKey,
              content: contentPair.value,
              title: stepStates[contentPair.key].title,
            ))
        .toList();

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create a Tribe'),
          automaticallyImplyLeading: false,
        ),
        body: Stepper(
          currentStep: currentStep,
          onStepTapped: goTo,
          onStepContinue: () => next(context),
          onStepCancel: () {
            (steps[currentStep] as CustomStep).save();
            exitDialog(context);
          },
          type: StepperType.horizontal,
          steps: steps,
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
