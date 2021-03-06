import 'package:flutter/material.dart';
import 'package:tribal_instinct/pages/discover/discover_category.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key key}) : super(key: key);
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
  final String discoverActivitiesQuery = '''
  query DiscoverActivities {
    discoverActivities {
    ... on InPersonActivity {
      physicalAddress
      discoveryCoordinates {
        x
        y
      }

    }
    ... on OnlineActivity {
      eventUrl
    }
      id
      title
      description
      organizer {
        handle
        id
      }
      mediumType
      eventDateTime
    }
  }
''';

  final String discoverInPersonActivitiesQuery = '''
  query DiscoverInPersonActivities (\$discoveryCoordinates: LocationInput!, \$radiusInKilometers: number!){
    discoverInPersonActivities(discoveryCoordinates: \$discoveryCoordinates, radiusInKilometers: \$radiusInKilometers) {
    ... on InPersonActivity {
      physicalAddress
      discoveryCoordinates {
        x
        y
      }
    }
      id
      title
      description
      organizer {
        handle
        id
      }
      mediumType
      eventDateTime
    }
  }
''';
}

class _DiscoverPageState extends State<DiscoverPage> {
  final List<String> _inPersonCategoryNames = <String>[
    'All',
    'Hang Out',
    'Study',
    'Sports',
    'Other',
  ];
  final List<String> _onlineCategoryNames = <String>[
    'All',
    'Gaming',
    'Sports',
    'Other',
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Discover Activities'),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.blue[800],
              tabs: [Tab(text: 'Online'), Tab(text: 'In Person')],
            ),
          ),
          body: TabBarView(
            children: [
              DiscoverCategoryPage(
                  widget.discoverActivitiesQuery, _onlineCategoryNames),
              DiscoverCategoryPage(
                  widget.discoverActivitiesQuery, _inPersonCategoryNames),
            ],
          )),
    );
  }
}
