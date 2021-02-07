import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tribal_instinct/pages/adventures/create_adventure.dart';
import 'package:tribal_instinct/pages/discover/discover_category.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key key}) : super(key: key);
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with SingleTickerProviderStateMixin {
  final List<String> _options = ['Experiences', 'Clubs'];
  var _current = 'Experiences';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton(
          icon: Icon(
            Icons.arrow_drop_down_sharp,
            color: Colors.black,
          ),
          iconSize: 40,
          value: _current,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          items: _options
              .map(
                (e) => DropdownMenuItem(
                  child: Text(
                    e,
                    textScaleFactor: 1.4,
                  ),
                  value: e,
                ),
              )
              .toList(),
          onChanged: (val) {
            setState(() {
              _current = val;
            });
          },
        ),
        centerTitle: true,
      ),
      body: Provider.value(
          value: _current, builder: (context, w) => DiscoverCategoryPage()),
    );
  }
}
