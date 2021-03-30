import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tribal_instinct/constants.dart';
import 'package:tribal_instinct/managers/activity_manager.dart';
import 'package:tribal_instinct/pages/home.dart';
import 'package:tribal_instinct/pages/login.dart';

import 'managers/location_manager.dart';
import 'managers/user_manager.dart';
import 'model/is_logged_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initHiveForFlutter();
  runApp(AppConstants(
    child: App(
      userManager: await UserManager.create(),
      locationManager: LocationManager(),
    ),
  ));
}

class App extends StatefulWidget {
  App({Key key, @required this.userManager, @required this.locationManager})
      : super(key: key);

  final UserManager userManager;
  final LocationManager locationManager;
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  final _primaryColor = const Color(0xfffbf9f2);
  final _secondaryColor = const Color(0xfff2f4fb);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<UserManager>.value(value: widget.userManager),
          ValueListenableProvider.value(value: widget.userManager.appUser),
          ValueListenableProvider.value(value: widget.userManager.isLoggedIn),
          Provider<LocationManager>.value(value: widget.locationManager),
          ValueListenableProvider<Position>.value(
              value: widget.locationManager.currentLocation),
          ChangeNotifierProvider<ActivityManager>(
            create: (context) => ActivityManager(),
          )
        ],
        builder: (context, child) {
          var isLoggedIn = context.watch<IsLoggedIn>();
          var httpLink = HttpLink(AppConstants.of(context).backendUri);

          var authLink = AuthLink(
            getToken: () async {
              final token = await widget.userManager.getIdToken();
              return 'Bearer $token';
            },
          );

          var link = authLink.concat(httpLink);
          var client = GraphQLClient(
            alwaysRebroadcast: true,
            link: link,
            cache: GraphQLCache(store: HiveStore()),
          );
          var clientNotifier = ValueNotifier(client);
          widget.userManager.registerGraphQL(clientNotifier);

          return GraphQLProvider(
              client: clientNotifier,
              child: MaterialApp(
                title: 'Tribal Instinct',
                theme: ThemeData(
                    cardTheme: CardTheme(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    appBarTheme: AppBarTheme(foregroundColor: Colors.black),
                    scaffoldBackgroundColor: _primaryColor,
                    primaryColor: _primaryColor,
                    accentColor: Colors.blue[100],
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                        backgroundColor: _primaryColor,
                        selectedItemColor: Colors.blue[200]),
                    chipTheme: ChipThemeData.fromDefaults(
                      secondaryColor: Colors.blue[100],
                      labelStyle: TextStyle(),
                      brightness: Brightness.light,
                    ).copyWith(selectedColor: Colors.blue[100])),
                navigatorKey: _navigatorKey,
                home: isLoggedIn.val ? HomePage() : LoginPage(),
              ));
        });
  }
}
