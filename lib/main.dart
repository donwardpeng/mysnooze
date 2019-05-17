import 'package:flutter/material.dart';

// import 'package:flutter/rendering.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_analytics/observer.dart';
import './ui/theme.dart';
import './state_widget.dart';
import './ui/main_page.dart';
import './ui/login.dart';
import './ui/login_with_email.dart';
import './ui/add_alarm_dialog.dart';
import 'dart:async';

void main() {
  //  debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(new StateWidget(
      child: FutureBuilder<RemoteConfig>(
    future: setupRemoteConfig(),
    builder: (BuildContext context, AsyncSnapshot<RemoteConfig> snapshot) {
      return snapshot.hasData
          ? MyApp(remoteConfig: snapshot.data)
          : Container();
    },
    //new StateWidget(
    //child: new MyApp(),
    //)
  )));
}

class MyApp extends AnimatedWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  String _themeString;
  ThemeData _theTheme;
  MyApp({this.remoteConfig}) : super(listenable: remoteConfig);
  final RemoteConfig remoteConfig;
  bool calledRemoteConfig = false;

  @override
  Widget build(BuildContext context) {
    if (!calledRemoteConfig) {
      callRemoteConfig(remoteConfig);
      calledRemoteConfig = true;
    }
    print(remoteConfig.getString('theme'));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Snooze Test",
      theme: buildTheme(remoteConfig.getString('theme')),
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

Future<RemoteConfig> setupRemoteConfig() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  // Enable developer mode to relax fetch throttling
  remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
  remoteConfig.setDefaults(<String, dynamic>{
    'theme': 'spring',
  });
  return remoteConfig;
}

callRemoteConfig(RemoteConfig remoteConfig) async {
  try {
    print('calling remote config');
    // Using default duration to force fetching from remote server.
    await remoteConfig.fetch(expiration: const Duration(seconds: 10));
    await remoteConfig.activateFetched();
  } on FetchThrottledException catch (exception) {
    // Fetch throttled.
    print(exception);
  } catch (exception) {
    print('Unable to fetch remote config. Cached or default values will be '
        'used');
  }
}
