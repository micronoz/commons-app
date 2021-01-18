import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('User handle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage('https://picsum.photos/250?image=9'),
                    fit: BoxFit.fill),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '1500',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Followers')
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '1500',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Achievements')
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '1500',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('SocialCapital')
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
