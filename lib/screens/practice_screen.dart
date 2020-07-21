import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_button/awesome_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proximity_plugin/proximity_plugin.dart';
import 'package:pushuptrainerpro/screens/tab_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class PracticeScreen extends StatefulWidget {
  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  var rounds = 5;
  var _currentScore = 0;
  var _practiceRecord=[];
  int currentSet = 6;
  int stopCoount = 0;
  String _proximity;
  String flagg;
  int count = 0;
  int i = 0;
  String t4 = 'Do as many pushups as you can!!!';
  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];

  @override
  initState() {
    super.initState();
    _currentSets();
    initPlatformState();
  }

  initPlatformState() async {

    _streamSubscriptions.add(proximityEvents.listen((ProximityEvent event) {
      setState(() {
        _proximity = event.x;
        flagg = event.x;
        if (((_proximity).compareTo('Yes') == 0)) {
          count += 1;
        }
      });
    }));
  }


  void incrCount(){
    setState(() {
      count=count+1;
    });
  }
  void goBack(BuildContext ctx) {
    _incrementCounter();
    Navigator.of(context).pop(true);
    Navigator.of(ctx).pushReplacementNamed(
      TabsScreen.routeName,
    );
  }
  _currentSets() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if(prefs.containsKey('PracticeHighest')){
        List<String> sumTemp =(prefs.getStringList('PracticeHighest')??'');
        _practiceRecord=sumTemp.map((i) => int.parse(i)).toList();
        _practiceRecord.sort();
        _currentScore=_practiceRecord.last;
      }
    });
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
     _practiceRecord.add(count);
    });
    prefs.setStringList('PracticeHighest', _practiceRecord.map((i) => i.toString()).toList());
    print(count);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamSubscriptions[0].cancel();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height3 = height - padding.top - kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        title: Text('Trainer'),
        automaticallyImplyLeading: false,
      ),
      body: WillPopScope(
        onWillPop: () async => showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(title: Text('Are you sure you want to Stop Practice?'), actions: <Widget>[
                  FlatButton(
                      child: Text('Yes Stop'),
                      onPressed:(){
                        goBack(context);
                      }),
                  FlatButton(
                      child: Text('No continue'),
                      onPressed: () => Navigator.of(context).pop(false)),
                ])),
        child: GestureDetector(
          onTap:incrCount,
          child: Container(
            height: height3,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: height3 * 0.02),
                  height: height3 * 0.2,
                  width: height3 * 0.9,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // ignore: deprecated_member_use
                          AutoSizeText(
                            "Best Overall",
                            style: Theme.of(context).textTheme.title,
                            maxLines: 1,
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: CircleAvatar(
                              radius: 40,
                              child: Text(
                                _currentScore.toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'RobotoCondensed',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: height3 * 0.2,
                  child: FittedBox(
                    child: Image.asset(
                      'assets/images/anim.gif',
                      height: height3 * 0.2,
                      width: width * 0.8,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8),
                  height: height3 * 0.3,
                  width: width,
                  child: FittedBox(
                    child: AwesomeButton(
                      blurRadius: 10.0,
                      splashColor: Color.fromRGBO(255, 255, 255, .4),
                      borderRadius: BorderRadius.circular(500.0),
                      height: height3 * 0.2,
                      width: height3 * 0.2,
                      onTap:incrCount,
                      color: Colors.deepOrange,
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto'),
                      ),
                    ),
                  ),
                ),

                Card(
                  elevation: 8,
                  child: Container(
                    alignment: Alignment.center,
                    height: height3 * 0.15,
                    width: width,
                    padding: EdgeInsets.all(height3*0.01),
                    child: Column(
                      children: <Widget>[
                        AutoSizeText(
                          'NOTE : Bring your face close to the phone or touch the screen',textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Raleway',
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                        AutoSizeText(
                          'Do as many push ups as you can. This is practice session.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Raleway',
                              color: Theme.of(context).primaryColor),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
