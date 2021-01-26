import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'package:flutter/animation.dart';
import 'home.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class FinishPage extends StatefulWidget {
  var someScore;
  FinishPage(int _score)
  {
    someScore = _score;
  }
  FinishPageState createState() => FinishPageState(someScore);
}

class FinishPageState extends State<FinishPage> with SingleTickerProviderStateMixin{
  AnimationController controller;
  SequenceAnimation sequenceAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this);
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
        animatable: Tween<double>(begin: 0.0, end: 1.0),
        from: Duration(seconds: 1),
        to: Duration(seconds: 3),
        tag: "opacity1",
        )
        .addAnimatable(
        animatable: Tween<double>(begin: 0.0, end: 1.0),
        from: Duration(seconds: 4),
        to: Duration(seconds: 5),
        tag: "opacity2",
        )
        .addAnimatable(
        animatable: Tween<double>(begin: 0.0, end: 1.0),
        from: Duration(seconds: 6),
        to: Duration(seconds: 7),
        tag: "opacity3",
        )
        .animate(controller);
    myNumGamePlayed++;
    Firestore.instance.collection('account').document(theEmail).updateData({
      'numGamePlayed' : myNumGamePlayed
    });
    controller.forward();
  }

  var theScore;
  FinishPageState(int _score)
  {
    theScore = _score;
  }

  @override
  Widget build(BuildContext context) {

    Widget theResult;
    var importedScore;
    if(theScore > myBestScore)
      {
        myBestScore = theScore;
        Firestore.instance.collection('account').document(theEmail).updateData({
          'numGamePlayed' : myNumGamePlayed,
          'score' : theScore
        });
        theResult = FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Cheer for your',style: TextStyle(fontSize: 40),),
                Text('NEW Record!',style: TextStyle(fontSize: 40, color: Colors.blueAccent),),
              ],
            )
        );
      }
    else
      {
        theResult = FlatButton(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Not your Best Score...',style: TextStyle(fontSize: 40),),
                Text('Try Harder!',style: TextStyle(fontSize: 40, color: Colors.blueAccent),),
              ],
            )
        );
      }

    return Scaffold(
      body:  StreamBuilder(
          stream: Firestore.instance.collection('account').document(theEmail).snapshots(),
        builder: (context, snapshot) {
          return Center(
            child: Column(
              children: <Widget>[
                Expanded(child:Text('')),
                FlatButton(
                  child: Text('RESULT',style: TextStyle(fontSize: 60),),
                ),
                Expanded(child:Text('')),
                FadeTransition(
                      opacity: sequenceAnimation["opacity1"],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            child: Text('You have scored...',style: TextStyle(fontSize: 40),),
                          ),
                          FlatButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('$theScore',style: TextStyle(fontSize: 60, color: Colors.black),),
                                  Text(' points!',style: TextStyle(fontSize: 40),),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),
                Expanded(child:Text('')),
                FadeTransition(
                  opacity: sequenceAnimation["opacity2"],
                  child: theResult
                ),
                Expanded(child:Text('')),
              ],
            ),
          );
        }
      ),
      backgroundColor: Colors.brown,
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: sequenceAnimation["opacity3"],
          child: Container(
            width: 100,
            height: 50,
            child: RaisedButton(
              child: Text('Go Back'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ),
      ),
      resizeToAvoidBottomInset: false,
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