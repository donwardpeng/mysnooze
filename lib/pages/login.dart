import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import './loginwithemail.dart';
import 'mainpage.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  BuildContext _context;

  LoginScreen({this.analytics, this.observer});

  Future<void> _setAnalyticsCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'Login Screen',
      screenClassOverride: 'Login',
    );
    print('Analytics: setCurrentScreen done');
  }

  @override
  Widget build(BuildContext context) {
    _setAnalyticsCurrentScreen();
    _context = context;
    return Scaffold(
        appBar: AppBar(title: Text('Login Screen')),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'SnoozeImage',
                  child: Image.asset('assets/snooze.png'),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 32.0),
                ),
                RaisedButton(
                    child: Text('I already have an email account'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LoginWithEmailPage(
                                    analytics: analytics,
                                    observer: observer,
                                  )));
                    }),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GoogleSignInButton(onPressed: () {
                  _signInWithGoogle();
                }),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                FacebookSignInButton(onPressed: () {
                  _signInWithFacebook();
                }),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                Text(
                  'Sign in anonomously',
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                Text('Create an account'),
              ]),
        ));
  }

  void _signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    if(user != null){
      Navigator.pushReplacement(
          _context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  MainPage(
                    analytics: analytics,
                    observer: observer,
                  )));
    }
//    setState(() {
//      if (user != null) {
//        _success = true;
//        _userID = user.uid;
//      } else {
//        _success = false;
//      }
//    });
  }

  // Example code of how to sign in with Facebook.
  void _signInWithFacebook() async {
    final AuthCredential credential = FacebookAuthProvider.getCredential(
//      accessToken: _tokenController.text,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
//    setState(() {
//      if (user != null) {
//        _message = 'Successfully signed in with Facebook. ' + user.uid;
//      } else {
//        _message = 'Failed to sign in with Facebook. ';
//      }
//    });
  }


}
