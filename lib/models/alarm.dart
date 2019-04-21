import 'package:latlong/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Alarm {
DateTime _dateTime;
// LatLng _location;

GeoPoint _location;

Alarm({date: DateTime, location: GeoPoint }) {
_dateTime = date;
_location = location;
}

DateTime get dateTime => _dateTime;
set dateTime(DateTime dateTime) => _dateTime = dateTime;
GeoPoint get location => _location;
set location(GeoPoint location) => _location = location;
}