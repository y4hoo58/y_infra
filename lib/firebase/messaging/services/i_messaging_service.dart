import 'package:firebase_messaging/firebase_messaging.dart';

import '../configs/foreground_presentation.dart';
import '../listeners/i_message_listener.dart';

/// Interface for Firebase Cloud Messaging setup, token retrieval, and listener registration.
abstract class IFirebaseMessagingService {
  final IFirebaseMessageListener messageListeners;
  final IFirebaseForegroundNotificationPresentationConfig
      foregroundNotificationPresentationConfig;

  const IFirebaseMessagingService(
    this.messageListeners,
    this.foregroundNotificationPresentationConfig,
  );

  FirebaseMessaging get instance => FirebaseMessaging.instance;

  Future<String?> get token;

  void init();
}
