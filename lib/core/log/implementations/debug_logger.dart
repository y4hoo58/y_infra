import 'package:flutter/foundation.dart';

import '../i_logger.dart';
import '../objects/log_data.dart';
import '../printers/console_printer.dart';

class DebugLogger extends ILogger {
  const DebugLogger();

  @override
  void log(LogData data) {
    if (!kDebugMode) return;
    const ConsolePrinter().print(data);
  }
}

class ReleaseLogger extends ILogger {
  const ReleaseLogger();

  @override
  void log(LogData data) {}
}
