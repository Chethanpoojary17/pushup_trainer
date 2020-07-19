import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final routeName='settingscreen';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(title: Text('Are you sure you want to quit?'), actions: <Widget>[
                FlatButton(
                    child: Text('Exit'),
                    onPressed: () => Navigator.of(context).pop(true)),
                FlatButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(false)),
              ])),
      child: Container(

      ),
    );
  }
}
