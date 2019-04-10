import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import './login_with_email.dart';
import 'main_page.dart';

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
        body: Builder(
            builder: (context) => Container(
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
                        GoogleSignInButton(onPressed: () {
                          _signInWithGoogle(context);
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
                        RaisedButton(
                            child: Text('Sign in with email'),
                            color: Theme.of(context).accentColor,
                            textColor: Colors.white,
                            textTheme: ButtonTextTheme.primary,
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
                        OutlineButton(
                          child: Text('Create an account'),
                          onPressed: () {
                            print('create account pressed');
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        FlatButton(
                          child: Text(
                            'Sign in anonymously',
                          ),
                          onPressed: () {
                            print("sign in anonymously pressed");
                          },
                        ),
                      ]),
                )));
  }

  void _signInWithGoogle(context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        await _auth.signInWithCredential(credential).catchError((onError) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Unsuccesful login - try again.'),
      ));
    });
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    if (user != null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Successful Login as ' + user.email),
      ));
      await new Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacement(
          _context,
          MaterialPageRoute(
              builder: (BuildContext context) => MainPage(
                    analytics: analytics,
                    observer: observer,
                  )));
    }
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
