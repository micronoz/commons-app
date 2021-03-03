import 'package:flutter/material.dart';

class AppConstants extends InheritedWidget {
  static AppConstants of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppConstants>();

  const AppConstants({Widget child, Key key}) : super(key: key, child: child);

  final String backendUri = 'http://10.0.2.2:4000/graphql';	
  
  @override
  bool updateShouldNotify(AppConstants oldWidget) => false;
}
