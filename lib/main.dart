import 'package:flutter/material.dart';
import 'package:pushuptrainer/screens/chart_screen.dart';
import 'package:pushuptrainer/screens/main_screen.dart';
import 'package:pushuptrainer/screens/pushupTest.dart';
import 'package:pushuptrainer/screens/pushup_trainer.dart';
import 'package:pushuptrainer/screens/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/tab_screen.dart';
void main() => runApp(MyApp());

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
      title: 'Protrainer',
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
      home: PushupTest(),
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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Push-ups Trainer'),
      ),
      body: Center(
        child: Text('Navigation Time!'),
      ),
    );
  }
}
