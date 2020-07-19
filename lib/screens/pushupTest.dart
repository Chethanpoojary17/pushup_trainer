import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_button/awesome_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proximity_plugin/proximity_plugin.dart';
import 'package:pushuptrainer/screens/tab_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class PushupTest extends StatefulWidget {
  @override
  _PushupTestState createState() => _PushupTestState();
}

class _PushupTestState extends State<PushupTest> {
  var rounds = 5;
  var currentRound = 1;
  int currentSet = 6;
  int stopCoount = 0;
  String _proximity;
  String flagg;
  int count = 0;
  int i = 0;
  String t4 = 'Do as many pushups as you can!!!';
  String _lvl='Easy';
  List<int> _sets=[1];
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  @override
  initState() {
    super.initState();
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
    Navigator.of(ctx).pushReplacementNamed(
      TabsScreen.routeName,
    );
  }
  _currentSets() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   setState(() {

   });
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {

      if(count<=10){
        _lvl='Easy';
        _sets=[2,2,2,2,4];
      }else
      if(count>10 && count<=20){
        _lvl='Medium';
        _sets=[6,4,6,4,6];
      }else
      if(count>30){
        _lvl='Hard';
        _sets=[10,8,10,8,10];
      }

    });
    prefs.setString('Level', _lvl);
    prefs.setStringList('Sets',_sets.map((i) => i.toString()).toList());
  }
  void setLevel(){


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
      body: GestureDetector(
        onTap:incrCount,
        child: Container(

          height: height3,
          child: Column(
            children: <Widget>[

              Container(
                height: height3 * 0.3,
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
                  height: height3 * 0.2,
                  width: width,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      AutoSizeText(
                        'NOTE : Bring your face close to the phone or touch the screen',textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Raleway',
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                      ),
                      AutoSizeText(
                        'Do as many pushups as you can. This will be used to calculate the level best suited for you.',
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
              GestureDetector(
                onTap: incrCount,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: AwesomeButton(
                    blurRadius: 10.0,
                    splashColor: Color.fromRGBO(255, 255, 255, .4),
                    borderRadius: BorderRadius.circular(25.0),
                    height: height3 * 0.1,
                    width: width * 0.4,
                    onTap: (){
                      goBack(context);
                    },
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoCondensed',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
