import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:tribal_instinct/model/discover_types.dart';
import 'package:tribal_instinct/extensions/string_extension.dart';

class DiscoverItemsPage extends StatelessWidget {
  DiscoverItemsPage(this.type, this.category) : super();

  final DiscoverType type;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            category + ' ' + EnumToString.convertToString(type).capitalize()),
      ),
    );
  }
}
