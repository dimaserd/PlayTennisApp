import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerInput extends StatefulWidget {
  final String label;
  late DateTime value = DateTime.now();
  late DateTime startDateValue = DateTime(1950);
  late DateTime lastDateValue = DateTime.now();

  final Function(DateTime?)? dateChanged;

  DatePickerInput({
    super.key,
    required this.label,
    required this.dateChanged,
    DateTime? defaultValue,
    DateTime? startDate,
    DateTime? lastDate,
  }) {
    if (startDate != null) {
      startDateValue = startDate;
    }
    if (lastDate != null) {
      lastDateValue = lastDate;
    }
    if (defaultValue != null) {
      value = defaultValue;
    }
  }

  @override
  State<DatePickerInput> createState() => _DatePickerInputState();
}

class _DatePickerInputState extends State<DatePickerInput> {
  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {
    setFormattedDate();
    super.initState();
  }

  setFormattedDate() {
    if (widget.value == null) {
      dateInput.text = "";
      return;
    }
    var formattedDate = DateFormat('dd.MM.yyyy').format(widget.value);
    dateInput.text = formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
      child: TextField(
        maxLength: 10,
        controller: dateInput,
        //editing controller of this TextField
        decoration: InputDecoration(
          labelText: widget.label, //label text of field
        ),
        readOnly: true,
        //set it true, so that user will not able to edit text
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            locale: const Locale('ru'),
            initialDate: widget.value,
            firstDate: DateTime.utc(0),
            //DateTime.now() - not to allow to choose before today.
            lastDate: widget.lastDateValue,
          );

          if (widget.dateChanged != null) {
            widget.dateChanged!(pickedDate);
          }
          if (pickedDate != null) {
            widget.value = pickedDate;
            setState(() {
              setFormattedDate();
            });
          }
        },
      ),
    );
  }
}
