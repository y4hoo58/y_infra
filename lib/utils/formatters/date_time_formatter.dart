import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class DateTimeFormatter {
  const DateTimeFormatter();

  String dateFormatter(DateTime dateTime, BuildContext context) {
    final locale = context.locale.toStringWithSeparator();
    final format = DateFormat('dd MMMM yyyy', locale);
    return format.format(dateTime);
  }

  String timeFormatter(DateTime dateTime, BuildContext context) {
    final locale = context.locale.toStringWithSeparator();
    final format = DateFormat('HH:mm', locale);
    return format.format(dateTime);
  }

  String formatSeconds(int totalSeconds, String minShort) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')} $minShort';
  }
}
