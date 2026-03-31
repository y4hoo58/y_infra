import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../configs/notification_channel_config.dart';

abstract class ICustomNotificationContent extends NotificationContent {
  ICustomNotificationContent(
    PushNotificationChannelConfig channelConfig,
    RemoteNotification notification, {
    NotificationLayout layout = NotificationLayout.Default,
    String? imageUrl,
    super.payload,
  }) : super(
          id: DateTime.now().millisecondsSinceEpoch.hashCode,
          channelKey: channelConfig.channelKey,
          title: notification.title,
          body: notification.body,
          criticalAlert: true,
          notificationLayout: layout,
          bigPicture: imageUrl,
        );
}
