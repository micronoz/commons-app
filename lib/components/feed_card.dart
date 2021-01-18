import 'package:flutter/material.dart';

class FeedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
          margin: EdgeInsets.only(bottom: 15, top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5, bottom: 5),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://picsum.photos/250?image=9'),
                            fit: BoxFit.fill),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'nozberkman',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Image.network(
                'https://picsum.photos/250?image=9',
                fit: BoxFit.fitWidth,
              )
            ],
          )),
    );
  }
}
