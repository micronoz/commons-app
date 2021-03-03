import 'package:flutter/material.dart';

class ActivityManager extends ChangeNotifier {
  void addEvent() {
    print('ActivityManager notifying listeners');
    notifyListeners();
  }
}
