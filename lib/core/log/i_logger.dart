import 'objects/log_data.dart';

/// Interface for a logger that accepts structured [LogData] entries.
abstract class ILogger {
  const ILogger();

  void log(LogData data);
}
