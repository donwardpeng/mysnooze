import 'package:latlong/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Alarm {
int _id;
String _name;
DateTime _dateTime;
Duration _duration;
GeoPoint _location;


Alarm({id: int, name: String, date: DateTime, location: GeoPoint }) {
_dateTime = date;
_location = location;
}

//Getters and Setters
String get name => _name;
set name(String name) => _name = name;
int get id => _id;
set id(int id) => _id = id;
DateTime get dateTime => _dateTime;
set dateTime(DateTime dateTime) => _dateTime = dateTime;
Duration get duration => _duration;
set duration(Duration duration) => _duration = duration;
GeoPoint get location => _location;
set location(GeoPoint location) => _location = location;
}