import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomCarousel extends StatefulWidget {
  CustomCarousel(
      {Key key,
      @required this.imageList,
      this.aspectRatio = 1,
      this.enableEnlarge = true,
      this.borderRadius = const BorderRadius.all(Radius.circular(5))})
      : super(key: key);
  final List<ImageProvider> imageList;
  final double aspectRatio;
  final bool enableEnlarge;
  final BorderRadiusGeometry borderRadius;

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
              enlargeCenterPage: widget.imageList.length == 1
                  ? false
                  : (true && widget.enableEnlarge),
              aspectRatio: widget.aspectRatio),
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
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                '${currentIndex + 1}/${widget.imageList.length}',
                textScaleFactor: 1.5,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: const BorderRadius.all(Radius.circular(5))),
          ),
          right: 5,
          bottom: 5,
        )
      ],
    );
  }
}
