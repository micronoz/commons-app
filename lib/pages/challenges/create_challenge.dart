import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tribal_instinct/components/question_switch.dart';
import 'package:tribal_instinct/components/session_card.dart';

class CreateChallengePage extends StatefulWidget {
  @override
  _CreateChallengePageState createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends State<CreateChallengePage> {
  void removeSession(Widget card) {
    setState(() {
      _sessions.remove(card);
    });
  }

  final _formKey = GlobalKey<FormState>();
  var _edited = false;
  var _online = false;
  var _minimumGroup = false;
  var _maximumGroup = false;
  var _maximumCohort = false;
  var _repeating = false;
  var _sessions = <SessionCard>[];

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
          title: Text('Create Adventure'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              Text(
                'Let\'s plan your Adventure',
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
                'Describe what this Adventure is about',
                style: Theme.of(context).textTheme.headline6,
              ),
              TextFormField(
                maxLines: null,
                decoration: InputDecoration(hintText: 'Description'),
              ),
              const SizedBox(
                height: 20,
              ),
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
              QuestionSwitch(
                question: 'When will it be?',
                disabledOption: 'Single sessions',
                enabledOption: 'Repeating',
                callback: (val) => setState(() => _repeating = val),
              ),
              Text(
                '(You can always add more later)',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              ..._sessions,
              Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        setState(() {
                          _sessions.add(SessionCard(
                            callback: removeSession,
                            key: UniqueKey(),
                          ));
                        });
                      }),
                  Text(
                    'Add session',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              QuestionSwitch(
                key: Key('min'),
                question: 'Minimum group size',
                disabledOption: 'Disabled',
                enabledOption: 'Enabled',
                callback: (val) => setState(() => _minimumGroup = val),
              ),
              if (_minimumGroup)
                Text(
                  '(Individuals will be forced to group up)',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              if (_minimumGroup)
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
                key: Key('max group'),
                question: 'Maximum group size',
                disabledOption: 'Disabled',
                enabledOption: 'Enabled',
                callback: (val) => setState(() => _maximumGroup = val),
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
                question: 'Maximum cohort size',
                disabledOption: 'Disabled',
                enabledOption: 'Enabled',
                callback: (val) => setState(() => _maximumCohort = val),
              ),
              Text(
                '(Max number of participants per session)',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              if (_maximumCohort)
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
            ],
          ),
        ),
      ),
    );
  }
}
