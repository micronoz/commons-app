import 'package:flutter/material.dart';
import 'package:tribal_instinct/model/user_profile.dart';

class MemberRequestCard extends StatefulWidget {
  MemberRequestCard(this.member, this.callback, {Key key}) : super(key: key);

  final Function callback;
  final UserProfile member;

  @override
  _MemberRequestCardState createState() => _MemberRequestCardState();
}

class _MemberRequestCardState extends State<MemberRequestCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    (widget.member.name ?? '') + ' ',
                    style: Theme.of(context).textTheme.bodyText1,
                    textScaleFactor: 1.3,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Text(
                    '@nozberkman' + (widget.member.handle ?? ''),
                    style: Theme.of(context).textTheme.bodyText2,
                    textScaleFactor: 1.3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(
            flex: 2,
          ),
          Container(
            decoration:
                ShapeDecoration(shape: CircleBorder(), color: Colors.green),
            child: IconButton(
              icon: Icon(Icons.check),
              onPressed: () => widget.callback(true),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            decoration:
                ShapeDecoration(shape: CircleBorder(), color: Colors.red),
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => widget.callback(false),
            ),
          )
        ],
      ),
    );
  }
}
