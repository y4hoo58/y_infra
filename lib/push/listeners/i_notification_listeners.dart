import 'package:awesome_notifications/awesome_notifications.dart';

/// Defines callbacks for Awesome Notifications lifecycle events (action, dismiss, create, display).
abstract class INotificationListeners {
  final Future<void> Function(ReceivedAction r) onActionReceived;
  final Future<void> Function(ReceivedAction r) onDismissActionReceived;
  final Future<void> Function(ReceivedNotification r) onNotificationCreated;
  final Future<void> Function(ReceivedNotification r) onNotificationDisplayed;

  const INotificationListeners({
    required this.onActionReceived,
    required this.onDismissActionReceived,
    required this.onNotificationCreated,
    required this.onNotificationDisplayed,
  });

  void set();
}
