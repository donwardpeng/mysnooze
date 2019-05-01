import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
            Icon(Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}



class AddAlarmDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Add Alarm',
      )),
      body: _buildAddAlarmForm(),
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
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    helperText: 'No more than 20 characters',
                    filled: true,
                    hintText: '',
                    labelText: 'Alarm Name',
                  ))),
          Padding(
              padding: EdgeInsets.all(20),
              child: (
                _InputDropdown(
            labelText: 'Start Date',
            valueText: DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () { _selectDate(context); },
          ),)
            ),
        ],
      ),
    );
  }
}

Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      selectDate(picked);
  }


