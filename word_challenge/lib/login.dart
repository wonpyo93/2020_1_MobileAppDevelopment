import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'home.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

String theUid = "null";
String thePhoto = "null";
String theEmail = "null";
String theNickname = "null";

class LoginPage extends StatefulWidget {
  final String title = 'Registration';
  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Center(
          child: Column(
            children: <Widget>[
              //_AnonymouslySignInSection(),
              Expanded(child:Text('')),
              _GoogleSignInSection(),
              Expanded(child:Text('')),
            ],
          ),
        );
      }),
    );
  }
  void _signOut() async {
    await _auth.signOut();
  }
}

class _GoogleSignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GoogleSignInSectionState();
}

class _GoogleSignInSectionState extends State<_GoogleSignInSection> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _signInWithGoogle();
  }

  bool _success;
  String _userID;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          child:
          Expanded(child:Text('Logging you in...',style: TextStyle(fontSize: 50,color: Colors.black),)),
        ),
      ],
    );
  }

  // Example code of how to sign in with google.
  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    theUid = _userID = user.uid;
    theEmail = user.email;
    thePhoto = user.photoUrl;
    assert(user.uid == currentUser.uid);
    setState(() async {
      if (user != null) {
        _success = true;
        theUid = _userID = user.uid;
        theEmail = user.email;
        thePhoto = user.photoUrl;
        theNickname = user.email;
        debugPrint("theUID from login.dart is " + theUid);

        final tempshot = await Firestore.instance.collection('account').document(theEmail).get();

      if(tempshot  == null || !tempshot.exists)
        {
          debugPrint("it doesn't exist!!!!!!!");
          createRecord();
        }


        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        _success = false;
      }
    });
  }

  void createRecord() async {
    await Firestore.instance.collection("account")
        .document(theEmail)
        .setData({
      'theUID' : theUid,
      'theEmail' : theEmail,
      'score' : 0,
      'nickname' : theEmail,
      'numGamePlayed' : 0,
      'friends' : [],
    });
  }
}


/*
class _AnonymouslySignInSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnonymouslySignInSectionState();
}
class _AnonymouslySignInSectionState extends State<_AnonymouslySignInSection> {
  bool _success;
  String _userID;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          child: RaisedButton(
            onPressed: () async {
              debugPrint('sign in anonymously CLICKED');
              _signInAnonymously();
              Navigator.pop(context);
            },
            child: const Text('Guest'),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            _success == null
                ? ''
                : (_success
                ? 'Successfully signed in, uid: ' + _userID
                : 'Sign in failed'),
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }

  // Example code of how to sign in anonymously.
  void _signInAnonymously() async {
    debugPrint('_signinAnonymously starting!');
    final FirebaseUser user = (await _auth.signInAnonymously()).user;
    assert(user != null);
    assert(user.isAnonymous);
    assert(!user.isEmailVerified);
    assert(await user.getIdToken() != null);
    if (Platform.isIOS) {
      // Anonymous auth doesn't show up as a provider on iOS
      assert(user.providerData.isEmpty);
    } else if (Platform.isAndroid) {

      debugPrint('is android');
      // Anonymous auth does show up as a provider on Android
      assert(user.providerData.length == 1);
      assert(user.providerData[0].providerId == 'firebase');
      assert(user.providerData[0].uid != null);
      assert(user.providerData[0].displayName == null);
      assert(user.providerData[0].photoUrl == null);
      assert(user.providerData[0].email == null);
    }

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    theUid = user.uid;
    debugPrint("fjewoifjiowefjoieajf " + user.uid);
    theEmail = 'Anonymous';
    thePhoto = 'http://handong.edu/site/handong/res/img/logo.png';
    debugPrint('up to this point' + thePhoto);
    setState(() {
      if (user != null) {
        _success = true;
        _userID = user.uid;
        theUid = user.uid;
        debugPrint("fjewoifjiowefjoieajf " + user.uid);
        theEmail = 'Anonymous';
        thePhoto = 'http://handong.edu/site/handong/res/img/logo.png';
      } else {
        _success = false;
        debugPrint('it failed!');
      }
    });
  }
}
*/
