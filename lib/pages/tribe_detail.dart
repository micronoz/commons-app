import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/custom_carousel.dart';
import 'package:tribal_instinct/model/tribe.dart';

class TribeDetail extends StatefulWidget {
  @override
  _TribeDetailState createState() => _TribeDetailState();
}

class _TribeDetailState extends State<TribeDetail> {
  @override
  Widget build(BuildContext context) {
    var _tribeModel = Tribe();
    return Scaffold(
      appBar: AppBar(
        title: Text('Tribe Tour'),
      ),
      body: ListView(
        children: [
          CustomCarousel(
            imageList: _tribeModel.photos.map((e) => NetworkImage(e)).toList(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(_tribeModel.mainPhoto),
                            fit: BoxFit.fill),
                      ),
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          _tribeModel.name,
                          style: Theme.of(context).textTheme.headline1,
                          textScaleFactor: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _tribeModel.description,
                  style: Theme.of(context).textTheme.bodyText1,
                  textScaleFactor: 1.3,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
