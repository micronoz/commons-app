import 'package:flutter/material.dart';
import 'package:tribal_instinct/model/app_user.dart';

class MemberCard extends StatelessWidget {
  MemberCard(this.member, {Key key}) : super(key: key);
  final AppUser member;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image(
            image: member.photo,
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
                        member.name + ' ',
                        style: Theme.of(context).textTheme.bodyText1,
                        textScaleFactor: 1.3,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '@' + member.identifier,
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
                    member.description,
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: Text('Follow'))
        ],
      ),
    );
  }
}
