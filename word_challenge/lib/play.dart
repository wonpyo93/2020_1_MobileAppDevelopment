import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'finish.dart';
import 'login.dart';
import 'dart:async';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class PlayPage extends StatefulWidget {
  final String title = 'Registration';
  @override
  PlayPageState createState() => PlayPageState();
}

class PlayPageState extends State<PlayPage> with SingleTickerProviderStateMixin{
  AnimationController animController;
  SequenceAnimation sequenceAnimation;
  var _randomWord = '';
  List<String> selectedWordChars = <String>['@','','','','','','','','','',''];
  List<String> typedWordChars = <String>['→','','','','','','','','','',''];
  Timer _timer;
  int _start = 60;
  int _score = 0;
  var currentLetter = 1;
  var numTypedLetters = 1;
  List<String> _questions = [];
  Animation<double> animation;
  AnimationController controller;
  int errorTriggered = 0; //wrong alphabet
  int invalidTriggered = 0; //wrong word
  String errorMessage = "";

  void scoreUpdate(int toUpdate)
  {
    _score = _score + toUpdate;
  }

  void startTimer()
  {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) => setState(
            () {
          if(_start < 0.1)
          {
            timer.cancel();
          }
          else
          {
            _start = _start - 1;
            if(_start < 1)
              {
                //Finish the game
                timerDispose();
                Navigator.pop(context);
                Navigator.push(context, FadeRoute(page: FinishPage(_score)));
              }
          }
        }
    ));
  }

  void createRandomWord()
  {
    int numberLetters = 0;
    while(numberLetters > 9 || numberLetters < 3) {
      _randomWord = WordPair
          .random()
          .asUpperCase;
      numberLetters = _randomWord.length;
    }
    print(_randomWord);
    for(int i = 1; i < _randomWord.length + 1; i ++)
      {
        selectedWordChars[i] = _randomWord[i-1];
      }
  }

  void timerDispose()
  {
    _timer.cancel();
  }

  Future<List<String>> _loadQuestions() async {
    List<String> questions = [];
    await rootBundle.loadString('assets/words.txt').then((q) {
      for (String i in LineSplitter().convert(q)) {
        questions.add(i);
      }
    });
    return questions;
  }

  _setup() async {
    // Retrieve the questions (Processed in the background)
    List<String> questions = await _loadQuestions();

    // Notify the UI and display the questions
    setState(() {
      _questions = questions;
    });
    print(_questions[1]);
  }

  // ignore: must_call_super
  void initState()
  {
    _setup();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Press Start when Ready!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Start'),
                onPressed: () {
                  Navigator.pop(context);
                  createRandomWord();
                  startTimer();
                },
              )
            ],
          );
        }));
    animController = AnimationController(vsync: this);
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
      animatable: ColorTween(begin: Colors.teal, end: Colors.red),
      from: Duration(seconds: 0),
      to: Duration(seconds: 60),
      tag: "theColor",
    )
        .animate(animController);
    animController.forward();
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Widget showLetters(BuildContext context)
    {
      var textFields = <Text>[];
      var list = new List<int>.generate(_randomWord.length + 1, (i) => i + 1 );

      list.forEach((i) {
        if(i == currentLetter + 1)
          {
            return textFields.add(new Text(selectedWordChars[i-1], style: TextStyle(fontSize: 60,decoration: TextDecoration.underline)));
          }
        else
          {
            return textFields.add(new Text(selectedWordChars[i-1], style: TextStyle(fontSize: 50)));
          }
      });

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: textFields,
      );
    }

    Widget typedLetters(BuildContext context)
    {
      var textFields = <Text>[];
      var list = new List<int>.generate(numTypedLetters, (i) => i+1);
      
      list.forEach((i) {
        return textFields.add(new Text(typedWordChars[i-1], style: TextStyle(fontSize: 60)));
      });

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: textFields,
      );
    }

    void resetErrorTrigger()
    {
      errorTriggered = 0;
    }

    Widget showErrorMessage(BuildContext context)
    {
      return AnimatedDefaultTextStyle(
        curve: Curves.bounceInOut,
        style: errorTriggered == 1
            ? TextStyle(
            fontSize: 30,
            color: Colors.red,
            fontWeight: FontWeight.bold)
            : TextStyle(
            fontSize: 0.0,
            color: Colors.black,
            fontWeight: FontWeight.w100),
        duration: const Duration(milliseconds: 400),
        child: Text(errorMessage),
        onEnd: resetErrorTrigger,
      );
    }


    void letterType(BuildContext context, var letter)
    {
      if(numTypedLetters == 1 && selectedWordChars[currentLetter] == letter)
      {//첫 알파벳
        typedWordChars[numTypedLetters] = letter;
        numTypedLetters++;
        errorTriggered = 0;
        errorMessage = "";
        setState(() {});
      }
      else if(numTypedLetters == 1 && selectedWordChars[currentLetter] != letter)
      {
        print('Invalid Input');
        errorMessage = "First alphabet must Match!";
        errorTriggered = 1;
      }
      else
      {
        typedWordChars[numTypedLetters] = letter;
        numTypedLetters++;
        errorMessage = "";
        errorTriggered = 0;
        setState(() {});
      }
    }

    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance.collection('account').document(theEmail).snapshots(),
        builder: (context, snapshot) {
          return Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 30,),
                RaisedButton(
                  color: Colors.pinkAccent,
                  child: Text('I Give Up :('),
                  onPressed: () {
                    timerDispose();
                    Navigator.pop(context);
                    //Navigator.pop(context, FadeRoute());

                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        margin: new EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Text('  $_score',style: TextStyle(fontSize: 50, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
                          ],
                        )
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        margin: new EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.timer,color: Colors.white,),
                            Text('  $_start',style: TextStyle(fontSize: 50,color: Colors.white),),
                          ],
                        )
                      ),
                    ),
                  ],
                ),
                showLetters(context),
                SizedBox(height: 150,),
                typedLetters(context),
                SizedBox(height: 75,),
                showErrorMessage(context),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      height: screenHeight / 4,
                      child: Column(
                        children: <Widget>[
                          Expanded(child: Text(''),),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('Q'),
                                  onPressed: () {
                                    letterType(context, 'Q');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('W'),
                                  onPressed: () {
                                    letterType(context, 'W');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('E'),
                                  onPressed: () {
                                    letterType(context, 'E');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('R'),
                                  onPressed: () {
                                    letterType(context, 'R');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('T'),
                                  onPressed: () {
                                    letterType(context, 'T');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('Y'),
                                  onPressed: () {
                                    letterType(context, 'Y');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('U'),
                                  onPressed: () {
                                    letterType(context, 'U');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('I'),
                                  onPressed: () {
                                    letterType(context, 'I');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('O'),
                                  onPressed: () {
                                    letterType(context, 'O');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('P'),
                                  onPressed: () {
                                    letterType(context, 'P');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                            ],
                          ),
                          Expanded(child: Text(''),),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('A'),
                                  onPressed: () {
                                    letterType(context, 'A');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('S'),
                                  onPressed: () {
                                    letterType(context, 'S');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('D'),
                                  onPressed: () {
                                    letterType(context, 'D');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('F'),
                                  onPressed: () {
                                    letterType(context, 'F');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('G'),
                                  onPressed: () {
                                    letterType(context, 'G');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('H'),
                                  onPressed: () {
                                    letterType(context, 'H');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('J'),
                                  onPressed: () {
                                    letterType(context, 'J');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('K'),
                                  onPressed: () {
                                    letterType(context, 'K');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('L'),
                                  onPressed: () {
                                    letterType(context, 'L');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                            ],
                          ),
                          Expanded(child: Text(''),),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text(''),),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('Z'),
                                  onPressed: () {
                                    letterType(context, 'Z');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('X'),
                                  onPressed: () {
                                    letterType(context, 'X');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('C'),
                                  onPressed: () {
                                    letterType(context, 'C');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('V'),
                                  onPressed: () {
                                    letterType(context, 'V');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('B'),
                                  onPressed: () {
                                    letterType(context, 'B');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('N'),
                                  onPressed: () {
                                    letterType(context, 'N');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 11,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  child: Text('M'),
                                  onPressed: () {
                                    letterType(context, 'M');
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                              SizedBox(
                                width: screenWidth / 6,
                                height: screenWidth / 3 / 3,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  child: Text('Enter', maxLines: 1),
                                  onPressed: () {
                                    var combinedBuffer = StringBuffer();
                                    typedWordChars.forEach((element) {
                                      if(element != '→')
                                        {
                                          combinedBuffer.write(element);
                                        }
                                    });
                                    String combined = combinedBuffer.toString().toLowerCase();
                                    print("combined word is " + combined);
                                    if(combined.length < 4)
                                      {
                                        for(int i = 1; i < typedWordChars.length; i ++)
                                        {
                                          typedWordChars[i] = '';
                                        }
                                        numTypedLetters = 1;
                                        errorMessage = "Word less than 4 letters!";
                                        errorTriggered = 1;
                                        setState(() {});
                                      }
                                    else
                                      {
                                        var flag = 1;
                                        _questions.forEach((element) {
                                          if(element == combined) //매치 완료
                                          {
                                            int sum = _questions.indexOf(combined);
                                            print(sum);

                                            flag = 0;
                                            for(int i = 1; i < typedWordChars.length; i ++)
                                            {
                                              typedWordChars[i] = '';
                                            }
                                            currentLetter++;
                                            numTypedLetters = 1;
                                            scoreUpdate(( sum%100 * 37) + combined.length * combined.length * 7 + combined.length);
                                            setState(() {});
                                          }
                                        });
                                        if(flag == 1)
                                        {//단어 매치가 안됌.
                                          for(int i = 1; i < typedWordChars.length; i ++)
                                          {
                                            typedWordChars[i] = '';
                                          }
                                          numTypedLetters = 1;
                                          errorMessage = "Word doesn't Exist!";
                                          errorTriggered = 1;
                                          setState(() {});
                                        }
                                      }
                                  },
                                ),
                              ),
                              Expanded(child: Text(''),),
                            ],
                          ),
                          Expanded(child: Text(''),),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }
      ),
      backgroundColor: sequenceAnimation["theColor"].value,
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
