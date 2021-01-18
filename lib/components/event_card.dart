import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/custom_carousel.dart';
import 'package:tribal_instinct/model/tribe.dart';

class EventCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return InkWell(
      onTap: () => print('Hi'),
      child: Card(
        margin: EdgeInsets.only(bottom: 10, top: 10),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCarousel(
              imageList: Tribe().photos.map((e) => NetworkImage(e)).toList(),
              aspectRatio: 16 / 9,
              enableEnlarge: false,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(5)),
            ),
            Text(
              'Event title',
              style: Theme.of(context).textTheme.headline2,
            ),
            Row(
              children: [
                Flexible(
                  flex: 10,
                  child: Text(
                    'Team majority attendance required',
                    style: Theme.of(context).textTheme.headline2,
                    textScaleFactor: 0.5,
                  ),
                ),
                const Flexible(
                    child: Padding(
                  child: Icon(
                    Icons.group,
                  ),
                  padding: EdgeInsets.only(right: 10),
                ))
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            Padding(
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc blandit quis nunc non molestie. Nam vulputate ipsum sit amet dui consequat rutrum. Interdum et malesuada fames ac ante ipsum primis. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc blandit quis nunc non molestie. Nam vulputate ipsum sit amet dui consequat rutrum. Interdum et malesuada fames ac ante ipsum primis. ',
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
            ),
          ],
        ),
      ),
    );
  }
}
