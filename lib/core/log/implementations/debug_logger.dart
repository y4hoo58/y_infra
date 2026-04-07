import 'package:flutter/foundation.dart';

import '../i_logger.dart';
import '../objects/log_data.dart';
import '../printers/console_printer.dart';

/// Logger that prints to the console only in debug mode.
class DebugLogger extends ILogger {
  const DebugLogger();

  @override
  void log(LogData data) {
    if (!kDebugMode) return;
    const ConsolePrinter().print(data);
  }
}

/// A no-op logger that silently discards all log entries.
class ReleaseLogger extends ILogger {
  const ReleaseLogger();

  @override
  void log(LogData data) {}
}
