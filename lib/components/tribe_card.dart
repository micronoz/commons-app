import 'package:flutter/material.dart';
import 'package:tribal_instinct/pages/tribe_detail.dart';

class TribeCard extends StatelessWidget {
  TribeCard({Key key, this.extras, this.id}) : super(key: key);

  final Widget extras;
  final String id;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return InkWell(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => TribeDetail())),
      child: Container(
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
      ),
    );
  }
}
