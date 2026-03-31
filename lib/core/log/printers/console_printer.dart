import 'dart:io';

import 'package:flutter/foundation.dart';

import '../objects/log_level.dart';
import '../objects/log_data.dart';
import 'i_printer.dart';

class ConsolePrinter extends IPrinter {
  const ConsolePrinter();

  @override
  void print(LogData data) {
    LogLevel level = data.level;
    String objMessage = data.message;

    String message = "${data.timeAsString}${level.label}$objMessage";

    if (Platform.isIOS) return debugPrint(message);

    if (level == LogLevel.error) {
      message = "\x1B[31m$message\x1B[0m";
    } else if (level == LogLevel.debug) {
      message = "\x1B[36m$message\x1B[0m";
    } else if (level == LogLevel.value) {
      message = "\x1B[33m$message\x1B[0m";
    } else if (level == LogLevel.warning) {
      message = "\x1B[35m$message\x1B[0m";
    } else if (level == LogLevel.event) {
      message = "\x1B[37m$message\x1B[0m";
    }

    debugPrint(message);
  }
}
