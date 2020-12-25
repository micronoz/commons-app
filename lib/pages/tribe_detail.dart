import 'package:flutter/material.dart';

class TribeDetail extends StatefulWidget {
  @override
  _TribeDetailState createState() => _TribeDetailState();
}

class _TribeDetailState extends State<TribeDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(child: Center(child: Text('Tribe Detail'))),
    );
  }
}
