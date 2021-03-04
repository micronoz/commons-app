import 'package:flutter/material.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/user_profile.dart';
import 'package:tribal_instinct/pages/activities/activity_detail.dart';

class EventCardSmall extends StatelessWidget {
  EventCardSmall(this.event, {Key key}) : super(key: key);
  final Activity event;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ActivityDetailPage(event.id))),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      event.title,
                      style: Theme.of(context).textTheme.bodyText1,
                      textScaleFactor: 1.3,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        Text(
                          '@' + event.organizer.handle,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (event.description != null)
                    Flexible(
                      child: Text(
                        event.description,
                        style: Theme.of(context).textTheme.bodyText2,
                        maxLines: 2,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
