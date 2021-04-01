import 'package:flutter/material.dart';
import 'package:tribal_instinct/model/user_group.dart';
import 'package:tribal_instinct/model/user_profile.dart';

class MessageCard extends StatelessWidget {
  final Function(BuildContext) route;
  final UserProfile profile;

  MessageCard({Key key, this.profile, UserGroup group, this.route})
      : super(key: key) {
    assert((profile == null && group != null) ||
        (profile != null && group == null));
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => route(context),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: profile.photo,
              radius: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 10,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          profile.name + ' ',
                          style: Theme.of(context).textTheme.bodyText1,
                          textScaleFactor: 1.3,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '@' + profile.handle,
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
                      profile.bio,
                      style: Theme.of(context).textTheme.bodyText2,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            Flexible(child: Icon(Icons.arrow_forward_ios))
          ],
        ),
      ),
    );
  }
}
