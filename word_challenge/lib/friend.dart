import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

class FriendPage extends StatefulWidget {
  final String title = 'Friend';
  @override
  FriendPageState createState() => FriendPageState();
}

class FriendPageState extends State<FriendPage> {
  var totalEmails;
  List<dynamic> friendEmail;
  int i = 0;

  @override
  Widget build(BuildContext context) {

    List<String> friendNick = new List<String>();
    List<int> friendScore = new List<int>();
    List<String> friendEmailz = new List<String>();

    Future<String> getNickname(String temp, int num) async {
      var result = await Firestore.instance.collection('account').document(temp).get();
      friendNick[num] = result.data['nickname'];
      friendScore[num] = result.data['score'];
      friendEmailz[num] = result.data['theEmail'];
      return result.data['nickname'];
    }

    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance.collection('account').document(theEmail).snapshots(),
          builder: (context, snapshot) {
            friendEmail = snapshot.data['friends'];
            totalEmails = Firestore.instance.collection('account');
            return Column(
              children: <Widget>[
                SizedBox(height: 100,),
                Text("Friend List", style: TextStyle(fontSize: 50),),
                Expanded(
                  child: ListView.builder(
                    itemCount: friendEmail.length,
                      itemBuilder: (BuildContext context, int index) {
                      for(int i = 0; i < friendEmail.length; i++)
                        {
                          friendNick.add("");
                          friendScore.add(0);
                          friendEmailz.add("");
                        }
                      return Container(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            FutureBuilder(
                              future: getNickname(friendEmail[index], index),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData)
                                {
                                  return CircularProgressIndicator();
                                }
                                else
                                  {
                                    return RichText(
                                      text: TextSpan(
                                        style: TextStyle(fontSize: 20, color: Colors.blue),
                                        children: <TextSpan>[
                                          TextSpan(text: "${index+1}. Email: ", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                                          TextSpan(text: "${friendEmailz[index]}"),
                                          TextSpan(text: "\n     Nickname: ", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                                          TextSpan(text: "${friendNick[index]}"),
                                          TextSpan(text: "\n     Score: ", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                                          TextSpan(text: "${friendScore[index]}"),
                                        ]
                                      ),
                                    );
                                  }
                              },
                            ),
                          ],
                        ),
                      );
                      })
                ),
                RaisedButton(
                  child: Text('Add Friends', style: TextStyle(fontSize: 25),),
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  shape: StadiumBorder(),
                ),
              ],
            );
          }
      ),
      backgroundColor: Colors.amber,
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          width: 100,
          height: 50,
          child: RaisedButton(
            child: Text('Back to Profile'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        )
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  void showAlertDialog(BuildContext context) async {
    final databaseReference = Firestore.instance;
    final TextEditingController _textController = new TextEditingController();
    final _formKey = GlobalKey<FormState>();

    var alreadyExists = false;
    var doesntExist = false;

    void addEmail(String temp) async {
      await databaseReference.collection("account")
          .document(theEmail)
          .updateData({
        'friends' : FieldValue.arrayUnion([temp]),
      });
      print("actually added");
      setState(() {

      });
    }

    void searchEmail(String tempEmail) async {
      if(friendEmail.contains(tempEmail))
        {
          alreadyExists = true;
          doesntExist = false;
          print("friend already exists");
          _formKey.currentState.validate();
        }
      else
        {
          var result = await Firestore.instance.collection('account').document(tempEmail).get();
          if(result.exists)
          {
            print("add the friend");
            addEmail(tempEmail);
            Navigator.pop(context);
          }
          else
          {
            doesntExist = true;
            alreadyExists = false;
            print("friend doesn't exist");
            _formKey.currentState.validate();
          }
        }
    }

    void _handleSubmitted(String text) {
      _textController.clear();
    }

    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Type Friend\'s Email!'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                if(doesntExist && !alreadyExists)
                {
                  return 'The Email does not Exist.';
                }
                else if(alreadyExists && !doesntExist)
                {
                  return 'He is already your friend.';
                }
                else
                  return null;
              },
              controller: _textController,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Search!'),
              onPressed: () {
                doesntExist = false;
                alreadyExists = false;
                searchEmail(_textController.text);
              },
            )
          ],
        );
      },
    );
  }
}