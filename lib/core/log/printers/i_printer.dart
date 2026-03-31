import '../objects/log_data.dart';

abstract class IPrinter {
  const IPrinter();

  void print(LogData data);
}
