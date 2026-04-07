/// Severity levels for log entries, from informational events to errors.
enum LogLevel {
  event,
  debug,
  info,
  warning,
  error,
  value,
}

extension LogLevelExtension on LogLevel {
  String get label => "[$tag]";

  String get tag {
    switch (this) {
      case LogLevel.event:
        return "EVENT";
      case LogLevel.value:
        return "VALUE";
      case LogLevel.debug:
        return "DEBUG";
      case LogLevel.info:
        return "INFO";
      case LogLevel.warning:
        return "WARNING";
      case LogLevel.error:
        return "ERROR";
    }
  }

  static List<LogLevel> get allLevels => [
        LogLevel.event,
        LogLevel.value,
        LogLevel.debug,
        LogLevel.info,
        LogLevel.warning,
        LogLevel.error,
      ];

  static LogLevel fromString(String value) {
    switch (value) {
      case "EVENT":
        return LogLevel.event;
      case "VALUE":
        return LogLevel.value;
      case "DEBUG":
        return LogLevel.debug;
      case "INFO":
        return LogLevel.info;
      case "WARNING":
        return LogLevel.warning;
      case "ERROR":
        return LogLevel.error;
      default:
        throw "Unknown log level: $value";
    }
  }
}
