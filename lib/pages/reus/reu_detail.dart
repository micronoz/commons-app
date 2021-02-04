import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tribal_instinct/components/member_card.dart';
import 'package:tribal_instinct/model/app_user.dart';
import 'package:tribal_instinct/model/reu.dart';
import 'package:tribal_instinct/model/reu_types.dart';

class ReuDetailPage extends StatelessWidget {
  final DateFormat _format = DateFormat();
  final reu = Reu(
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
      ReuHost.hosted,
      ReuMedium.in_person,
      ReuGroup.grouped_assembly);

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
              'Sign up for this Reu',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Reu details'),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              reu.photoUrl,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            reu.title,
            style: Theme.of(context).textTheme.headline2,
            textScaleFactor: 0.6,
            textAlign: TextAlign.center,
          ),
          Text(
            (reu.mediumType == ReuMedium.in_person
                    ? 'in-person at '
                    : 'online at ') +
                reu.location,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
            textScaleFactor: 1.3,
          ),
          Text(
            reu.hostType == ReuHost.self_hosted
                ? 'without a host present'
                : 'with host present',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
            textScaleFactor: 1.3,
          ),
          Text(
            'on ' + _format.format(reu.dateTime.toLocal()),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
            textScaleFactor: 1.3,
          ),
          Text(
            reu.groupType.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
            textScaleFactor: 1.3,
          ),
          Text(
            'Available space: ${reu.cohortSize - reu.attendees.length}/${reu.cohortSize}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
            textScaleFactor: 1.3,
          ),
          Text(
            'Price: ' + reu.price,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
            textScaleFactor: 1.3,
          ),
          Text(
            reu.description,
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
          ...reu.attendees.map(
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
