import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:tribal_instinct/model/discover_types.dart';
import 'package:tribal_instinct/pages/discover/discover_category.dart';
import 'package:tribal_instinct/extensions/string_extension.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage(this.type, {Key key}) : super(key: key);
  final DiscoverType type;
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(EnumToString.convertToString(widget.type).capitalize()),
        centerTitle: true,
      ),
      body: DiscoverCategoryPage(widget.type),
    );
  }
}
