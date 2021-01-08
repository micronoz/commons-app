import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/custom_carousel.dart';
import 'package:tribal_instinct/model/tribe.dart';

class EventCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return InkWell(
      onTap: () => print('Hi'),
      child: Container(
        child: Card(
          clipBehavior: Clip.hardEdge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 15,
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
              Padding(
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc blandit quis nunc non molestie. Nam vulputate ipsum sit amet dui consequat rutrum. Interdum et malesuada fames ac ante ipsum primis. ',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
