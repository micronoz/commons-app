import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class CreateTribeSummaryPage extends StatelessWidget {
  CreateTribeSummaryPage(
      {Key key,
      @required this.tribeName,
      @required this.tribeSubtitle,
      @required this.tribeSummary,
      this.imagePath = ''})
      : super(key: key);

  final String tribeName;
  final String tribeSubtitle;
  final String tribeSummary;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tribe Summary'),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                flex: 3,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    tribeName,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
              ),
              Spacer(
                flex: 1,
              )
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Flexible(
                flex: 3,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    tribeSubtitle,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ),
              Spacer(
                flex: 1,
              )
            ],
          ),
          Divider(
            thickness: 10,
          ),
          Text(
            tribeSummary + ' asdasdasdasfasdgasgasdgsadg  asdgasdg sad dgsa dg',
            style: Theme.of(context).textTheme.bodyText1,
            textScaleFactor: 1.5,
          ),
          Divider(
            thickness: 10,
          ),
          Padding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: Colors.green,
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            Timer(const Duration(seconds: 2), () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            });
                            return WillPopScope(
                              child: Dialog(
                                backgroundColor: Colors.transparent,
                                child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                    child: Padding(
                                      child: Icon(
                                        Icons.check,
                                        size: 50,
                                      ),
                                      padding: EdgeInsets.all(10),
                                    )),
                              ),
                              onWillPop: () async => false,
                            );
                          });
                      print('Confirm');
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Confirm'),
                          const SizedBox(
                            width: 5,
                          ),
                          const Icon(Icons.thumb_up)
                        ])),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  color: Colors.red[800],
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Are you sure you want to cancel?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text('Yes')),
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('No'))
                        ],
                      ),
                    );
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Cancel'),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.thumb_down)
                      ]),
                )
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 40),
          ),
        ],
      ),
    );
  }
}
