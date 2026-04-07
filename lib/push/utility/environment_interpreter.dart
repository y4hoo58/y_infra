import 'package:awesome_notifications/awesome_notifications.dart';

/// Utility for parsing environment variable strings into typed values (booleans, enums).
class EnvironmentInterpreter {
  const EnvironmentInterpreter();

  bool isTrue(String? value) {
    if (value == null) return false;
    return value.toLowerCase() == "true";
  }

  NotificationImportance mapImportanceToEnum(String? value) {
    if (value == null) return NotificationImportance.Default;

    switch (value.toLowerCase()) {
      case "max":
        return NotificationImportance.Max;
      case "high":
        return NotificationImportance.High;
      case "default":
        return NotificationImportance.Default;
      case "low":
        return NotificationImportance.Low;
      case "min":
        return NotificationImportance.Min;
      case "none":
        return NotificationImportance.None;
      default:
        return NotificationImportance.Default;
    }
  }
}
