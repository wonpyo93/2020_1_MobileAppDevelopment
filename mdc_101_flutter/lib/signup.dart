import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  SignupPageState createState() {
    return SignupPageState();
  }
}

class SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        body: SafeArea(
      child: Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        children: <Widget>[
          SizedBox(height: 80.0),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter Username';
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              labelText: 'Username',
            ),
          ),
          SizedBox(height: 12.0),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter Password';
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              labelText: 'Password',
            ),
          ),
          SizedBox(height: 12.0),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter Confirm Password';
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              labelText: 'Confirm Password',
            ),
          ),
          SizedBox(height: 12.0),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter Address';
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              labelText: 'Email Address',
            ),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('Sign Up'),
                onPressed: () {
                  if(_formKey.currentState.validate())
                    {
                      Navigator.pop(context);
                    }
                },
              ),
            ],
          ),
        ],
      ),
    ),
        ),
    );
  }
}