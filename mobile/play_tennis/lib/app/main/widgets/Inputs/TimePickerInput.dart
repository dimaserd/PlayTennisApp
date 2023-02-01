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
    widget.pickedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );

    if (widget.timeChanged != null) {
      widget.timeChanged!(widget.pickedTime);
    }

    if (widget.pickedTime != null) {
      dateInput.text = TimePickerUtils.formatTime(widget.pickedTime!);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
      child: TextField(
        controller: dateInput,
        //editing controller of this TextField
        decoration: InputDecoration(
          labelText: widget.label, //label text of field
        ),
        readOnly: true,
        //set it true, so that user will not able to edit text
        onTap: () async {
          await showPicker(context);
        },
      ),
    );
  }
}
