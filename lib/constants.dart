import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class AppConstants extends InheritedWidget {
  static AppConstants of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppConstants>();

  AppConstants({Widget child, Key key}) : super(key: key, child: child);

  final String backendUri = Platform.operatingSystem == 'android'
      ? 'http://10.0.2.2:4000/graphql'
      : 'http://localhost:4000/graphql';
  @override
  bool updateShouldNotify(AppConstants oldWidget) => false;
}
