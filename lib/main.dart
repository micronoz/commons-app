import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tribal_instinct/pages/home.dart';

import 'managers/auth.dart';
import 'managers/user_manager.dart';

//TODO need to add user state management

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(App(
    auth: await Auth.create(),
    userManager: UserManager.create(),
  ));
}

class App extends StatefulWidget {
  const App({
    Key key,
    @required this.auth,
    @required this.userManager,
  }) : super(key: key);

  final Auth auth;
  final UserManager userManager;
  // final ItemManager itemManager;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider.value(value: widget.userManager.currentUser.value)],
      child: MaterialApp(
        title: 'Tribal Instinct',
        theme: ThemeData(
          // platform: TargetPlatform.iOS,
          primarySwatch: Colors.cyan,
          accentColor: Colors.orangeAccent,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}
