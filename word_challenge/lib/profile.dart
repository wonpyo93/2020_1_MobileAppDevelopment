import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wordchallenge/logout.dart';
import 'friend.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  final String title = 'Registration';
  @override
  ProfilePageState createState() => ProfilePageState();
}


class ProfilePageState extends State<ProfilePage> {

  void showAlertDialog(BuildContext context) async {
    final databaseReference = Firestore.instance;
    final TextEditingController _textController = new TextEditingController();

    void changeNickname(String tempName) async {
      await databaseReference.collection('account')
          .document(theEmail)
          .updateData({
        'nickname' : tempName,
      });
    }

    void _handleSubmitted(String text) {
      _textController.clear();
    }

    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Type New Nickname!'),
          content: TextField(
            controller: _textController,
            onSubmitted: _handleSubmitted,
            decoration: InputDecoration(
              labelText: 'New Nickname',
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
              child: Text('Change!'),
              onPressed: () {
                changeNickname(_textController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('account').document(theEmail).snapshots(),
        builder: (context, snapshot) {
          return ListView(
            children: <Widget>[
              Container(
                height: 200,
                child: Image.network(thePhoto),
              ),
              SizedBox(height: 20,),
              Container(
                height: 300,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(child: Text('     Email:', style: TextStyle(fontSize: 20),),),
                          Expanded(child: Text('     UID:', style: TextStyle(fontSize: 20),)),
                          Expanded(child: Text('     Nickname:', style: TextStyle(fontSize: 20),)),
                          Expanded(child: Text('     # of Games Played:', style: TextStyle(fontSize: 20),),),
                          Expanded(child: Text('     Best Score:', style: TextStyle(fontSize: 20),),),
                          //Expanded(child: Text('     Among my Friends:', style: TextStyle(fontSize: 20),),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(child: Text(theEmail, style: TextStyle(fontSize: 15),)),
                          Expanded(child: Text(theUid,maxLines: 1, style: TextStyle(fontSize: 15),)),
                          Expanded(child: Text(snapshot.data['nickname'],maxLines: 1, style: TextStyle(fontSize: 20),)),
                          Expanded(child: Text(snapshot.data['numGamePlayed'].toString(), style: TextStyle(fontSize: 20),),),
                          Expanded(child: Text(snapshot.data['score'].toString(), style: TextStyle(fontSize: 20),),),
                          //Expanded(child: Text(theEmail, style: TextStyle(fontSize: 20),),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              //leading: Icon(),
              title: Text('Change Nickname!'),
              onTap: () {
                Navigator.pop(context);
                showAlertDialog(context);
              },
            ),
            ListTile(
              //leading: Icon(),
              title: Text('Add Friends'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FriendPage()));
              },
            ),
            ListTile(
              //leading: Icon(),
              title: Text('Terms & Conditions'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              //leading: Icon(),
              title: Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => LogOutPage()));
              },
            ),
          ],
        ),
      ),
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
/*
      class Record {
        final List<String> friends;
        final String nickname;
        final int score;
        final String theUID;
        final int numGamePlayed;

        Record.fromMap(Map<String, dynamic> map, {this.reference})
            : assert(map['friends'] != null),
              assert(map['nickname'] != null),
              assert(map['score'] != null),
              assert(map['numGamePlayed'] != null),
              friends = map['friends'],
              nickname = map['nickname'],
              score = map['score'],
              theUID = map['theUID'],
              numGamePlayed = map['numGamePlayed'];

        Record.fromSnapshot(DocumentSnapshot snapshot)
            : this.fromMap(snapshot.data, reference: snapshot.reference);
      }
 */