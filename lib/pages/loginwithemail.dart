import 'package:flutter/material.dart';

import '../widgets/password_input.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'mainpage.dart';

class LoginWithEmailPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  LoginWithEmailPage({this.analytics, this.observer});

  @override
  State<StatefulWidget> createState() {
    return LoginWithEmailPageState();
  }
}

class LoginWithEmailPageState extends State<LoginWithEmailPage> {
  String _password;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _setAnalyticsCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Login Screen',
      screenClassOverride: 'Login',
    );
    print('Analytics: setCurrentScreen done');
  }

  void _setPassword(String password) {
    _password = password;
  }

  @override
  Widget build(BuildContext context) {
    _setAnalyticsCurrentScreen();
    return Scaffold(
        appBar: AppBar(title: Text('Login with Email')),
        body: Builder(
            builder: (context) => Form(
                key: _formKey,
                child: Container(
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
                            maxLength: 25,
                            decoration: InputDecoration(
                              border: const UnderlineInputBorder(),
                              helperText: 'No more than 20 characters',
                              filled: true,
                              hintText: '',
                              labelText: 'Username',
                            ),
                            controller: _emailController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 36.0),
                          ),
                          PasswordInput(_setPassword),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 48.0),
                          ),
                          RaisedButton(
                              child: Text('LOGIN'),
                              color: Theme.of(context).primaryColor,
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _signInWithEmailAndPassword(context);
                                }
                              }),
                        ])))));
  }

// Example code of how to sign in with email and password.
  void _signInWithEmailAndPassword(context) async {
    final FirebaseUser user = await _auth
        .signInWithEmailAndPassword(
      email: _emailController.text,
      password: _password,
    )
        .catchError((onError) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Unsuccesful login - try again.'),
      ));
    });
    print('[LOGINWITHEMAILPAGE]_signInWithEmailAndPassword - Username = ' +
        _emailController.text +
        ', Password = ' +
        _password);
    if (user != null) {
      print(
          '[LOGINWITHEMAILPAGE]_signInWithEmailAndPassword - successful login');
      // Find the Scaffold in the Widget tree and use it to show a SnackBar!
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Successful Login as ' + user.email),
      ));
      await new Future.delayed(const Duration(seconds: 2));
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MainPage(
                    analytics: widget.analytics,
                    observer: widget.observer,
                  )));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Unsuccesful login - try again.'),
      ));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
