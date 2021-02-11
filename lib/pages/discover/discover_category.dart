import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/event_card_small.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/discover_types.dart';
import 'package:tribal_instinct/pages/discover/discover_items.dart';

class DiscoverCategoryPage extends StatefulWidget {
  final DiscoverType type;
  DiscoverCategoryPage(this.type, {Key key}) : super(key: key);

  @override
  _DiscoverCategoryPageState createState() => _DiscoverCategoryPageState();
}

class _DiscoverCategoryPageState extends State<DiscoverCategoryPage> {
  final List<Map<String, Object>> _categories = [
    {'name': 'Sports', 'icon': Icon(Icons.sports_football)},
    {'name': 'Books', 'icon': Icon(Icons.book)}
  ];

  @override
  Widget build(BuildContext context) {
    var tiles = _categories
        .map(
          (e) => ListTile(
            key: Key(e['name']),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      DiscoverItemsPage(widget.type, e['name'])));
            },
            tileColor: Colors.brown[100],
            leading: e['icon'],
            title: Text(e['name']),
            trailing: Icon(
              Icons.arrow_right,
              size: 30,
            ),
          ),
        )
        .toList();
    tiles.sort((a, b) => a.key.toString().compareTo(b.key.toString()));

    var categories = ListTile.divideTiles(
      color: Colors.black,
      context: context,
      tiles: tiles,
    ).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
              Text(
                'Your friends are attending',
                style: Theme.of(context).textTheme.headline2,
                textScaleFactor: 0.4,
              ),
              EventCardSmall(Activity.getDefault()),
              EventCardSmall(Activity.getDefault()),
              EventCardSmall(Activity.getDefault()),
              SizedBox(
                height: 20,
              ),
              Text(
                'Discover categories',
                style: Theme.of(context).textTheme.headline2,
                textScaleFactor: 0.4,
              ),
              SizedBox(
                height: 10,
              ),
            ] +
            categories,
      ),
    );
  }
}
