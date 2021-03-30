import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:intl/intl.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/pages/activities/activity_detail.dart';

class EventCardSmall extends StatelessWidget {
  EventCardSmall(this.event, {Key key, this.distance}) : super(key: key);
  final Activity event;
  final double distance;
  final DateFormat _format = DateFormat.MMMMd().addPattern(',', '').add_jm();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ActivityDetailPage(event.id))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                        child: Row(
                          children: [
                            event.isOnline
                                ? Icon(FontAwesome5.globe_americas)
                                : Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(FontAwesome5.user_friends),
                                  ),
                            Text(
                              event.title,
                              style: Theme.of(context).textTheme.bodyText1,
                              textScaleFactor: 1.3,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              // Icon(
                              //   FontAwesome5.crown,
                              //   size: 16,
                              // ),
                              // const SizedBox(
                              //   width: 6,
                              // ),
                              Text(
                                '@' + event.organizer.handle,
                                style: Theme.of(context).textTheme.bodyText1,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (event.description?.isNotEmpty ?? false)
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              event.description,
                              style: Theme.of(context).textTheme.bodyText1,
                              maxLines: 2,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      if (event.dateTime != null)
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  FontAwesome5.calendar_day,
                                  size: 18,
                                ),
                                Text(
                                  _format.format(event.dateTime.toLocal()),
                                  style: Theme.of(context).textTheme.bodyText1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (distance != null)
                  Text(
                    'Distance: ' + distance.toStringAsFixed(0) + ' km',
                    style: Theme.of(context).textTheme.bodyText1,
                    textScaleFactor: 1.1,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
