import 'alarm_filter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/alarm.dart';

class AlarmStore {
  List<Alarm> _alarms = new List<Alarm>();

  void readAlarms(AlarmFilter alarmFilter) {
    Query query = Firestore.instance.collection('Events').limit(999);
    // alarmFilter.filters.forEach((FilterCondition condition) {
    //   query = this._setWhere(query, condition);
    // });

    query.snapshots().listen((data) {
      data.documents.forEach((doc) {
        _alarms.add(new Alarm(date: doc['Date'], location: doc['Location']));
      });
    });
  }

  List<Alarm> getAlarmList(){
    return _alarms;
  }

  bool hasResults() {
    return _alarms.length > 0;
  }

  Query _setWhere(Query query, FilterCondition condition) {
    // TODO is there a language appropriate way to pass these named parameters by a variable?
    switch (condition.key) {
      case 'isEqualTo':
        return query.where(condition.field, isEqualTo: condition.value);
      case 'isGreaterThan':
        return query.where(condition.field, isGreaterThan: condition.value);
      case 'isGreaterThanOrEqualTo':
        return query.where(condition.field,
            isGreaterThanOrEqualTo: condition.value);
      case 'isLessThan':
        return query.where(condition.field, isLessThan: condition.value);
      case 'isLessThanOrEqualTo':
        return query.where(condition.field,
            isLessThanOrEqualTo: condition.value);
      case 'isNull':
        return query.where(condition.field,
            isNull: condition.value.isNotEmpty ||
                condition.value.startsWith('true'));
    }
  }
}
