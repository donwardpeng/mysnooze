import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:async';

import '../bloc/blocbase.dart';

class MainPage extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  MainPage({this.analytics, this.observer});

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String messageFromPush = '';
  // ValueHandler _valueHandler =ValueHandler();
  IncrementBloc bloc = new IncrementBloc();

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
      ),
      body: Column(children: <Widget>[
        StreamBuilder(
            stream: bloc.outCounter,
            initialData: 0,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Text(snapshot.data.toString());
            }),
      ]),
      drawer: Drawer(
        child: AppBar(title: Text(messageFromPush)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.alarm), title: Text('Alarms')),
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('List')),
          BottomNavigationBarItem(
              icon: Icon(Icons.tune), title: Text('Filter')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Add an Alarm',
        onPressed: () {
          bloc.incrementCounter.add(null);
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2) {
        // _scaffoldKey.currentState.showBottomSheet<Null>((BuildContext context) {
        //   return BottomSheetFilter(_mapWithIncidents,
        //       _mapWithIncidents.mapWithIncidentsState.addMarkersToMap);
        // });
      }
    });
  }
}

class IncrementBloc implements BlocBase {
  int _counter;

  //
  // Stream to handle the counter
  //
  // outCounter is where the counter value is read from -> outCounter is an stream fed
  // by the _inAdd sink which takes in a int, and is fed the value of counter everytime
  // the _handleLogic method is called (which is the handler that is called when the
  // _actionController stream has something in it - this is caused by adding somehing to
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
