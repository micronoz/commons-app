import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SessionCard extends StatefulWidget {
  SessionCard({Key key, this.callback}) : super(key: key);

  final Function callback;

  @override
  _SessionCardState createState() => _SessionCardState();
}

//TODO format and print date and time and add repeating option
class _SessionCardState extends State<SessionCard> {
  DateTime _date;
  TimeOfDay _time;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _date == null
                ? RaisedButton(
                    onPressed: () async {
                      _date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2099));
                      setState(() {});
                    },
                    child: Text('Pick a Date'),
                  )
                : Text(_date.toLocal().toString()),
            RaisedButton(
              onPressed: () async {
                _time = await showTimePicker(
                    context: context, initialTime: TimeOfDay.now());
                setState(() {});
              },
              child: Text('Pick a Time'),
            ),
            IconButton(
              icon: Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),
              onPressed: () => widget.callback(widget),
            )
          ],
        ),
      ),
    );
  }
}
