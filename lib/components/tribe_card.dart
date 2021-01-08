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
          clipBehavior: Clip.hardEdge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          child: Row(
            children: [
              Image.network('https://picsum.photos/250?image=9'),
              Flexible(
                fit: FlexFit.tight,
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tribe name',
                      style: Theme.of(context).textTheme.headline5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Tribe subtitle',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2,
                      textScaleFactor: 1.1,
                    ),
                    extras
                  ].where((element) => element != null).toList(),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Row(children: [Text('1500'), Icon(Icons.star_rounded)]),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
