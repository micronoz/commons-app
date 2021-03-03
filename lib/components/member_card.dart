import 'package:flutter/material.dart';
import 'package:tribal_instinct/model/user_profile.dart';

class MemberCard extends StatefulWidget {
  MemberCard(this.member, this.onText, this.offText, this.isOn, {Key key})
      : super(key: key);
  final UserProfile member;
  final String onText;
  final String offText;
  final Function isOn;

  @override
  _MemberCardState createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  @override
  Widget build(BuildContext context) {
    var isOn = widget.isOn(widget.member);
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: widget.member.photo,
            width: 60,
            height: 60,
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.member.name + ' ',
                        style: Theme.of(context).textTheme.bodyText1,
                        textScaleFactor: 1.3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '@' + widget.member.handle,
                        style: TextStyle(),
                        textScaleFactor: 1.3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                Flexible(
                  child: Text(
                    widget.member.description,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          TextButton(
              onPressed: () => setState,
              child: Text(isOn ? widget.onText : widget.offText))
        ],
      ),
    );
  }
}
