import 'package:firebase_messaging/firebase_messaging.dart';

abstract class ICustomRemoteNotification extends RemoteNotification {
  const ICustomRemoteNotification({super.title, super.body});
}
