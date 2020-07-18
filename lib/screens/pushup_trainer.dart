import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_button/awesome_button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proximity_plugin/proximity_plugin.dart';
import 'package:pushuptrainer/models/recordData.dart';
import 'dart:async';

import 'package:pushuptrainer/screens/main_screen.dart';
import 'package:pushuptrainer/screens/tab_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushupTrainer extends StatefulWidget {
  static const routeName = '/pushuptrainer';

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<PushupTrainer> {
  var rounds=5;
  var currentRound=1;
  int currentSet=6;
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
  var _sets;
 List<RecordDate> _record=[];
  var nnn=[{}];

  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  @override
  initState() {
    super.initState();
    initPlatformState();
    getCurrentSets();
    _saveState();
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
      setindex=setindex+1;
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
     if(chckbit==1){

     if(prefs.containsKey('Recordss'))
       {  var rjson=(prefs.getString('Recordss')??'');
         var tagObjsJson = jsonDecode(rjson)['_record'] as List;
       List tagObjs = tagObjsJson.map((tagJson) => RecordDate.fromJson(tagJson)).toList();
       print(tagObjs);
       }
       for(int x=0;x<_sets.length;x++){
        sum=_sets[x]+sum;
        print(sum);
       }
       _record.add(RecordDate(DateFormat('yyyy-MM-dd').format(DateTime.now()),summ));
            prefs.setString('Recordss', jsonEncode(_record));
            print(_record);
//       var parsed=jsonDecode(prefs.getString('RecordsList')??'') as List<Map<dynamic,dynamic>>;
//       print(parsed[0]);
//       print(summ);
//       nnn.add(RecordDate('date':DateFormat('yyyy-MM-dd').format(DateTime.now()),'sum':summ));
//       prefs.setString('RecordList', jsonEncode(nnn));
       print(Level);
       if(Level.compareTo('Easy')==0){
       for(int x=0;x<_sets.length;x++){
         _sets[x]=_sets[x]+2;
       }}else if(Level.compareTo('Medium')==0)
         {
           for(int x=0;x<_sets.length;x++){
             _sets[x]=_sets[x]+2;
         }}else if(Level.compareTo('Hard')==0) {
         for (int x = 0; x < _sets.length; x++) {
           _sets[x] = _sets[x] + 4;
         }
       }
       prefs.setStringList('Sets',_sets.map((i) => i.toString()).toList());
     }
   });
  }
  void incrCount(){
    setState(() {
      count=count+1;
    });
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    _streamSubscriptions.add(proximityEvents.listen((ProximityEvent event) {
      if(count<currentSet)
      setState(() {
        _proximity = event.x;
        flagg = event.x;
        print(event.x);
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
                 summ=summ+currentSet;
                 currentRound=2;
                }else
        if(setindex==4 && count==currentSet){
          chckbit=1;

        }
      });
    }));
  }
  void goBack(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
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
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Container(
              alignment: Alignment.center,
              height: height3 * 0.1,
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
                        fontSize: 20,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.center,
              height: height3 * 0.1,
              width: width,
              padding: EdgeInsets.all(8),
              child: Text(
                t4,
                style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontSize: 30,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
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
                onTap: () {},
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
                    onTap:_saveState,
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
                    onTap:() {
                      goBack(context);
                    },
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
                  duration:  Duration(seconds: 3),
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
    );
  }
}
