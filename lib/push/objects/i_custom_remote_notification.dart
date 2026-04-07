import 'package:firebase_messaging/firebase_messaging.dart';

/// Base class for custom remote notifications extending Firebase [RemoteNotification].
abstract class ICustomRemoteNotification extends RemoteNotification {
  const ICustomRemoteNotification({super.title, super.body});
}
