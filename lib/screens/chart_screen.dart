import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fcharts/fcharts.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

class ChartScreen extends StatelessWidget {
  List<Feature> features = [
    Feature(
      title: "Drink Water",
      color: Colors.blue,
      data: [0.2, 0.8, 1, 0.7, 0.6],
    ),
    Feature(
      title: "Exercise",
      color: Colors.pink,
      data: [1, 0.8, 6, 0.7, 0.3, 8],
    ),
  ];
  static const myData = [
    ["A", "✔"],
    ["B", "❓"],
    ["C", "✖"],
    ["D", "❓"],
    ["E", "✖"],
    ["F", "✖"],
    ["G", "✔"],
    ["h", "✔"],
    ["i", "✔"],
    ["j", "✔"],
    ["k", "✔"],
    ["l", "✔"],
    ["m", "✔"],
    ["n", "✔"],
    ["o", "p"],
  ];
  static const myData2 = [
    ["k", "✔"],
    ["l", "✔"],
    ["m", "✔"],
    ["n", "✔"],
    ["o", "p"],
    ["A", "✔"],
    ["B", "❓"],
    ["C", "✖"],
    ["D", "❓"],
    ["E", "✖"],
    ["F", "✖"],
    ["G", "✔"],
    ["h", "✔"],
    ["i", "✔"],
    ["j", "✔"],
  ];
  final routeName = 'chartscreen';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Container(
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
                        "Pushups",
                        "Calories",
                      ],
                      buttonValues: [
                        "Month",
                        "Week",
                      ],
                      autoWidth: true,
                      elevation: 3,
                      radioButtonValue: (value) => print(value),
                      selectedColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight * 0.1,
                    width: constraints.maxWidth * 0.5,
                    padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                    child: CustomRadioButton(
                      padding: 5,
                      enableShape: true,
                      buttonColor: Colors.white,
                      buttonLables: [
                        "Month",
                        "Week",
                      ],
                      buttonValues: [
                        "Month",
                        "Week",
                      ],
                      autoWidth: true,
                      elevation: 3,
                      radioButtonValue: (value) => print(value),
                      selectedColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
//              LineGraph(
//                features: features,
//                size: Size(constraints.maxHeight*0.6, constraints.maxWidth*0.8),
//                labelX: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 2', 'Day 3', 'Day 4', 'Day 5'],
//                labelY: ['20%', '40%', '60%', '80%', '100%'],
//                showDescription: false,
//                graphColor: Colors.black,
//              ),
              Container(
                height: constraints.maxHeight * 0.6,
                child: LineChart(
                  lines: [
                    new Line<List<String>, String, String>(
                      data: myData,
                      xFn: (datum) => datum[0],
                      yFn: (datum) => datum[1],
                    ),
                    new Line<List<String>, String, String>(
                      data: myData2,
                      xFn: (datum) => datum[0],
                      yFn: (datum) => datum[1],
                    ),
                  ],
                  chartPadding: new EdgeInsets.fromLTRB(30.0, 10.0, 10.0, 30.0),
                ),
              ),
              Divider(),
              FittedBox(
                child: Container(
                  height: constraints.maxHeight * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 20,
                          child: Text(''),
                          backgroundColor: Colors.deepOrange,
                        ),
                      ),
                      Text(
                        'PUSHUPS',
                        style: Theme.of(context).textTheme.body1,
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 20,
                          child: Text(''),
                          backgroundColor: Colors.amber,
                        ),
                      ),
                      Text(
                        'CALORIES',
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
