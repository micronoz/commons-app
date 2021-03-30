import 'package:flutter/material.dart';

class DiscoverFilter extends StatefulWidget {
  DiscoverFilter(this._categoryNames, {Key key}) : super(key: key);
  final List<String> _categoryNames;

  @override
  _DiscoverFilterState createState() => _DiscoverFilterState();
}

class _DiscoverFilterState extends State<DiscoverFilter> {
  final List<String> _categoryFilters = <String>[];

  Iterable<Widget> get _categoryFilterWidgets sync* {
    for (final category in widget._categoryNames) {
      yield Padding(
        padding: const EdgeInsets.all(1.0),
        child: FilterChip(
          showCheckmark: false,
          visualDensity: VisualDensity.comfortable,
          label: Text(category),
          selected: category == 'All'
              ? _categoryFilters.isEmpty
              : _categoryFilters.contains(category),
          onSelected: (bool value) {
            setState(() {
              if (value) {
                if (category == 'All') {
                  _categoryFilters.clear();
                } else {
                  _categoryFilters.add(category);
                }
              } else {
                if (category != 'All') {
                  _categoryFilters.removeWhere((String name) {
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
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.spaceEvenly,
      children: _categoryFilterWidgets.toList(),
    );
  }
}
