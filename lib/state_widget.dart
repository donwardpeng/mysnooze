import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './helpers/auth.dart';
import './models/state.dart';

class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state,
  });

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _StateWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_StateDataWidget)
            as _StateDataWidget)
        .data;
  }

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel state;
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel(isLoading: true);
      initUser();
    }
  }

  Future<Null> initUser() async {
    googleAccount = await getSignedInAccount(googleSignIn);

    if (googleAccount == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      await signInWithGoogle();
    }
  }

  Future<Null> signInWithGoogle({theContext:BuildContext}) async {
    if (googleAccount == null) {
      // Start the sign-in process:
      googleAccount = await googleSignIn.signIn();
    }
    FirebaseUser firebaseUser = await signIntoFirebase(googleAccount).catchError((onError) {
      Scaffold.of(theContext).showSnackBar(SnackBar(
        content: Text('Unsuccesful login - try again.'),
      ));
    });
    if (firebaseUser != null) {
      Scaffold.of(theContext).showSnackBar(SnackBar(
        content: Text('Successful Login as ' + firebaseUser.email),
      ));
    };
    setState(() {
      state.isLoading = false;
      state.user = firebaseUser;
    });
  }

  Future<Null> signOutWithGoogle() async {
    if (googleAccount == null) {
      // Start the sign-in process:
      return;
    }
    await FirebaseAuth.instance.signOut();
    setState(() {
      googleAccount = null;
      state.isLoading = false;
      state.user = null;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget: 
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}