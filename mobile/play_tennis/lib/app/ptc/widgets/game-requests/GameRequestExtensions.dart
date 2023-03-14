import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:play_tennis/app/main/extensions/TimePickerUtils.dart';

class GameRequestExtensions {
  static String getDateString(DateTime dateUtc) {
    if (DateUtils.dateOnly(dateUtc) == DateUtils.dateOnly(DateTime.now())) {
      return "Сегодня ${getTimeString(dateUtc)}";
    }

    //По-умолчанию используется московское время
    return "${DateFormat.MMMMd('ru').format(dateUtc.toLocal())} ${getTimeString(dateUtc)}";
  }

  static String getTimeString(DateTime dateUtc) {
    return TimePickerUtils.formatDateTime(
        dateUtc.add(const Duration(hours: 3)));
  }
}
