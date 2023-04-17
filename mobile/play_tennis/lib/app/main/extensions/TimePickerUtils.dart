import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';

class TimePickerUtils {
  static String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static String formatDateTime(DateTime date) {
    return formatTime(TimeOfDay(hour: date.hour, minute: date.minute));
  }
}
