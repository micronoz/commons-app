import 'package:flutter/material.dart';
import 'package:tribal_instinct/model/adventure.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/pages/adventures/adventure_detail.dart';

class EventCardSmall extends StatelessWidget {
  EventCardSmall(this.event, {Key key}) : super(key: key);
  final Adventure event;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AdventureDetailPage())),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: NetworkImage(event.photoUrl),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
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
                        event.organizer.runtimeType == AppUser
                            ? Icon(Icons.person)
                            : Icon(Icons.home),
                        Text(
                          '@' + event.organizer.identifier,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                event.price,
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                textScaleFactor: 1.3,
              ),
            )
          ],
        ),
      ),
    );
  }
}
