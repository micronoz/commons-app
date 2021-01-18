import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:tribal_instinct/components/feed_card.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  _FeedPageState() : super() {
    searchBar = SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: print,
        buildDefaultAppBar: buildAppBar);
  }

  SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) => AppBar(
      title: Text('Something'), actions: [searchBar.getSearchAction(context)]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: Container(
          child: Center(
              child: ListView(
        children: [FeedCard(), FeedCard(), FeedCard()],
      ))),
    );
  }
}
