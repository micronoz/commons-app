import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tribal_instinct/components/member_card.dart';
import 'package:tribal_instinct/model/adventure.dart';
import 'package:tribal_instinct/model/adventure_types.dart';

class AdventureDetailPage extends StatelessWidget {
  final DateFormat _format = DateFormat();
  final adventure = Adventure.getDefault();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () {},
        label: Text(
          'Sign up for this Adventure',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
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
