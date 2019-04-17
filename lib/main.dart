import 'package:flutter/material.dart';

// import 'package:flutter/rendering.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import './ui/theme.dart';
import './ui/login.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // return MaterialApp(
      // debugShowMaterialGrid: true,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: LoginScreen(analytics: analytics, observer: observer),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}
