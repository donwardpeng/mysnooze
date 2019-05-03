import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/alarm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.subtitle;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: labelText,
            valueText: DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class AddAlarmDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddAlarmDialogState();
  }
}

class AddAlarmDialogState extends State<AddAlarmDialog> {
  DateTime _fromDate = DateTime.now();
  TimeOfDay _fromTime = const TimeOfDay(hour: 7, minute: 28);
  DateTime _toDate = DateTime.now();
  TimeOfDay _toTime = const TimeOfDay(hour: 7, minute: 28);
  TextEditingController _alarmController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Add Alarm',
      )),
      body: _buildAddAlarmForm(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.save,
        ),
        onPressed: () {
          DateTime fromDateTime = new DateTime(_fromDate.year, _fromDate.month,
              _fromDate.day, _fromTime.hour, _fromTime.minute);
          // Timestamp alarmDate = Timestamp.fromDate(fromDateTime);
          addAlarmToFirestore(new Alarm(
              name: _alarmController.text,
              date: fromDateTime,
              duration: new Duration(hours: 2)));
        },
      ),
    );
  }

  Widget _buildAddAlarmForm() {
    return Container(
      alignment: FractionalOffset.topLeft,
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(20),
              child: TextFormField(
                  maxLength: 25,
                  controller: _alarmController,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    helperText: 'No more than 20 characters',
                    filled: true,
                    hintText: '',
                    labelText: 'Alarm Name',
                  ),
                  style: Theme.of(context).textTheme.subtitle)),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: (_DateTimePicker(
                labelText: 'From',
                selectedDate: _fromDate,
                selectedTime: _fromTime,
                selectDate: (DateTime date) {
                  setState(() {
                    _fromDate = date;
                  });
                },
                selectTime: (TimeOfDay time) {
                  setState(() {
                    _fromTime = time;
                  });
                },
              ))),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: (_DateTimePicker(
                labelText: 'To',
                selectedDate: _toDate,
                selectedTime: _toTime,
                selectDate: (DateTime date) {
                  setState(() {
                    _toDate = date;
                  });
                },
                selectTime: (TimeOfDay time) {
                  setState(() {
                    _toTime = time;
                  });
                },
              ))),
        ],
      ),
    );
  }

  addAlarmToFirestore(Alarm newAlarm) {
    CollectionReference events = Firestore.instance.collection('Events');
    Firestore.instance.runTransaction((Transaction tx) async {
      var _result = await events.add(newAlarm.toJson());
    });
  }
}
