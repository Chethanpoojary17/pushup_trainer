import 'package:flutter/material.dart';
import 'package:pushuptrainerpro/screens/chart_screen.dart';
import 'package:pushuptrainerpro/screens/main_screen.dart';
import 'package:pushuptrainerpro/screens/pushupTest.dart';
import 'package:pushuptrainerpro/screens/pushup_trainer.dart';
import 'package:pushuptrainerpro/screens/setting_screen.dart';
import 'package:pushuptrainerpro/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/tab_screen.dart';
import 'package:flutter/services.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pushup Trainer pro',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Color.fromRGBO(255, 194, 179,1),
        canvasColor: Colors.white,
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            body1: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            body2: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            title: TextStyle(
              fontSize: 20,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            )),

      ),
      home: SplashScreen(),
      initialRoute: '/', // default is '/'
      routes: {
        TabsScreen.routeName: (ctx) => TabsScreen(),
        'cs': (ctx) => ChartScreen(),
        MainScreen.routeName: (ctx) => MainScreen(),
        PushupTrainer.routeName: (ctx) => PushupTrainer(),
      },
    );
  }
}

