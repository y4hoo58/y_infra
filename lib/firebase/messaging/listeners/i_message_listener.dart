import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
abstract class IFirebaseMessageListener {
  final Function(RemoteMessage) onMessage;

  final Future<void> Function(RemoteMessage message) onBackgroundMessage;

  final Function(RemoteMessage) onMessageOpenedApp;

  const IFirebaseMessageListener({
    required this.onMessage,
    required this.onBackgroundMessage,
    required this.onMessageOpenedApp,
  });
}
