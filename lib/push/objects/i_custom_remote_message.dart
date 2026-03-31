import 'package:firebase_messaging/firebase_messaging.dart';

abstract class ICustomRemoteMessage extends RemoteMessage {
  const ICustomRemoteMessage({required super.notification, super.data});
}
