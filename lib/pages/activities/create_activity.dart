import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tribal_instinct/components/question_switch.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/managers/activity_manager.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:provider/provider.dart';
import 'package:pedantic/pedantic.dart';

import 'activity_detail.dart';

String createActivityMutation = '''
  mutation CreateActivity(\$title: String!, \$description: String!, \$mediumType: String!, \$xLocation: Float!, \$yLocation: Float!, \$address: String!, \$eventDateTime: DateTime) {
    createActivity(title: \$title, description: \$description, mediumType: \$mediumType, xLocation: \$xLocation, yLocation: \$yLocation, address: \$address, eventDateTime: \$eventDateTime) {
      id
    }
  }
''';

class CreateActivityPage extends StatefulWidget {
  @override
  _CreateActivityPageState createState() => _CreateActivityPageState();

  CreateActivityPage() : super();
}

class _CreateActivityPageState extends State<CreateActivityPage> {
  void saveAndExit(BuildContext context, RunMutation createEventMutation) {
    final _mediumType = _isOnline ? 'online' : 'in_person';
    final _dateTime = _date.toUtc().toIso8601String();
    //TODO: Add location
    createEventMutation({
      'title': _activityName,
      'description': _desciption,
      'mediumType': _mediumType,
      'xLocation': 0.2,
      'yLocation': -4,
      'address': _location,
      'eventDateTime': _dateTime,
    });
  }

  static const maxInputSize = 255;
  static const emptyFieldError = 'You can not leave this field empty.';
  static const largeInputError =
      'This field can not have more than than ${maxInputSize} characters.';

  final _formKey = GlobalKey<FormState>();
  bool _edited = false;
  String _activityName;
  String _desciption;
  bool _isOnline = false;
  String _location;
  DateTime _date;

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
    return Mutation(
      options: MutationOptions(
        fetchPolicy: FetchPolicy.noCache,
        document: gql(createActivityMutation),
        onCompleted: (dynamic resultData) {
          print('Create Activity mutation return:');
          print(resultData);
          context.read<ActivityManager>().addEvent();
          if (resultData != null) {
            final activity = resultData['createActivity']['id'];
            Navigator.of(context).pop();
            // Navigator.of(context).pushReplacement(MaterialPageRoute(
            //     builder: (_) => ActivityDetailPage(activity)));
          } else {
            //TODO
          }
        },
      ),
      builder: (
        RunMutation runMutation,
        QueryResult result,
      ) {
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
                  QuestionSwitch(
                    question: 'Where will it be?',
                    disabledOption: 'In-person',
                    enabledOption: 'Online',
                    callback: (val) => setState(() => _isOnline = val),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: _isOnline
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
                    format: DateFormat.yMMMMEEEEd().add_jm(),
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        initialDate: currentValue ??
                            DateTime.now().add(Duration(days: 1)),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );

                      if (date != null) {
                        var time = await showTimePicker(
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
                  const SizedBox(
                    height: 20,
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
                          saveAndExit(context, runMutation);
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
      },
    );
  }
}
