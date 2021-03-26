import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tribal_instinct/managers/location_manager.dart';
import 'package:tribal_instinct/model/activity_types.dart';
import 'package:tribal_instinct/pages/discover/discover_category.dart';
import 'package:provider/provider.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key key}) : super(key: key);
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
  final String discoverOnlineActivitiesQuery = '''
  query DiscoverOnlineActivities {
    discoverOnlineActivities {
      id
      title
      eventUrl
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
  query DiscoverInPersonActivities (\$discoveryCoordinates: LocationInput!, \$radiusInKilometers: Float!){
    discoverInPersonActivities(discoveryCoordinates: \$discoveryCoordinates, radiusInKilometers: \$radiusInKilometers) {
      activity{
        physicalAddress
        discoveryCoordinates {
          x
          y
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
      distance
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
    'Discussion',
    'Sports',
    'Other',
    'More',
    'Less',
    'You',
    'Hi',
    'Hey'
  ];

  var currentPosition;

  @override
  Widget build(BuildContext context) {
    currentPosition ??= LocationManager.of(context).updateLocation();
    currentPosition = context.watch<Position>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Discover Activities'),
            actions: [
              IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    LocationManager.of(context).updateLocation();
                  })
            ],
            centerTitle: false,
            bottom: TabBar(
              indicatorColor: Colors.blue[800],
              tabs: [Tab(text: 'Online'), Tab(text: 'In Person')],
            ),
          ),
          body: TabBarView(
            children: [
              DiscoverCategoryPage(
                  widget.discoverOnlineActivitiesQuery,
                  {},
                  'discoverOnlineActivities',
                  _onlineCategoryNames,
                  ActivityMedium.online),
              (currentPosition != null)
                  ? DiscoverCategoryPage(
                      widget.discoverInPersonActivitiesQuery,
                      {
                        'discoveryCoordinates': {
                          'xLocation': currentPosition.longitude,
                          'yLocation': currentPosition.latitude,
                        },
                        'radiusInKilometers': 1,
                      },
                      'discoverInPersonActivities',
                      _inPersonCategoryNames,
                      ActivityMedium.in_person)
                  : Text(
                      'Please enable location services to discover in person activities.'),
            ],
          )),
    );
  }
}
