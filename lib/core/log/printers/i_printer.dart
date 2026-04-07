import '../objects/log_data.dart';

/// Interface for outputting formatted [LogData] to a destination.
abstract class IPrinter {
  const IPrinter();

  void print(LogData data);
}
