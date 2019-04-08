import 'package:latlong/latlong.dart';

class Alarm {
DateTime _dateTime;
LatLng _location;

Alarm({date: DateTime, location: LatLng }) {
_dateTime = date;
_location = location;
}

DateTime get dateTime => _dateTime;
set dateTime(DateTime dateTime) => _dateTime = dateTime;
LatLng get location => _location;
set location(LatLng location) => _location = location;
}