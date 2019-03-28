import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:async';

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
  int _counter = 0;
  final StreamController<int> _streamController = StreamController<int>();

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
            stream: _streamController.stream,
            initialData: _counter,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return Text(snapshot.data.toString());
            }),
        RaisedButton.icon(
          label: Text('Add'),
          icon: Icon(Icons.add),
          onPressed: () {
            _streamController.sink.add(++_counter);
          },
        )
      ]),
      drawer: Drawer(
        child: AppBar(title: Text(messageFromPush)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Alarms')),
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text('List')),
          BottomNavigationBarItem(
              icon: Icon(Icons.tune), title: Text('Filter')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blueAccent,
        onTap: _onItemTapped,
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


