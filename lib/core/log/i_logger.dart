import 'objects/log_data.dart';

abstract class ILogger {
  const ILogger();

  void log(LogData data);
}
