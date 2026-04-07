import 'package:firebase_messaging/firebase_messaging.dart';

import '../objects/i_remote_message_handler_result.dart';

/// Interface for processing incoming Firebase remote messages into handler results.
abstract class IRemoteMessageHandler {
  const IRemoteMessageHandler();

  IRemoteMessageHandlerResult? handle(RemoteMessage message);
}
