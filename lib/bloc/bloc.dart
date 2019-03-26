import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class Bloc {

  final _counter$ = BehaviorSubject<String>();
  final eventController = StreamController<void>();

  Bloc() {
    eventController.stream.listen((void _) => _counter$.add("event"));
  }

  Sink<void> get sendEvent => eventController.sink;

  Stream<String> get readEvent$ => _counter$.stream;

  void dispose() {
    eventController.close();
    _counter$.close();
  }
}

