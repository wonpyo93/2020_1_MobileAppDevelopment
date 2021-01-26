import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordchallenge/rule.dart';
import 'login.dart';
import 'play.dart';
import 'profile.dart';

int myBestScore;
int myNumGamePlayed;

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String _theNickname;
  String welcomeMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
    debugPrint("theUID is " + theUid);
    if(theUid != "null")
      {
        _theNickname = theNickname;
      }
    else
      {
        _theNickname = "null";
      }
  }

  void showAlertDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign in with Google First!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay!'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if(_theNickname != "null")
      {
        welcomeMessage = " welcomes you, \n $_theNickname";
      }
    else
      {
        welcomeMessage = "";
      }

    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance.collection('account').document(theEmail).snapshots(),
        builder: (context, snapshot) {
          return Center(
              child: Column(
                children: <Widget>[
                  Expanded(child:Text('')),
                  Expanded(child:Text('')),
                  FlatButton(
                    child: Text('ALPHABET',style: TextStyle(fontSize: 50),),
                  ),
                  FlatButton(
                    child: Text('CHALLENGE',style: TextStyle(fontSize: 60),),
                  ),
                  Expanded(child:Text('')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          height: 50,
                          width: 50,
                          child: FlatButton(
                            child: Image.asset('assets/GoogleIcon.png'),
                            onPressed: () {
                              if(_theNickname != "null")
                                {
                                  debugPrint("already signed in");
                                }
                              else
                                {
                                  debugPrint("signing in~");
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                }
                            },
                            padding: EdgeInsets.all(0.0),
                          )
                      ),
                      Text(welcomeMessage, style: TextStyle(fontSize: 20,color: Colors.black)),
                    ],
                  ),
                  Expanded(child:Text('')),
                  Container(
                    height: 100,
                    width: 300,
                    child: RaisedButton(
                      child: Text('PLAY', style: TextStyle(fontSize: 30),),
                      onPressed: () {
                        if(_theNickname == "null")
                          {
                            debugPrint("null!!");
                            showAlertDialog(context);
                          }
                        else
                          {
                            myBestScore = snapshot.data['score'];
                            myNumGamePlayed = snapshot.data['numGamePlayed'];
                            Navigator.push(context, FadeRoute(page: PlayPage()));
                          }
                      },
                      shape: StadiumBorder(),
                      color: Colors.redAccent,
                    ),
                  ),
                  Expanded(child:Text('')),
                  Container(
                    height: 100,
                    width: 300,
                    child: RaisedButton(
                      child: Text('PROFILE', style: TextStyle(fontSize: 30),),
                      onPressed: () {
                        if(_theNickname == "null")
                        {
                          debugPrint("null!!");
                          showAlertDialog(context);
                        }
                        else
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                        }
                      },
                      shape: StadiumBorder(),
                      color: Colors.blueAccent,
                    ),
                  ),
                  Expanded(child:Text('')),
                  Container(
                    height: 100,
                    width: 300,
                    child: RaisedButton(
                      child: Text('How to Play', style: TextStyle(fontSize: 25),),
                      onPressed: () {

                        Navigator.push(context, MaterialPageRoute(builder: (context) => RulePage()));
                      },
                      shape: StadiumBorder(),
                    ),
                  ),
                  Expanded(child:Text('')),
                  Expanded(child:Text('')),
                ],
              ),
          );
        }
      ),
      backgroundColor: Colors.white,
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: child,
        ),
  );
}