import 'package:flutter/material.dart';
import 'package:tribal_instinct/model/tribe.dart';
import 'package:tribal_instinct/pages/challenges/challenge_detail.dart';

class EventCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return InkWell(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ChallengeDetailPage())),
      child: Card(
        margin: EdgeInsets.only(bottom: 10, top: 10),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                Tribe().photos[0],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event title',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Row(
                    children: [
                      Padding(
                        child: Icon(
                          Icons.group,
                        ),
                        padding: EdgeInsets.only(right: 10),
                      ),
                      Flexible(
                        child: Text(
                          'Minimum group size is 4',
                          style: Theme.of(context).textTheme.headline2,
                          textScaleFactor: 0.5,
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                  ),
                  Padding(
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc blandit quis nunc non molestie. Nam vulputate ipsum sit amet dui consequat rutrum. Interdum et malesuada fames ac ante ipsum primis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc blandit quis nunc non molestie. Nam vulputate ipsum sit amet dui consequat rutrum. Interdum et malesuada fames ac ante ipsum primis. ',
                      style: Theme.of(context).textTheme.bodyText1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Tap to see details',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_forward_rounded)
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
