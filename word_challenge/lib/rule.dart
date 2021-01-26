import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

class RulePage extends StatefulWidget {
  final String title = 'Registration';
  @override
  RulePageState createState() => RulePageState();
}


class RulePageState extends State<RulePage> {
  @override
  Widget build(BuildContext context) {

    double c_width = MediaQuery.of(context).size.width*0.8;

    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance.collection('account').document(theEmail).snapshots(),
          builder: (context, snapshot) {
            return Center(
              child: Column(
                children: <Widget>[
                  Expanded(child:Text('')),
                  Container (
                    padding: const EdgeInsets.all(16.0),
                    width: c_width,
                    child: new Column (
                      children: <Widget>[
                        Text("RULES", style: TextStyle(color: Colors.blue,fontSize: 50),),
                        SizedBox(height: 50,),
                        Text ("    1. No Backspace"
                            "\nIf you type something wrong, retype by clicking Enter"
                            "\n\n    2. Start with UNDERLINED Alphabet"
                            "\nThe first alphabet must match."
                            "\n\n    3. Write as many as possible"
                            "\nLonger word = higher score!"
                            "\n\n    4. Word must be > 4 alphabets"
                            "\nMake sure you write a word that is longer than 4 alphabets. \nFor example, \'CAN\' will not work!",
                            textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white, fontSize: 17),),
                      ],
                    ),
                  ),
                  Expanded(child:Text('')),
                ],
              ),
            );
          }
      ),
      backgroundColor: Colors.black,
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          width: 100,
          height: 50,
          child: RaisedButton(
            child: Text('Back to Home'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        )
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}