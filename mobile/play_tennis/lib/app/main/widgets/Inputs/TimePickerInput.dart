import 'package:flutter/material.dart';

import '../../extensions/TimePickerUtils.dart';

class TimePickerInput extends StatefulWidget {
  final String label;
  final Function(TimeOfDay?)? timeChanged;
  TimeOfDay? pickedTime;

  TimePickerInput({
    super.key,
    required this.label,
    required this.pickedTime,
    required this.timeChanged,
  });

  @override
  State<TimePickerInput> createState() => _TimePickerInputState();
}

class _TimePickerInputState extends State<TimePickerInput> {
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    if (widget.pickedTime != null) {
      dateInput.text = TimePickerUtils.formatTime(widget.pickedTime!);
    }
    super.initState();
  }

  Future<bool> showPicker(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: widget.pickedTime ?? TimeOfDay(hour: 10, minute: 0),
    );

    if (pickedTime != null) {
      setState(() {
        widget.pickedTime = pickedTime;
        dateInput.text = TimePickerUtils.formatTime(pickedTime);
        if (widget.timeChanged != null) {
          widget.timeChanged!(pickedTime);
        }
      });
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
      child: GestureDetector(
        onTap: () async {
          await showPicker(context);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: widget.label,
          ),
          child: Text(
            widget.pickedTime != null
                ? TimePickerUtils.formatTime(widget.pickedTime!)
                : '',
          ),
        ),
      ),
    );
  }
}
