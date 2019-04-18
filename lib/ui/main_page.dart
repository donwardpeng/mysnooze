import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:async';
import '../helpers/read_alarms.dart';
import '../helpers/alarm_filter.dart';
import '../bloc/bloc_base.dart';

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
  AlarmStore _alarmStore = new AlarmStore();
  // AlarmFilter _alarmFilter = new AlarmFilter();

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

    // _alarmStore.readAlarms(_alarmFilter);
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
      body: StreamBuilder<QuerySnapshot>(
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
      ),

      // Column(children: <Widget>[
      //   StreamBuilder(
      //       stream: bloc.outCounter,
      //       initialData: 0,
      //       builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
      //         return Text(snapshot.data.toString());
      //       }),
      // ]),
      drawer: Drawer(
        child: AppBar(title: Text(messageFromPush)),
      ),
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

  List<Widget> createChildren(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((document) => (getAlarmRows(document)))
        .toList();
  }

  Widget getAlarmRows(DocumentSnapshot doc){
    return Row(
              children: <Widget>[
                Text(doc['Date'].toString()),
                Text(doc['Location'].toString())
              ],);
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
