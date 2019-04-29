import '../models/alarm.dart';

class AlarmMocks{
List<Alarm> _mockAlarms = new List<Alarm>();
AlarmMocks(){
  _mockAlarms.add(new Alarm(id: 1, 
                  name: 'First Alarm',
                  date: new DateTime.now(),
                  duration: new Duration(hours: 4)));

  _mockAlarms.add(new Alarm(id: 2,
                  name: 'Second Alarm',
                  date: new DateTime(2019,4,28,10,30),
                  duration: new Duration(hours: 7)));

  _mockAlarms.add(new Alarm(id: 3,
                  name: 'Third Alarm',
                  date: new DateTime(2018, 10, 10, 2, 25),
                  duration: new Duration(hours: 15)));

  _mockAlarms.add(new Alarm(id: 4,
                  name: 'Fourth Alarm',
                  date: new DateTime(2017, 11, 12, 2, 25),
                  duration: new Duration(hours: 3)));
}

List<Alarm> getMockAlarms(){return _mockAlarms;}

}

