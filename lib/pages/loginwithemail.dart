import 'package:flutter/material.dart';

import '../widgets/password_input.dart';
import './mainpage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class LoginWithEmailPage extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  LoginWithEmailPage({this.analytics, this.observer});

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
    return Scaffold(
        appBar: AppBar(title: Text('Login with Email')),
        body: Container(
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
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  ),
                  TextFormField(
                    maxLength: 20,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      helperText: 'No more than 20 characters',
                      filled: true,
                      hintText: '',
                      labelText: 'Username',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 36.0),
                  ),
                  PasswordInput(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 48.0),
                  ),
                  RaisedButton(
                      child: Text('LOGIN'),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => MainPage(
                                      analytics: analytics,
                                      observer: observer,
                                    )));
                      })
                ])));
  }
}
