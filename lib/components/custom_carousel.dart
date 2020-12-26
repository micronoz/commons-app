import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomCarousel extends StatefulWidget {
  CustomCarousel({Key key, @required this.imageList}) : super(key: key);
  final List<ImageProvider> imageList;

  @override
  _CustomCarouselState createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              initialPage: currentIndex,
              onPageChanged: (index, reason) =>
                  setState(() => currentIndex = index),
              enableInfiniteScroll: false,
              viewportFraction: 1,
              height: MediaQuery.of(context).size.height * 0.3,
              enlargeCenterPage: widget.imageList.length == 1 ? false : true),
          items: widget.imageList
              .map(
                (i) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: i,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        Positioned(
          child: Container(
            child: Text(
              '${currentIndex + 1}/${widget.imageList.length}',
              textScaleFactor: 1.5,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
          right: 5,
          bottom: 5,
        )
      ],
    );
  }
}
