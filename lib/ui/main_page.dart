import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/state.dart';
import '../state_widget.dart';
import '../widgets/alarm_card.dart';
import './login.dart';
import '../ui/add_alarm_dialog.dart';
import '../models/alarm.dart';

const List<String> emptyQuotes = [
  "I have a simple philosophy: Fill what's empty. Empty what's full. Scratch where it itches. - Alice Roosevelt Longworth"
];

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
  
  String messageFromPush = '';
  // AlarmStore _alarmStore = new AlarmStore();
  List<Alarm> _alarms = new List<Alarm>();

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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
          onPressed: () {
            StateWidget.of(context).signOutWithGoogle();
          },
        )
      ])),
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              
              IconButton(
                icon: Icon(Icons.dashboard),
                tooltip: 'Everything',
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
 
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
        tooltip: 'Add an Item',
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return new AddAlarmDialog();
              },
              fullscreenDialog: true));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('[MAINPAGE] bottomActionBar pressed - index = ' +
          _selectedIndex.toString());
    });
  }
  Widget _buildMainScreenList() {
    return StreamBuilder<QuerySnapshot>(
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
              {
                if (!snapshot.hasData) {
                  return Container(
                      alignment: FractionalOffset.center,
                      color: Colors.amberAccent,
                      child: Text(
                        "The List is Empty!\n\nHurry fill it quick! \n\n Here's a quote for motivation\n" +
                            emptyQuotes[0],
                        style: Theme.of(context).textTheme.subtitle,
                        textAlign: TextAlign.center,
                      ));
                } else
                  return new ListView(children: createChildren(snapshot));
              }
          }
        });
  }

  List<Widget> createChildren(AsyncSnapshot<QuerySnapshot> snapshot) {
    _alarms.clear();
    snapshot.data.documents.forEach((doc) => _alarms.add(new Alarm(
        id: doc['Id'],
        name: doc['Name'],
        date: doc['Date'].toDate(),
        duration: new Duration(minutes: doc['Duration']))));
    List<AlarmCard> alarmCards = new List<AlarmCard>();
    _alarms.forEach((alarm) => (alarmCards.add(new AlarmCard(alarm))));
    return alarmCards;
  }


}
