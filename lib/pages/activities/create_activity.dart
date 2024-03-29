import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:tribal_instinct/components/question_switch.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:tribal_instinct/managers/activity_manager.dart';
import 'package:provider/provider.dart';
import 'package:tribal_instinct/managers/location_manager.dart';

import 'activity_detail.dart';

final createInPersonActivityMutation = '''
  mutation CreateActivity(\$title: String!, \$description: String, \$organizerCoordinates: LocationInput!, \$physicalAddress: String, \$eventDateTime: DateTime) {
    createInPersonActivity(title: \$title, description: \$description, organizerCoordinates: \$organizerCoordinates, physicalAddress: \$physicalAddress, eventDateTime: \$eventDateTime) {
      id
    }
  }
''';
final createOnlineActivityMutation = '''
  mutation CreateActivity(\$title: String!, \$description: String, \$eventUrl: String, \$eventDateTime: DateTime) {
    createOnlineActivity(title: \$title, description: \$description, eventUrl: \$eventUrl, eventDateTime: \$eventDateTime) {
      id
    }
  }
''';

class CreateActivityPage extends StatefulWidget {
  @override
  _CreateActivityPageState createState() => _CreateActivityPageState();
}

class _CreateActivityPageState extends State<CreateActivityPage> {
  void saveAndExit(
      BuildContext context, RunMutation createEventMutation) async {
    final _dateTime = _date?.toUtc()?.toIso8601String();
    if (_isOnline) {
      assert(_physicalAddress == null);
      createEventMutation({
        'title': _activityName,
        'description': _desciption,
        'eventUrl': _eventUrl,
        'eventDateTime': _dateTime,
      });
    } else {
      var currentPosition = Provider.of<Position>(context, listen: false);
      // TODO: Put loading screen while waiting for this so that it is not
      // double clicked
      currentPosition ??= await LocationManager.of(context).updateLocation();
      assert(_eventUrl == null);
      createEventMutation({
        'title': _activityName,
        'description': _desciption,
        'organizerCoordinates': {
          'xLocation': currentPosition.longitude,
          'yLocation': currentPosition.latitude,
        },
        'physicalAddress': _physicalAddress,
        'eventUrl': _eventUrl,
        'eventDateTime': _dateTime,
      });
    }
  }

  static const maxInputSize = 10000;
  static const emptyFieldError = 'You can not leave this field empty.';
  static const largeInputError =
      'This field can not have more than than ${maxInputSize} characters.';

  final _formKey = GlobalKey<FormState>();
  bool _edited = false;
  String _activityName;
  String _desciption;
  bool _isOnline = false;
  String _physicalAddress;
  String _eventUrl;
  DateTime _date;

  String _mandatoryValidator(String value) {
    if (value == null || value.isEmpty) {
      return emptyFieldError;
    } else if (value.length > maxInputSize) {
      return largeInputError;
    } else {
      return null;
    }
  }

  String _genericValidator(String value) {
    if (value.length > maxInputSize) {
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Will do!'),
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
        document: gql(_isOnline
            ? createOnlineActivityMutation
            : createInPersonActivityMutation),
        onCompleted: (dynamic resultData) {
          print('Create Activity mutation return:');
          if (resultData != null) {
            var activity;
            if (resultData['createOnlineActivity'] != null) {
              activity = resultData['createOnlineActivity']['id'];
            } else if (resultData['createInPersonActivity'] != null) {
              activity = resultData['createInPersonActivity']['id'];
            } else {
              //TODO
            }
            context.read<ActivityManager>().addEvent();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => ActivityDetailPage(activity)));
          } else {
            //TODO
          }
        },
        onError: (error) {
          print('Create Activity mutation ERROR:');
          print(error);
          //TODO: Handle error when passed in invalid address
        },
      ),
      builder: (
        RunMutation runMutation,
        QueryResult result,
      ) {
        return Scaffold(
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
                  'What do you want to do?',
                  style: Theme.of(context).textTheme.headline6,
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Title'),
                  onChanged: (value) => setState(() => _activityName = value),
                  validator: _mandatoryValidator,
                ),
                const SizedBox(
                  height: 20,
                ),
                QuestionSwitch(
                    question: 'Format?',
                    disabledOption: 'In-person',
                    enabledOption: 'Online',
                    callback: (val) {
                      setState(() => _isOnline = val);
                      if (val) {
                        _eventUrl = _physicalAddress;
                        _physicalAddress = null;
                      } else {
                        _physicalAddress = _eventUrl;
                        _eventUrl = null;
                      }
                    }),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Optional',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Tell me more',
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
                Text(
                  'Where will it be?',
                  style: Theme.of(context).textTheme.headline6,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      hintText: _isOnline
                          ? 'Provide a link (you can add it later as well)'
                          : 'Location'),
                  //TODO: Reconsider the maximum input size for links
                  onChanged: (value) {
                    if (_isOnline) {
                      _physicalAddress = null;
                      _eventUrl = value == '' ? null : value;
                    } else {
                      _physicalAddress = value == '' ? null : value;
                      _eventUrl = null;
                    }
                  },
                  validator: _genericValidator,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'When will it be?',
                  style: Theme.of(context).textTheme.headline6,
                ),
                DateTimeField(
                  format: DateFormat.yMMMMEEEEd().add_jm(),
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      initialDate:
                          currentValue ?? DateTime.now().add(Duration(days: 1)),
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
                    if (value != null && value.isBefore(DateTime.now())) {
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
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      saveAndExit(context, runMutation);
                    } else {
                      _showFormError();
                    }
                  },
                  icon: Icon(FontAwesome5.thumbs_up),
                  label: Text('Let\'s go!'),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
