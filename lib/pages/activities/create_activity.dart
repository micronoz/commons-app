import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tribal_instinct/components/question_switch.dart';
import 'package:tribal_instinct/components/session_card.dart';

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

  final _formKey = GlobalKey<FormState>();
  var _edited = false;
  var _online = false;
  var _maximumGroup = false;
  var _maximumAttendance = false;
  var _format = false;
  var _repeating = false;
  final _sessions = <SessionCard>[];

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
                        ? 'Provide a link (leave blank to add it later)'
                        : 'Location'),
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
              SessionCard(
                removeCallback: null,
                key: UniqueKey(),
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
              QuestionSwitch(
                key: Key('max group'),
                question: 'Target group size',
                disabledOption: 'Disabled',
                enabledOption: 'Enabled',
                callback: (val) => setState(() => _maximumGroup = val),
                additionalInfo:
                    'Participants will be divided into groups of equal (if possible) size up to the target group size. \n\nChoose a number that is small enough for people to build connections but large enough to allow them to meet new people.',
              ),
              if (_maximumGroup)
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
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
              QuestionSwitch(
                key: Key('max cohort'),
                question: 'Maximum attendance size',
                disabledOption: 'Disabled',
                enabledOption: 'Enabled',
                callback: (val) => setState(() => _maximumAttendance = val),
                additionalInfo: 'Max number of participants per session',
              ),
              if (_maximumAttendance)
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
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
              SizedBox(
                height: 40,
                child: RaisedButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  onPressed: () => saveAndExit(context),
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
