import 'package:firebase_messaging/firebase_messaging.dart';

/// Base class for custom remote messages extending Firebase [RemoteMessage].
abstract class ICustomRemoteMessage extends RemoteMessage {
  const ICustomRemoteMessage({required super.notification, super.data});
}
