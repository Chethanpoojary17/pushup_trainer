import 'dart:math';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_button/awesome_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:pushuptrainerpro/screens/practice_screen.dart';
import 'package:pushuptrainerpro/screens/pushup_trainer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MainScreen extends StatefulWidget {
  static const routeName = 'mainscreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var bestscore = 20;

  var total = 20;
  var clvl = 2;
  var setInfo = {
    'Easy': {2, 2, 2, 2, 4},
    'Medium': {6, 4, 6, 4, 6},
    'Hard': {10, 8, 10, 8, 10}
  };
  Map<String, List<int>> myy = {
    'Easy': [2, 2, 2, 2, 4],
    'Medium': [6, 4, 6, 4, 6],
    'Hard': [10, 8, 10, 8, 10]
  };
  String _currentLevel = "";
  var _sumRecord = [], _total = 0, _best = 0;

  final Color color = Color.fromRGBO(255, 161, 44, 1);

  @override
  initState() {
    super.initState();
    _loadCounter();
  }

  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushReplacementNamed(
      PushupTrainer.routeName,
    );
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey('sumRecord')) {
        List<String> sumTemp = (prefs.getStringList('sumRecord') ?? '');
        _sumRecord = sumTemp.map((i) => int.parse(i)).toList();
        _sumRecord.asMap().forEach((index, value) {
          _total = value + _total;
        });
      }
      _currentLevel = (prefs.getString('Level') ?? '');
      _sumRecord.sort();
      _best = _sumRecord.isEmpty ? _best : _sumRecord.last;
    });
  }

  _changeLevel(String selected) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLevel = selected;
      List<int> newsets;
//       if(_currentLevel.compareTo('Easy')==0){
//         newsets=myy['Easy'];
//       }else if(_currentLevel.compareTo('Medium')==0){
//         newsets=myy['Medium'];
//       }else{
//         newsets=myy['Hard'];
//       }
//       prefs.setStringList('Sets',newsets.map((i) => i.toString()).toList());
      prefs.setString('Level', _currentLevel);
    });
  }

  Future navigateToSubPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PushupTrainer()));
  }

  _getCheckList(String title, double width){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            setState(() {
              _currentLevel = title;
              Navigator.pop(context);
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width*0.08),
            child: Row(
              children: [
                Icon(
                  _currentLevel == title ? Icons.check_box: Icons.check_box_outline_blank,
                  color: _currentLevel == title ? Colors.deepOrange:Colors.black,
                ),
                SizedBox(width: width*0.02,),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return WillPopScope(
          onWillPop: () async => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                      title: Text('Are you sure you want to quit?'),
                      actions: <Widget>[
                        FlatButton(
                            child: Text('Exit'),
                            onPressed: () => Navigator.of(context).pop(true)),
                        FlatButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(false)),
                      ])),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: constraints.maxHeight * 0.02),
                height: constraints.maxHeight * 0.3,
                width: constraints.maxWidth * 0.9,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 10,
                  child: FittedBox(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.05),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // ignore: deprecated_member_use
                                AutoSizeText(
                                  "Total",
                                  style: Theme.of(context).textTheme.title,
                                  maxLines: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: CircleAvatar(
                                    radius: 40,
                                    child: Text(
                                      _total.toString(),
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
                          Container(
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
                                      _best.toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'RobotoCondensed',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                AutoSizeText(
                                  "Level",
                                  style: Theme.of(context).textTheme.title,
                                  maxLines: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: CircleAvatar(
                                    radius: 40,
                                    child: Text(
                                      _currentLevel,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'RobotoCondensed',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Divider(),
              Container(
                height: constraints.maxHeight * 0.15,
                child: FittedBox(
                    child: Hero(
                  tag: 'protrainer',
                  child: Image.asset(
                    'assets/images/anim.gif',
                    height: constraints.maxHeight * 0.2,
                    width: constraints.maxWidth * 0.8,
                    fit: BoxFit.cover,
                  ),
                )),
              ),
              Divider(),
              Container(
                height: constraints.maxHeight * 0.2,
                padding: EdgeInsets.all(9),
                child: FittedBox(
                  child: AwesomeButton(
                    blurRadius: 10.0,
                    splashColor: Color.fromRGBO(255, 255, 255, .4),
                    borderRadius: BorderRadius.circular(500.0),
                    height: 100.0,
                    width: 100.0,
                    onTap: () {
                      selectCategory(ctx);
                    },
                    color: Colors.deepOrange,
                    child: Image.asset(
                      'assets/images/gym.png',
                      height: 70.0,
                      width: 70.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      AwesomeButton(
                        blurRadius: 10.0,
                        splashColor: Color.fromRGBO(255, 255, 255, .4),
                        borderRadius: BorderRadius.circular(25.0),
                        height: constraints.maxHeight * 0.1,
                        width: constraints.maxWidth * 0.4,
                        onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => PracticeScreen())),
                        color: Theme.of(context).primaryColor,
                        child: AutoSizeText(
                          "Practice",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                      ),
                      AwesomeButton(
                        blurRadius: 10.0,
                        splashColor: Color.fromRGBO(255, 255, 255, .4),
                        borderRadius: BorderRadius.circular(25.0),
                        height: constraints.maxHeight * 0.1,
                        width: constraints.maxWidth * 0.4,
                        onTap: () => showMaterialModalBottomSheet(
                            context: context,
                            builder: (context, scrollController) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20)),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: constraints.maxHeight*0.02,),
                                      Text("Select Level",style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,)),
                                      SizedBox(height: constraints.maxHeight*0.01,),
                                      SizedBox(height: constraints.maxHeight*0.01,),
                                      _getCheckList("Easy", constraints.maxWidth),
                                      Container(width: constraints.maxWidth*0.9,height: 2,color: Colors.deepOrange,),
                                      _getCheckList("Medium", constraints.maxWidth),
                                      Container(width: constraints.maxWidth*0.9,height: 2,color: Colors.deepOrange,),
                                      _getCheckList("Hard", constraints.maxWidth),
                                      SizedBox(height: constraints.maxHeight*0.02,),
                                    ],
                                  ),
                                ),
                            elevation: 10,
                            animationCurve: Curves.easeOutExpo,
                            shape: RoundedRectangleBorder(),
                            enableDrag: true,
                            backgroundColor: Colors.white.withOpacity(0)),
                        color: Theme.of(context).primaryColor,
                        child: AutoSizeText(
                          "Change level",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoCondensed',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
