import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fcharts/fcharts.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  var _dateRecord=[],_sumRecord=[],_dateWeek=[];
  var _dateMonth=[];
  static List<double> _mapDataWeek=[];
  List<String> _maplabel=[];
  List<String> _maplabel2=[];
  var _mwbit;
  bool _isLoad = true;

  final routeName = 'chartscreen';
  @override
  initState() {
    super.initState();
    _getData();
    _changeMap("Week");
    //getDates();
  }
  _getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey('dateRecord')&&  prefs.containsKey('sumRecord')) {
        _dateRecord = (prefs.getStringList('dateRecord') ?? '');
        List<String> sumTemp = (prefs.getStringList('sumRecord') ?? '');
        _sumRecord = sumTemp.map((i) => int.parse(i)).toList();
        var _revdate = _dateRecord.reversed.toList();
        var _revSum = _sumRecord.reversed.toList();
        if (_dateRecord.length >= 7) {
          _maplabel2 = List.generate(7, (index) =>
              DateFormat('MM-dd').format(
                  (DateTime.parse(_revdate.elementAt(index)))));
        } else {
          _maplabel2 = List.generate(_revdate.length, (index) =>
              DateFormat('MM-dd').format(
                  (DateTime.parse(_revdate.elementAt(index)))));
        }
        _mapDataWeek.clear();
        int index2;
        (_revdate.length >= 7) ? index2 = 7 : index2 = _revdate.length;
        for (int index = 0; index < index2; index++) {
          if (_revSum[index] == 0) {
            _mapDataWeek.add(0);
          }
          else if (_revSum[index] > 0 && _revSum[index] < 50) {
            _mapDataWeek.add(0.1);
          }
          else if (_revSum[index] == 50) {
            _mapDataWeek.add(0.2);
          }
          else if (_revSum[index] > 50 && _revSum[index] < 100) {
            _mapDataWeek.add(0.3);
          }
          else if (_revSum[index] == 100) {
            _mapDataWeek.add(0.4);
          }
          else if (_revSum[index] > 100 && _revSum[index] < 150) {
            _mapDataWeek.add(0.5);
          }
          else if (_revSum[index] == 150) {
            _mapDataWeek.add(0.6);
          }
          else if (_revSum[index] > 150 && _revSum[index] < 200) {
            _mapDataWeek.add(0.7);
          }
          else if (_revSum[index] == 200) {
            _mapDataWeek.add(0.8);
          }
          else if (_revSum[index] > 200 && _revSum[index] < 250) {
            _mapDataWeek.add(0.9);
          }
          else {
            _mapDataWeek.add(1);
          }
        }
      }
    setState(() {
      _isLoad = false;
    });
  }
  List<Feature> features = [
    Feature(
      title: "Drink Water",
      color: Colors.blue,
      data: _mapDataWeek.map((dynamic item) => item as double)?.toList(),
    )
  ];
  _changeMap(String value) async{
    setState(() {
      _mwbit=value;
    });

  }
  List<Map<String, Object>> get groupedValues {
    if(_dateRecord.isNotEmpty) {
      return List.generate(_dateRecord.length, (index) {
        return {
          'day': _dateRecord[index],
          'amount': _sumRecord[index],
        };
      }).toList();
    }else{
      return List.generate(1, (index) {
        return {
          'day': "",
          'amount':"",
        };
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: constraints.maxHeight * 0.1,
                      width: constraints.maxWidth * 0.5,
                      padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                      child: CustomRadioButton(
                        padding: 5,
                        enableShape: true,
                        buttonColor: Colors.white,
                        buttonLables: [
                          "Week",
                          "History",
                        ],
                        buttonValues: [
                          "Week",
                          "Month",
                        ],
                        autoWidth: true,
                        elevation: 3,
                        radioButtonValue: (value) => _changeMap(value),
                        selectedColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                (_mwbit=='Week')?_isLoad?Align(alignment: Alignment.center,child:SpinKitRotatingCircle(
                  color: Colors.deepOrange,
                  size: 50.0,
                )):Expanded(
                  child: (_dateRecord.length>=2)?LineGraph(
                    features: features,
                    size: Size(constraints.maxHeight*0.6, constraints.maxWidth*0.8) ,
                    labelX: _maplabel2.map((dynamic item) => item as String)?.toList(),
                    labelY: ['50', '100', '150', '200', '250'],
                    showDescription: false,
                    graphColor: Colors.black,
                  ):
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[

                      Container(
                        padding: EdgeInsets.all(constraints.maxHeight*0.01),
                        height: constraints.maxHeight*0.5,
                        child: Image.asset('assets/images/anim_nothing.gif',fit: BoxFit.cover,),
                      ),
                      Card(
                        elevation: 5,
                        child: AutoSizeText('Note: Graph will be displayed once you have 2 or more records.',style: TextStyle(color: Colors.deepOrange,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            fontFamily: 'RobotoCondensed'),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ) : _isLoad?Align(alignment: Alignment.center,child:SpinKitRotatingCircle(
                  color: Colors.deepOrange,
                  size: 50.0,
                )):Expanded(
                  child:(_dateRecord.isNotEmpty)? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      return Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 5,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 40,
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: FittedBox(
                                child: AutoSizeText(groupedValues[index]['amount'].toString(),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            groupedValues[index]['day'],
                            style: Theme.of(context).textTheme.title,
                          ),
                          subtitle: AutoSizeText('Total Push ups'),
                        ),
                      );
                    },
                    itemCount: groupedValues.length,
                  ):

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[

                      Container(
                        padding: EdgeInsets.all(constraints.maxHeight*0.01),
                        height: constraints.maxHeight*0.5,
                        child: Image.asset('assets/images/anim_nothing.gif',fit: BoxFit.cover,),
                      ),
                      Card(
                        elevation: 5,
                        child: AutoSizeText('Note: Records database is currently empty, Train now and update the database.',style: TextStyle(color: Colors.deepOrange,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            fontFamily: 'RobotoCondensed'),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}