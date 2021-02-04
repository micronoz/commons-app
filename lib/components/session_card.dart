import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionCard extends StatefulWidget {
  SessionCard({Key key, this.removeCallback}) : super(key: key);

  final Function removeCallback;

  @override
  _SessionCardState createState() => _SessionCardState();
}

//TODO format and print date and time and add repeating option
class _SessionCardState extends State<SessionCard> {
  Future pickDate(BuildContext context, DateTime initial) async {
    var date = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime.now(),
        lastDate: DateTime(2099));
    setState(() {
      _date = date;
    });
  }

  DateTime _date;
  final DateFormat _format = DateFormat.yMd();
  TimeOfDay _time;
  DateTime _combined;
  String _frequency = 'No Repeat';

  @override
  Widget build(BuildContext context) {
    if (_date != null && _time != null) {
      _combined = _date.add(Duration(hours: _time.hour, minutes: _time.minute));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                if (_date == null)
                  RaisedButton(
                    onPressed: () => pickDate(context, DateTime.now()),
                    child: Text('Pick a Date'),
                  )
                else
                  RaisedButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_format.format(_date.toLocal())),
                        Icon(Icons.edit)
                      ],
                    ),
                    onPressed: () => pickDate(context, _date),
                  ),
                if (_time == null)
                  RaisedButton(
                    onPressed: () => showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) => setState(() => _time = value)),
                    child: Text('Pick a Time'),
                  )
                else
                  RaisedButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Text(_time.format(context)), Icon(Icons.edit)],
                    ),
                    onPressed: () =>
                        showTimePicker(context: context, initialTime: _time)
                            .then((value) => setState(() => _time = value)),
                  ),
                IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ),
                  onPressed: () => widget.removeCallback(widget),
                )
              ],
            ),
            if (_combined?.isBefore(DateTime.now()) ?? false)
              Text(
                '* Cannot time travel into the past!',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.red[600]),
              ),
            // Center(
            //   child: DropdownButton(
            //     value: _frequency,
            //     items: ['No Repeat', 'Weekly', 'Biweekly', 'Monthly', 'Yearly']
            //         .map((e) => DropdownMenuItem(
            //               child: Text(e),
            //               value: e,
            //             ))
            //         .toList(),
            //     onChanged: (something) {
            //       setState(
            //         () {
            //           _frequency = something;
            //         },
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
