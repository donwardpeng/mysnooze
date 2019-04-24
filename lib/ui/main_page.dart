import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:async';
import '../helpers/read_alarms.dart';
import '../bloc/bloc_base.dart';
import '../models/state.dart';
import '../state_widget.dart';
import './login.dart';

class MainPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  MainPage({this.analytics, this.observer});

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

//**Main Page State Class */

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  StateModel appState;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String messageFromPush = '';
  IncrementBloc bloc = new IncrementBloc();
  AlarmStore _alarmStore = new AlarmStore();

  @override
  void initState() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) {
      print("### token for phone: ${token}");
    });
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      onPushNotification(message.toString());
    }, onResume: (Map<String, dynamic> message) {
      onPushNotification(message.toString());
    }, onLaunch: (Map<String, dynamic> message) {
      onPushNotification(message.toString());
    });
  }

  void onPushNotification(String message) {
    messageFromPush = message;
  }

  @override
  Widget build(BuildContext context) {
    // Build the content depending on the state:
    appState = StateWidget.of(context).state;
    return _buildContent();
  }

  Widget _buildContent() {
    print("State of Loading = " +
        appState.isLoading.toString() +
        ", User = " +
        appState.user.toString());
    if (appState.isLoading) {
      print("IsLoading");
      return _buildMainScreenContent(
        body: _buildLoadingIndicator(),
      );
    } else if (!appState.isLoading && appState.user == null) {
      print("Not Logged In");
      return new LoginScreen();
    } else {
      print("Already Logged In");
      return _buildMainScreenContent(
        body: _buildMainScreenList(),
      );
    }
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

  Widget _buildMainScreenContent({Widget body}) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
      ),
      body: body,
      drawer: Drawer(
          child: Column(children: <Widget>[
        AppBar(title: Text(messageFromPush)),
        RaisedButton(
          child: Text("Sign Out"),
          onPressed: () {StateWidget.of(context).signOutWithGoogle();},
        )
      ])),
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
              IconButton(
                  icon: Icon(Icons.tune),
                  onPressed: () {
                    _onItemTapped(1);
                  })
            ],
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Add an Alarm',
        onPressed: () {
          bloc.incrementCounter.add(null);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildMainScreenList() {
    return Column(children: <Widget>[
      StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Events').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Center(
                  child: CircularProgressIndicator(
                value: null,
              ));
            default:
              return new ListView(children: createChildren(snapshot));
          }
        },
      )
    ]);
  }

  List<Widget> createChildren(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((document) => (getAlarmRows(document)))
        .toList();
  }

  Widget getAlarmRows(DocumentSnapshot doc) {
    return Row(
      children: <Widget>[
        Text(doc['Date'].toString()),
        Text(doc['Location'].toString())
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('[MAINPAGE] bottomActionBar pressed - index = ' +
          _selectedIndex.toString());
    });
  }
}

class IncrementBloc implements BlocBase {
  int _counter;

  //
  // Stream to handle the counter
  //
  // outCounter is where the counter value is read from -> outCounter is an stream fed
  // by the _inAdd sink which takes in a int, and is fed the value of counter every time
  // the _handleLogic method is called (which is the handler that is called when the
  // _actionController stream has something in it - this is caused by adding something to
  // the incrementCounter stream

  // Overall:
  // Something is added to the incrementCounter sink -> this causes the
  // _actionController to have something fill it's stream which causes the
  // _handleLogic method to be called which adds the updated value to the _inAdd sink
  // which fills the _counterController stream, which allows the outCounter stream to get
  // data
  //
  StreamController<int> _counterController = StreamController<int>();
  StreamSink<int> get _inAdd => _counterController.sink;
  Stream<int> get outCounter => _counterController.stream;

  //
  // Stream to handle the action on the counter
  //
  StreamController _actionController = StreamController();
  StreamSink get incrementCounter => _actionController.sink;
  //
  // Constructor
  //
  IncrementBloc() {
    _counter = 0;
    _actionController.stream.listen(_handleLogic);
  }

  void dispose() {
    _actionController.close();
    _counterController.close();
  }

  void _handleLogic(data) {
    _counter = _counter + 1;
    _inAdd.add(_counter);
  }
}
