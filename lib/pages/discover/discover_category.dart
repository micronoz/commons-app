import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tribal_instinct/model/discover_types.dart';
import 'package:tribal_instinct/pages/discover/discover_items.dart';

class DiscoverCategoryPage extends StatefulWidget {
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
    return Consumer<String>(
      builder: (context, val, child) {
        var type = EnumToString.fromString(DiscoverType.values, val);
        var tiles = _categories
            .map(
              (e) => ListTile(
                key: Key(e['name']),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          DiscoverItemsPage(type, e['name'])));
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

        return ListView(
          children: ListTile.divideTiles(
            color: Colors.black,
            context: context,
            tiles: tiles,
          ).toList(),
        );
      },
    );
  }
}
