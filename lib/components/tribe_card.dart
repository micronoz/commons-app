import 'package:flutter/material.dart';

class TribeCard extends StatelessWidget {
  TribeCard({Key key, this.extras}) : super(key: key);

  Widget extras;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Card(
        elevation: 10,
        child: Row(
          children: [
            Image.network('https://picsum.photos/250?image=9'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('Tribe name'), Text('Tribe slogan'), extras]
                  .where((element) => element != null)
                  .toList(),
            ),
            Spacer(flex: 10),
            Text('15000000 points'),
            Icon(Icons.star_outline),
            Spacer(
              flex: 2,
            )
          ],
        ),
      ),
    );
  }
}
