import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tribal_instinct/components/question_switch.dart';
import 'package:tribal_instinct/components/session_card.dart';
import 'package:tribal_instinct/model/activity_types.dart';
import 'package:tribal_instinct/extensions/string_extension.dart';

class CreateActivityPage extends StatefulWidget {
  @override
  _CreateActivityPageState createState() => _CreateActivityPageState();
}

class _CreateActivityPageState extends State<CreateActivityPage> {
  void saveAndExit(BuildContext context) {
    // TODO save to model and send to server
    Navigator.of(context).pop();
  }

  void removeSession(Widget card) {
    setState(() {
      _sessions.remove(card);
    });
  }

  static const maxInputSize = 255;
  static const emptyFieldError = 'You can not leave this field empty.';
  static const largeInputError =
      'This field can not have more than than ${maxInputSize} characters.';

  final _formKey = GlobalKey<FormState>();
  var _edited = false;
  var _activityName = null;
  var _desciption = null;
  var _online = false;
  var _location = null;
  var _date = null;
  // var _multiGroup = false;
  var _targetGroupSize = null;
  var _maximumAttendance = false;
  var _maximumAttendenceSize = null;
  var _format = false;
  var _repeating = false;
  var _approval = false;
  ActivityVisibility _sliderValue = ActivityVisibility.invite_only;
  final _sessions = <SessionCard>[];

  String _genericValidator(String value) {
    if (value == null || value.isEmpty) {
      return emptyFieldError;
    } else if (value.length > maxInputSize) {
      return largeInputError;
    } else {
      return null;
    }
  }

  Future<void> _showFormError() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incomplete Form'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'The fields are not filled in correctly. Please complete the form.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Will do!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_edited) {
          return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Are you sure you want to cancel?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  ));
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create an Activity'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Text(
                'Let\'s plan your Activity',
                style: Theme.of(context).textTheme.headline4,
                textScaleFactor: 0.9,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Firstly, give it a name',
                style: Theme.of(context).textTheme.headline6,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Title'),
                onChanged: (value) => setState(() => _activityName = value),
                validator: _genericValidator,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Describe what this Activity is about',
                style: Theme.of(context).textTheme.headline6,
              ),
              TextFormField(
                maxLines: null,
                decoration: InputDecoration(hintText: 'Description'),
                onChanged: (value) => setState(() => _desciption = value),
                validator: _genericValidator,
              ),
              const SizedBox(
                height: 20,
              ),
              // QuestionSwitch(
              //   question: 'Format',
              //   disabledOption: 'Self-guided',
              //   enabledOption: 'Hosted',
              //   callback: (val) => setState(() => _format = val),
              //   additionalInfo:
              //       'In a \'Self-guided\' format you have to provide enough information to allow the grouped participants to be able to host the event themselves without you being present (e.g. providing recordings for a yoga class, providing map and guide for a hike etc.) Provide clear instructions and helpful materials for your guests. \n\nIn a \'Hosted\' format, you have to be present in each of the sessions and be able to host all of the groups in that session at the same time (limited by the maximum cohort size you set, which is required for hosted events).',
              // ),
              QuestionSwitch(
                question: 'Where will it be?',
                disabledOption: 'In-person',
                enabledOption: 'Online',
                callback: (val) => setState(() => _online = val),
              ),
              TextFormField(
                decoration: InputDecoration(
                    hintText: _online
                        ? 'Provide a link (you can add it later as well)'
                        : 'Location'),
                //TODO: Reconsider the maximum input size for links
                onChanged: (value) => _location = value,
                validator: _genericValidator,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'When will it be?',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                '(Will calibrate to your local time)',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              DateTimeField(
                format: DateFormat('yyyy-MM-dd HH:mm'),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate:
                        currentValue ?? DateTime.now().add(Duration(days: 1)),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                },
                onChanged: (value) => _date = value,
                validator: (value) {
                  if (value == null) {
                    return emptyFieldError;
                  }
                  if (value.isBefore(DateTime.now())) {
                    return 'Time of the event must be in the future.';
                  } else {
                    return null;
                  }
                },
              ),
              // Text(
              //   '(You can always add more later)',
              //   style: Theme.of(context).textTheme.subtitle1,
              // ),
              // ..._sessions,
              // Row(
              //   children: [
              //     IconButton(
              //         icon: Icon(
              //           Icons.add_circle,
              //           color: Colors.green,
              //         ),
              //         onPressed: () {
              //           setState(() {
              //             _sessions.add(SessionCard(
              //               removeCallback: removeSession,
              //               key: UniqueKey(),
              //             ));
              //           });
              //         }),
              //     Text(
              //       'Add session',
              //       style: TextStyle(fontWeight: FontWeight.bold),
              //     )
              //   ],
              // ),
              const SizedBox(
                height: 20,
              ),
              // QuestionSwitch(
              //   key: Key('multi group'),
              //   question: 'Multi group',
              //   disabledOption: 'Disabled',
              //   enabledOption: 'Enabled',
              //   callback: (val) => setState(() => _multiGroup = val),
              //   additionalInfo:
              //       'Usually keep this disabled for personal Activities\n\nEnabling this setting allows you to divide the attendees into multiple smaller groups in which they can connect with each other better. They can meet ahead of time and attend the event together. Grouping will be done randomly for now.\n\nIf enabled, you will need to define a target group size, which will be the average number of people per group.',
              // ),
              // if (_multiGroup)
              //   Text(
              //     'Target group size',
              //     style: Theme.of(context).textTheme.subtitle1,
              //   ),
              // if (_multiGroup)
              //   Row(
              //     children: [
              //       Flexible(
              //         child: TextFormField(
              //           style: Theme.of(context).textTheme.headline6,
              //           textAlign: TextAlign.center,
              //           decoration:
              //               const InputDecoration(border: OutlineInputBorder()),
              //           inputFormatters: [
              //             FilteringTextInputFormatter.digitsOnly
              //           ],
              //           keyboardType: TextInputType.number,
              //           onChanged: (value) => _targetGroupSize = value,
              //           validator: _genericValidator,
              //         ),
              //       ),
              //       Spacer(
              //         flex: 2,
              //       )
              //     ],
              //   ),
              // const SizedBox(
              // height: 20,
              // ),
              QuestionSwitch(
                key: Key('max cohort'),
                question: 'Maximum attendance size',
                disabledOption: 'Disabled',
                enabledOption: 'Enabled',
                callback: (val) => setState(() => _maximumAttendance = val),
                additionalInfo:
                    'Max number of individuals who can attend this activity.',
              ),
              if (_maximumAttendance)
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.allow(RegExp(r'[1-9]\d*'))
                        ],
                        keyboardType: TextInputType.number,
                        onChanged: (value) => _maximumAttendenceSize = value,
                        validator: _genericValidator,
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    )
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Visibility',
                style: Theme.of(context).textTheme.headline6,
              ),

              SliderTheme(
                data: SliderThemeData(
                    showValueIndicator: ShowValueIndicator.always),
                child: Slider(
                  onChanged: (numa) {
                    setState(() {
                      _sliderValue = ActivityVisibility.values[numa.truncate()];
                    });
                  },
                  value: _sliderValue.index.toDouble(),
                  min: 0,
                  max: 2,
                  label: EnumToString.convertToString(_sliderValue)
                      .replaceAll('_', ' ')
                      .capitalize(),
                  divisions: 2,
                ),
              ),

              if (_sliderValue == ActivityVisibility.people_i_follow ||
                  _sliderValue == ActivityVisibility.public)
                QuestionSwitch(
                  key: Key('approval'),
                  question: 'Require approval',
                  disabledOption: 'Disabled',
                  enabledOption: 'Enabled',
                  callback: (val) => setState(() => _approval = val),
                  additionalInfo:
                      'Enabling this will require you to approve each of the participants before they are allowed to join the activity.',
                ),

              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                child: RaisedButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      saveAndExit(context);
                    } else {
                      _showFormError();
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Ready to go!'),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.check)
                    ],
                  ),
                  color: Colors.green,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 40,
                child: RaisedButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text(
                                  'Are you sure you want to cancel?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Yes'),
                                ),
                              ],
                            ));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Nah maybe another time...'),
                      Icon(Icons.close)
                    ],
                  ),
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
