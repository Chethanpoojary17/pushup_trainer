import 'dart:ui';

import 'package:awesome_button/awesome_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:pushuptrainer/screens/pushup_trainer.dart';
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
  var setInfo={'Easy':{2,2,2,2,4},'Medium':{6,4,6,4,6},'Hard':{10,8,10,8,10}};
  Map<String,List<int>> myy={'Easy':[2,2,2,2,4],'Medium':[6,4,6,4,6],'Hard':[10,8,10,8,10]};
  String _currentLevel="";

  final Color color = Color.fromRGBO(255, 161, 44, 1);
  @override
  initState() {
    super.initState();
    _loadCounter();
  }
  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      PushupTrainer.routeName,
    );
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLevel = (prefs.getString('Level')??'');
    });
  }
   _changeLevel(String selected) async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     setState(() {
       _currentLevel=selected;
       List<int> newsets;
       if(_currentLevel.compareTo('Easy')==0){
         newsets=myy['Easy'];
       }else if(_currentLevel.compareTo('Medium')==0){
         newsets=myy['Medium'];
       }else{
         newsets=myy['Hard'];
       }
       prefs.setStringList('Sets',newsets.map((i) => i.toString()).toList());
     prefs.setString('Level', _currentLevel);
              });
      }
    Future navigateToSubPage(context) async {
      Navigator.push(context, MaterialPageRoute(builder: (context) => PushupTrainer()));
    }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            Container(
              height: constraints.maxHeight * 0.3,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
                child: FittedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // ignore: deprecated_member_use
                            Text(
                              "Total",
                              style: Theme.of(context).textTheme.title,
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: CircleAvatar(
                                radius: 40,
                                child: Text(
                                  total.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Raleway',
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
                            Text(
                              "Best Overall",
                              style: Theme.of(context).textTheme.title,
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: CircleAvatar(
                                radius: 40,
                                child: Text(
                                  bestscore.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Raleway',
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
                            Text(
                              "Level",
                              style: Theme.of(context).textTheme.title,
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: CircleAvatar(
                                radius: 40,
                                child: Text(
                                 _currentLevel,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Raleway',
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
            Container(
              height: constraints.maxHeight * 0.2,
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: AwesomeButton(
                        blurRadius: 10.0,
                        splashColor: Color.fromRGBO(255, 255, 255, .4),
                        borderRadius: BorderRadius.circular(25.0),
                        height: constraints.maxHeight * 0.1,
                        width: constraints.maxWidth * 0.4,
                        onTap: () => print("tapped"),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Practice",
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
                        height: constraints.maxHeight * 0.1,
                        width: constraints.maxWidth * 0.4,
                        onTap: ()=> showMaterialModalBottomSheet(context:context ,builder: (context, scrollController) => Container(
                          decoration: BoxDecoration(
                            borderRadius:new BorderRadius.all(Radius.circular(20)),
                            gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [Colors.deepOrange, Theme.of(context).accentColor]),
                          ),
                          height: constraints.maxHeight*0.3,
                          child: RadioButtonGroup(
                            activeColor: Colors.black,
                            labelStyle: TextStyle(
                                            color: Colors.black,
                                             fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                             fontFamily: 'RobotoCondensed',
                                                    ),padding: EdgeInsets.all(10),
                              labels: <String>[
                                "Easy",
                                "Medium",
                                "Hard"
                              ],
                              onSelected: (String selected) =>_changeLevel(selected)
                          ),
                        ),
                        elevation: 10,
                          animationCurve: Curves.easeOutExpo,
                          shape: RoundedRectangleBorder(),
                          enableDrag: true,
                          backgroundColor: Colors.white.withOpacity(0)
                        ),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Change level",
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
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
