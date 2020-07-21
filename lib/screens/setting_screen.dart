import 'package:auto_size_text/auto_size_text.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final routeName='settingscreen';
  Future<void> _launched;
  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'xtoinfinity18@gmail.com',
      queryParameters: {
        'subject': 'Feedback Pushup Trainer Pro'
      }
  );
  _launchURL() async {
    const url = 'https://www.instagram.com/x_to_infinity/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _clearSharedPrefs(BuildContext ctx) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.clear();
    });
    Navigator.of(ctx).pop(true);
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height3 = height - padding.top - kToolbarHeight;
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Card(
            shape: CircleBorder(),
            elevation: 8,
            child: Container(
              padding: EdgeInsets.all(height3*0.01),
              height: height3*0.2,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/images/xlog.png',height:height3*0.15,width: width*0.3,),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(height3*0.01),
            height: height3*0.15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AutoSizeText('X TO INFINITY',style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: 30),
                  maxLines: 1,textAlign: TextAlign.center,),
                InkWell(
                  onTap: _launchURL,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Ionicons.logo_instagram,size: height3*0.04,color: Colors.black,),
                        onPressed: _launchURL,
                      ),
                      AutoSizeText('x_to_infinity',style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: 15),
                        maxLines: 1,textAlign: TextAlign.center,),
                    ],
                  ),
                )
              ],
            ),
          ),
                Card(
                elevation: 5,
                 child:   InkWell(
                  onTap: ()=>setState(() {
                    print('uu');
                    launch(_emailLaunchUri.toString());
                         }),
                   splashColor: Theme.of(context).accentColor,
                    child: Container(
                     padding: EdgeInsets.all(height3*0.01),
                     height: height3*0.07,
                     width: width,
                        child: Row(
                           children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: height3*0.01),
                              child: Icon(MaterialIcons.feedback,size: height3*0.04,),
                                ),
                           AutoSizeText(
                             'Feedback Email',style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: 25),
                               maxLines: 1,textAlign: TextAlign.start,
                             ),
                         ],
                      ),
                   ),
                ),
              ),
          Builder(builder: (BuildContext context){
            return  Card(
              elevation: 5,
              child:   InkWell(
                onTap: (){

                  final RenderBox box = context.findRenderObject();
                  Share.share('check out Pushup Trainer Pro https://play.google.com/store/apps/details?id=com.xti.pushuptrainerpro',
                      subject: 'My personal Trainer',
                      sharePositionOrigin:
                      box.localToGlobal(Offset.zero) &
                      box.size);
                },
                splashColor: Theme.of(context).accentColor,
                child: Container(
                  padding: EdgeInsets.all(height3*0.01),
                  height: height3*0.07,
                  width: width,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: height3*0.01),
                        child: Icon(MaterialIcons.share,size: height3*0.04,),
                      ),
                      AutoSizeText(
                        'Share',style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: 25),
                        maxLines: 1,textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },),

          Card(
            elevation: 5,
            child:   InkWell(
              onTap: () async => showDialog(
                     context: context,
                     builder: (context) =>
                        AlertDialog(title: Text('Are you sure you want to Clear?'),
                            content: Text('Note: This will delete everything and application will need a restart.',),
                            actions: <Widget>[
                          FlatButton(
                            child: Text('Clear'),
                           onPressed: (){
                             _clearSharedPrefs(context);
                           }),
                            FlatButton(
                            child: Text('Cancel'),
                           onPressed: () => Navigator.of(context).pop(false)),
                        ])),
              splashColor: Theme.of(context).accentColor,
              child: Container(
                padding: EdgeInsets.all(height3*0.01),
                height: height3*0.07,
                width: width,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: height3*0.01),
                      child: Icon(MaterialIcons.restore,size: height3*0.04,),
                    ),
                    AutoSizeText(
                      'Clear Records',style: TextStyle(fontFamily: 'RobotoCondensed',fontSize: 25),
                      maxLines: 1,textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AutoSizeText(
            'Pushup Trainer pro',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 10,
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
          ),
        ],
      ),
    );
  }
}
