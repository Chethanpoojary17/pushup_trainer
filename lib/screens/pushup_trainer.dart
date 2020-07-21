import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_button/awesome_button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proximity_plugin/proximity_plugin.dart';
import 'package:pushuptrainerpro/models/recordData.dart';
import 'dart:async';

import 'package:pushuptrainerpro/screens/main_screen.dart';
import 'package:pushuptrainerpro/screens/tab_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushupTrainer extends StatefulWidget {
  static const routeName = '/pushuptrainer';

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<PushupTrainer> {
  var rounds=5;
  var currentRound=1;
  int currentSet=0;
  int stopCoount=0;
  int summ=0;
  String _proximity;
  String flagg;
  int setindex=-1;
  int chckbit=0;
  int count = 0;
  int i=0;
  String t4='Start';
  String t2='One more';
  String t3='Stop';
  String Level="";
  var _sets=[];
  var saveBit=0;
 List<RecordDate> _record=[];
  var nnn=[{}];
  var _dateRecord=[DateFormat('yyyy-MM-dd').format(DateTime.now())],_sumRecord=[0];

  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  @override
  initState() {
    super.initState();
    initPlatformState();
    getCurrentSets();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamSubscriptions[0].cancel();
  }
  nextSets() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      List<String> setstemp =(prefs.getStringList('Sets')??'');
      _sets=setstemp.map((i) => int.parse(i)).toList();
      Level=(prefs.getString('Level')??'');
      setindex=0;
      currentSet=_sets[setindex];
      count=0;
      t4='Start';
      t3=setstemp.toString();
      chckbit=0;
      saveBit=0;
    });
  }
   nextRound() async
  {
    setState(() {
      if(setindex<4 && count==currentSet){
        this.count=0;
        this.t4="Start";
        setindex=setindex+1;
      }else{
        chckbit=1;
      }
    });
    currentSet=_sets[setindex];
  }
  getCurrentSets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      List<String> setstemp =(prefs.getStringList('Sets')??'');
      _sets=setstemp.map((i) => int.parse(i)).toList();
      Level=(prefs.getString('Level')??'');
      setindex=0;
      currentSet=_sets[setindex];
      count=0;
      t4='Start';
      t3=setstemp.toString();
    });
  }
  _saveState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sum=0;
    setState(() {
      if(saveBit==0) {
       if(prefs.containsKey('dateRecord')&&prefs.containsKey('sumRecord')){
         _dateRecord=(prefs.getStringList('dateRecord')??'') as List<String>;
         List<String> sumTemp =(prefs.getStringList('sumRecord')??'');
         _sumRecord=sumTemp.map((i) => int.parse(i)).toList();
       }
       if(_dateRecord.last==(DateFormat('yyyy-MM-dd').format(DateTime.now()))){
         var sss=0;
         _sets.asMap().forEach((key, value) { sss=sss+value; });
         _sumRecord[_dateRecord.length-1]=_sumRecord[_dateRecord.length-1]+sss;
       }else{
         _dateRecord.add((DateFormat('yyyy-MM-dd').format(DateTime.now())));
         _sumRecord.add(summ);
       }
       prefs.setStringList('dateRecord', _dateRecord);
       prefs.setStringList('sumRecord', _sumRecord.map((i) => i.toString()).toList());
       print(Level);
       if(Level.compareTo('Easy')==0){
         print(_sets);
         _sets.asMap().forEach((index, value) {
           _sets[index]=_sets[index]+2;
           print(_sets[index]);
         });
       }else if(Level.compareTo('Medium')==0)
         {
           _sets.asMap().forEach((index, value) {
             _sets[index]=_sets[index]+4;
             print(_sets[index]);
           });
           }else if(Level.compareTo('Hard')==0) {
         _sets.asMap().forEach((index, value) {
           _sets[index] = _sets[index] + 6;
           print(_sets[index]);
         });
       }
      saveBit=1;
      }
       prefs.setStringList('Sets',_sets.map((iii) => iii.toString()).toList());
       print('out');
//     getCurrentSets();
   });
  }
  initPlatformState() async {
    _streamSubscriptions.add(proximityEvents.listen((ProximityEvent event) {
      setState(() {
        _proximity = event.x;
        flagg = event.x;
        if (((_proximity).compareTo('Yes') == 0) && count<currentSet) {
          count += 1;
        }
        if(count==1)
          {
           t4='Yes';
          }else if(count==(currentSet*0.5))
            {
             t4='More';
            }else if(count==(currentSet-1))
              {
                t4='One last';
              }else if(count==currentSet)
                {
                 t4='Stop';
                }
        if(setindex==4 && count==currentSet){
          chckbit=1;
          _saveState();
        }
      });
//      if(setindex==4 && count==currentSet){
//        print('yyyysysys');
//        _saveState();
//      }
    }));
  }
  void goBack(BuildContext ctx) {
    Navigator.of(context).pop(true);
    Navigator.of(ctx).pushReplacementNamed(
      TabsScreen.routeName,
    );
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
                AlertDialog(title: Text('Are you sure you want to Stop Training?'), actions: <Widget>[
                  FlatButton(
                      child: Text('Yes Stop'),
                      onPressed:(){
                        goBack(context);
                      }),
                  FlatButton(
                      child: Text('No continue'),
                      onPressed: () => Navigator.of(context).pop(false)),
                ])),
        child: Column(
          children: <Widget>[
            Card(
              child: Container(
                alignment: Alignment.center,
                height: height3 * 0.15,
                width: width,
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    AutoSizeText(
                      'Sets of push ups for today : $t3',
                      style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                      maxLines: 2,
                    ),
                    AutoSizeText(
                      'Current Round: $currentSet push ups.',
                      style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: 18,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                alignment: Alignment.center,
                height: height3 * 0.075,
                width: width,
                padding: EdgeInsets.all(8),
                child: AutoSizeText(
                  t4,
                  style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontSize: 30,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
              ),
            ),
            Container(
              height: height3 * 0.3,
              child: FittedBox(
                child: Hero(
                  tag: 'protrainer',
                  child: Image.asset(
                    'assets/images/anim.gif',
                    height: height3 * 0.2,
                    width: width * 0.8,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              height: height3 * 0.3,
              child: FittedBox(
                child: AwesomeButton(
                  blurRadius: 10.0,
                  splashColor: Color.fromRGBO(255, 255, 255, .4),
                  borderRadius: BorderRadius.circular(500.0),
                  height: height3 * 0.2,
                  width: height3 * 0.2,
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
            Container(
              child: (chckbit==1)?Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AwesomeButton(
                      blurRadius: 10.0,
                      splashColor: Color.fromRGBO(255, 255, 255, .4),
                      borderRadius: BorderRadius.circular(25.0),
                      height: height3* 0.1,
                      width: width * 0.4,
                      onTap:nextSets,
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
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: AwesomeButton(
                      blurRadius: 10.0,
                      splashColor: Color.fromRGBO(255, 255, 255, .4),
                      borderRadius: BorderRadius.circular(25.0),
                      height: height3* 0.1,
                      width: width * 0.4,
                      onTap:() => Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => TabsScreen())),
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Take Break",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'RobotoCondensed',
                        ),
                      ),
                    ),
                  ),
                ],
              ):Padding(
                padding: EdgeInsets.all(8.0),
                child: AwesomeButton(
                  blurRadius: 10.0,
                  splashColor: Color.fromRGBO(255, 255, 255, .4),
                  borderRadius: BorderRadius.circular(25.0),
                  height: height3* 0.1,
                  width: width * 0.4,
                  onTap:(count==currentSet) ? nextRound:()=> Flushbar(
                    backgroundColor: Theme.of(context).primaryColor,
                    title:  "Hey Hustler",
                    message:  "Please complete the current set",
                    duration:  Duration(seconds: 2),
                  )..show(context),
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    "Next Round",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'RobotoCondensed',
                    ),
                  ),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
