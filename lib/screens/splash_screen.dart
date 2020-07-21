import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pushuptrainerpro/screens/pushupTest.dart';
import 'package:pushuptrainerpro/screens/tab_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _level = true;

  @override
  void initState() {
    super.initState();
    _getLevel();
  }

  _getLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('Level')) {
      _level = false;
    }
    if (_level) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => PushupTest())));
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => TabsScreen())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/anim.gif",
              height: _mediaQuery.height * 0.2,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: _mediaQuery.height * 0.005,
            ),
            Container(
              height: _mediaQuery.height * 0.045,
              width: _mediaQuery.width * 0.5,
              alignment: Alignment.center,
              child: AutoSizeText(
                "Pushup Trainer Pro",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 40,
                    fontFamily: 'RobotoCondensed'),
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
            AutoSizeText(
              'Made in india',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  fontFamily: 'RobotoCondensed'),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
            AutoSizeText(
              'Version : 1.0.0',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  fontFamily: 'RobotoCondensed'),
              maxLines: 1,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
