import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'login.dart';

class LogOutPage extends StatefulWidget {
  final String title = 'Registration';
  @override
  LogOutPageState createState() => LogOutPageState();
}

class LogOutPageState extends State<LogOutPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logOut();
  }

  void logOut() async
  {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    if (user == null) {
      return;
    }
    await _auth.signOut();
    final String uid = user.uid;
    theUid = "null";
    theEmail = "null";
    theNickname = "null";
    thePhoto = "null";
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance.collection('account').document(theEmail).snapshots(),
          builder: (context, snapshot) {
            return Center(
              child: Text("Logging Out..."),
            );
          }
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}