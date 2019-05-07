import 'package:flutter/material.dart';

// import 'package:flutter/rendering.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import './ui/theme.dart';
import './state_widget.dart';
import './ui/main_page.dart';
import './ui/login.dart';
import './ui/login_with_email.dart';
import './ui/add_alarm_dialog.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(new StateWidget(
      child: new MyApp(),));
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Snooze",
      theme: buildTheme(),
      // home: LoginScreen(analytics: analytics, observer: observer),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/login': (context) => LoginScreen(),
        '/loginWithEmail': (context) => LoginWithEmailPage(),
        '/addAlarm': (context) => AddAlarmDialog(),
      },
    );
  }
}

