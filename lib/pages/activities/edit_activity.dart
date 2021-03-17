import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tribal_instinct/managers/location_manager.dart';

class EditActivityPage extends StatefulWidget {
  final String activityId;
  EditActivityPage(this.activityId) : super();

  @override
  _EditActivityPageState createState() => _EditActivityPageState();
}

final getActivityQuery = r'''
  query GetActivity($id: String!) {
    activity(id: $id) {
      organizer {
        id
      }
      id
      title
      description
      mediumType
      eventDateTime
      userConnections{
        id
        attendanceStatus
        user {
          id
          fullName
        }
      }
      ... on InPersonActivity {
        physicalAddress
        discoveryCoordinates {
          x
          y
        }
        eventCoordinates{
          x
          y
        }
      }
      ... on OnlineActivity {
        eventUrl
      }
    }
  }
''';

final updateInPersonActivityMutation = r'''
  mutation UpdateInPersonActivity($title: String!, $description: String, $organizerCoordinates: LocationInput!, $physicalAddress: String, $eventDateTime: DateTime) {
    updateInPersonActivity(title: $title, description: $description, organizerCoordinates: $organizerCoordinates, physicalAddress: $physicalAddress, eventDateTime: $eventDateTime) {
      id
      title
      description
      mediumType
      eventDateTime
      ... on InPersonActivity {
        physicalAddress
        discoveryCoordinates {
          x
          y
        }
        eventCoordinates{
          x
          y
        }
      }
    }
  }
''';

final updateOnlineActivityMutation = r'''
  mutation UpdateOnlineActivity($title: String!, $description: String, $eventUrl: String, $eventDateTime: DateTime) {
    updateOnlineActivity(title: $title, description: $description, eventUrl: $eventUrl, eventDateTime: $eventDateTime) {
      id
    }
  }
''';

class _EditActivityPageState extends State<EditActivityPage> {
  static const maxInputSize = 255;
  static const emptyFieldError = 'You can not leave this field empty.';
  static const largeInputError =
      'This field can not have more than than $maxInputSize characters.';

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

  @override
  Widget build(BuildContext context) {
    GraphQLProvider.of(context).value.query(
          QueryOptions(
            document: gql(getActivityQuery),
          ),
        );
    return Mutation(
      options: MutationOptions(
        fetchPolicy: FetchPolicy.noCache,
        document: gql(_isOnline
            ? updateOnlineActivityMutation
            : updateInPersonActivityMutation),
        onCompleted: (dynamic resultData) {
          print('Create Activity mutation return:');
          print(resultData);
          if (resultData != null) {
            var activity;
            if (resultData['createOnlineActivity'] != null) {
              activity = resultData['createOnlineActivity']['id'];
            } else if (resultData['createInPersonActivity'] != null) {
              activity = resultData['createInPersonActivity']['id'];
            } else {
              //TODO
            }
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
                    validator: _mandatoryValidator,
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
                  Text(
                    '(In your local time)',
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
                      color: Colors.red,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Nah maybe another time...'),
                          Icon(Icons.close)
                        ],
                      ),
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
