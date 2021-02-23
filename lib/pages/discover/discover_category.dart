import 'package:flutter/material.dart';
import 'package:tribal_instinct/components/event_card_small.dart';
import 'package:tribal_instinct/model/activity.dart';
import 'package:tribal_instinct/model/discover_types.dart';

class DiscoverCategoryPage extends StatefulWidget {
  final DiscoverType type;
  DiscoverCategoryPage(this.type, {Key key}) : super(key: key);

  @override
  _DiscoverCategoryPageState createState() => _DiscoverCategoryPageState();
}

class _DiscoverCategoryPageState extends State<DiscoverCategoryPage> {
  final List<String> _cast = <String>[
    'All',
    'Hang Out',
    'Study',
    'Sports',
    'Other',
  ];
  final List<String> _filters = <String>[];

  Iterable<Widget> get categoryWidgets sync* {
    for (final category in _cast) {
      yield Padding(
        padding: const EdgeInsets.all(1.0),
        child: FilterChip(
          showCheckmark: false,
          visualDensity: VisualDensity.comfortable,
          label: Text(category),
          selected: category == 'All'
              ? _filters.isEmpty
              : _filters.contains(category),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                if (category == 'All') {
                  _filters.clear();
                } else {
                  _filters.add(category);
                }
              } else {
                if (category != 'All') {
                  _filters.removeWhere((String name) {
                    return name == category;
                  });
                }
              }
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceEvenly,
            children: categoryWidgets.toList(),
          ),
          EventCardSmall(Activity.getDefault()),
          EventCardSmall(Activity.getDefault()),
          EventCardSmall(Activity.getDefault()),
        ],
      ),
    );
  }
}
