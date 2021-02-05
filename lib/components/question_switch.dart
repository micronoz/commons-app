import 'package:flutter/material.dart';

typedef BoolCallback = void Function(bool val);

class QuestionSwitch extends StatefulWidget {
  const QuestionSwitch(
      {Key key,
      @required this.question,
      @required this.disabledOption,
      @required this.enabledOption,
      @required this.callback,
      this.additionalInfo})
      : super(key: key);

  final String question;
  final String disabledOption;
  final String enabledOption;
  final BoolCallback callback;
  final String additionalInfo;

  @override
  State<StatefulWidget> createState() => _QuestionSwitchState();
}

class _QuestionSwitchState extends State<QuestionSwitch> {
  var _enabled = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: widget.additionalInfo != null ? 0 : 20,
      children: [
        Text(
          widget.question,
          style: Theme.of(context).textTheme.headline6,
        ),
        if (widget.additionalInfo != null)
          IconButton(
            icon: Icon(Icons.info_outline_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(widget.question),
                  content: SingleChildScrollView(
                    child: Text(
                      widget.additionalInfo,
                      textScaleFactor: 1.1,
                    ),
                  ),
                  contentPadding: EdgeInsets.only(top: 10, left: 20, right: 20),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK!')),
                    )
                  ],
                ),
              );
            },
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
        )
      ],
    );
  }
}
