import 'package:flutter/material.dart';

typedef BoolCallback = void Function(bool val);

class QuestionSwitch extends StatefulWidget {
  const QuestionSwitch(
      {Key key,
      @required this.question,
      @required this.disabledOption,
      @required this.enabledOption,
      @required this.callback})
      : super(key: key);

  final String question;
  final String disabledOption;
  final String enabledOption;
  final BoolCallback callback;

  @override
  State<StatefulWidget> createState() => _QuestionSwitchState();
}

class _QuestionSwitchState extends State<QuestionSwitch> {
  var _enabled = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      children: [
        Text(
          widget.question,
          style: Theme.of(context).textTheme.headline6,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.disabledOption,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Switch(
              value: _enabled,
              onChanged: (status) {
                _enabled = !_enabled;
                widget.callback(status);
              },
              activeColor: Colors.green,
              activeTrackColor: Colors.lightGreenAccent,
            ),
            Text(
              widget.enabledOption,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
