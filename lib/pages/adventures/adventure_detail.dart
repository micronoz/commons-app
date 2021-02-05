import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tribal_instinct/components/member_card.dart';
import 'package:tribal_instinct/model/adventure.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/adventure_types.dart';

class AdventureDetailPage extends StatelessWidget {
  final DateFormat _format = DateFormat();
  final adventure = Adventure(
      '1',
      'Book club meeting',
      '''
      

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ut massa eu tellus pretium porttitor eu eu nunc. Aenean convallis, quam ut porttitor facilisis, nisl ipsum rhoncus dolor, id tempus lacus diam ac urna. Duis ut gravida magna. Aliquam erat volutpat. Pellentesque ut nibh mattis, aliquam dolor sed, condimentum quam. Phasellus elit turpis, interdum ac accumsan eget, rutrum ultricies est. Etiam in urna pharetra, lacinia leo eu, interdum sem. Aliquam nisi ipsum, pretium a blandit a, malesuada et lacus.

Quisque sit amet sagittis tellus. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aliquam erat volutpat. In dapibus dolor eu condimentum imperdiet. Quisque dui nibh, bibendum nec rhoncus ut, consectetur eget nisi. Suspendisse potenti. Praesent dictum facilisis mi, et sollicitudin nunc porttitor in. Vivamus suscipit, metus nec convallis lacinia, dolor lectus semper quam, eget viverra dolor mi sit amet eros. Quisque sollicitudin lectus ut lacus consequat, vel finibus elit commodo.


''',
      'https://i.imgur.com/pHI6aOe.jpg',
      'Free',
      'Peet\'s coffee',
      5,
      50,
      DateTime.now(),
      [AppUser(), AppUser()],
      AppUser(),
      AdventureHost.hosted,
      AdventureMedium.in_person,
      AdventureGroup.grouped_assembly);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            backgroundColor: Colors.green,
            onPressed: () {},
            label: Text(
              'Sign up for this Adventure',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Adventure details'),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              adventure.photoUrl,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            adventure.title,
            style: Theme.of(context).textTheme.headline2,
            textScaleFactor: 0.6,
            textAlign: TextAlign.center,
          ),
          Text(
            (adventure.mediumType == AdventureMedium.in_person
                    ? 'in-person at '
                    : 'online at ') +
                adventure.location,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
            textScaleFactor: 1.3,
          ),
          Text(
            adventure.hostType == AdventureHost.self_hosted
                ? 'without a host present'
                : 'with host present',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
            textScaleFactor: 1.3,
          ),
          Text(
            'on ' + _format.format(adventure.dateTime.toLocal()),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
            textScaleFactor: 1.3,
          ),
          Text(
            adventure.groupType.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
            textScaleFactor: 1.3,
          ),
          Text(
            'Available space: ${adventure.cohortSize - adventure.attendees.length}/${adventure.cohortSize}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
            textScaleFactor: 1.3,
          ),
          Text(
            'Price: ' + adventure.price,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
            textScaleFactor: 1.3,
          ),
          Text(
            adventure.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              'Participants',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          ...adventure.attendees.map(
            (m) => MemberCard(
              m,
            ),
          ),
          const SizedBox(
            height: 60,
          )
        ],
      ),
    );
  }
}
