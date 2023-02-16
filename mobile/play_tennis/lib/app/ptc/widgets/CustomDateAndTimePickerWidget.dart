import 'package:flutter/material.dart';
import '../../main/widgets/Inputs/DatePickerInput.dart';
import '../../main/widgets/Inputs/DropdownWidget.dart';
import '../../main/widgets/Inputs/TimePickerInput.dart';

class CustomDateAndTimePickerDateTypes {
  static String toDay = "today";
  static String tommorow = "tommorow";
  static String custom = "custom-date";
}

class CustomDateAndTimePickerWidgetConsts {
  static DropdownWidgetItem todayDateItem = DropdownWidgetItem(
    label: "Сегодня",
    value: CustomDateAndTimePickerDateTypes.toDay,
  );

  static DropdownWidgetItem tommorowDateItem = DropdownWidgetItem(
    label: "Завтра",
    value: CustomDateAndTimePickerDateTypes.tommorow,
  );

  static DropdownWidgetItem customDateItem = DropdownWidgetItem(
    label: "Укажу дату",
    value: CustomDateAndTimePickerDateTypes.custom,
  );

  static List<DropdownWidgetItem> defaultDateItems = [
    todayDateItem,
    tommorowDateItem,
    customDateItem,
  ];

  static List<DropdownWidgetItem> dateItemsNoTommorow = [
    todayDateItem,
    customDateItem,
  ];
}

class CustomDateAndTimePickerWidgetData {
  final DateTime dateTime;
  final TimeOfDay? selectedTime;
  final String dateType;

  CustomDateAndTimePickerWidgetData({
    required this.dateTime,
    required this.selectedTime,
    required this.dateType,
  });

  static CustomDateAndTimePickerWidgetData now() {
    return CustomDateAndTimePickerWidgetData(
      dateTime: DateUtils.dateOnly(DateTime.now()),
      selectedTime: null,
      dateType: CustomDateAndTimePickerDateTypes.toDay,
    );
  }
}

class CustomDateAndTimePickerWidgetController {
  CustomDateAndTimePickerWidgetData value;

  CustomDateAndTimePickerWidgetController({required this.value});
}

class CustomDateAndTimePickerWidget extends StatefulWidget {
  DateTime selectedDate = DateTime.now();
  Function(CustomDateAndTimePickerWidgetData) dataChanged;
  String dateLabel;
  String timeLabel;
  String dateDropDownLabel;
  CustomDateAndTimePickerWidgetController controller;
  late List<DropdownWidgetItem> dateItems;

  CustomDateAndTimePickerWidget({
    super.key,
    required this.dataChanged,
    required this.dateLabel,
    required this.timeLabel,
    required this.dateDropDownLabel,
    required this.controller,
    List<DropdownWidgetItem>? dateItemsParam,
  }) {
    dateItems =
        dateItemsParam ?? CustomDateAndTimePickerWidgetConsts.defaultDateItems;
  }

  @override
  State<CustomDateAndTimePickerWidget> createState() =>
      _CustomDateAndTimePickerWidgetState();
}

class _CustomDateAndTimePickerWidgetState
    extends State<CustomDateAndTimePickerWidget> {
  String dateType = CustomDateAndTimePickerDateTypes.toDay;
  DropdownWidgetItem selectedValue =
      CustomDateAndTimePickerWidgetConsts.todayDateItem;

  TimeOfDay? selectedTime = const TimeOfDay(hour: 10, minute: 0);

  @override
  void initState() {
    var value = widget.controller.value;
    selectedTime = value.selectedTime;
    dateType = value.dateType;

    super.initState();
  }

  Duration getDurationFromTimePicker() {
    if (selectedTime == null) {
      return const Duration();
    }

    return Duration(hours: selectedTime!.hour, minutes: selectedTime!.minute);
  }

  DateTime getDate() {
    var todayNoTime = DateUtils.dateOnly(DateTime.now());

    if (dateType == CustomDateAndTimePickerDateTypes.toDay) {
      return todayNoTime.add(getDurationFromTimePicker());
    }

    if (dateType == CustomDateAndTimePickerDateTypes.tommorow) {
      return DateUtils.dateOnly(DateTime.now())
          .add(const Duration(days: 1))
          .add(getDurationFromTimePicker());
    }

    return DateUtils.dateOnly(widget.selectedDate)
        .add(getDurationFromTimePicker());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownWidget(
          label: widget.dateDropDownLabel,
          items: widget.dateItems,
          value: selectedValue,
          changedHandler: (p) {
            if (p != null) {
              selectedValue = p;
              setState(() {
                dateType = p.value;
              });
              onDataChanged();
            }
          },
        ),
        const SizedBox(
          height: 10,
        ),
        dateType == CustomDateAndTimePickerDateTypes.custom
            ? DatePickerInput(
                label: widget.dateLabel,
                dateChanged: (p) {
                  if (p != null) {
                    widget.selectedDate = p;
                    onDataChanged();
                  }
                },
                startDate: DateTime.now().add(
                  const Duration(days: 2),
                ),
                lastDate: DateTime.now().add(
                  const Duration(days: 10),
                ),
                defaultValue: DateTime.now().add(
                  const Duration(days: 2),
                ),
              )
            : const SizedBox.shrink(),
        TimePickerInput(
          label: widget.timeLabel,
          pickedTime: selectedTime,
          timeChanged: (p) {
            selectedTime = p;
            onDataChanged();
          },
        ),
      ],
    );
  }

  void onDataChanged() {
    var value = CustomDateAndTimePickerWidgetData(
      dateType: dateType,
      dateTime: getDate(),
      selectedTime: selectedTime,
    );
    widget.controller.value = value;
    widget.dataChanged(
      value,
    );
  }
}
