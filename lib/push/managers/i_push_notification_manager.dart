import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../configs/notification_channel_config.dart';
import '../listeners/i_notification_listeners.dart';
import '../objects/i_custom_remote_message.dart';

abstract class IPushNotificationManager {
  final INotificationListeners notificationListeners;
  final String envFilePath;
  final String? iconPath;

  IPushNotificationManager({
    required this.notificationListeners,
    required this.envFilePath,
    this.iconPath,
  });

  final List<PushNotificationChannelConfig> notificationChannelConfigs = [];

  List<NotificationChannel> get _notificationChannels {
    return notificationChannelConfigs
        .map((channelConfig) => channelConfig.channel)
        .toList();
  }

  List<String> _channelNames() {
    final names = dotenv.env["CHANNEL_CONFIGURATION_LIST"];

    if (names == null) {
      throw Exception("CHANNEL_CONFIGURATION_LIST is not set in the .env file");
    }

    return names.split(",");
  }

  void _createChannelConfigs() {
    final channelNames = _channelNames();

    for (String channelName in channelNames) {
      final prefix = channelName.toUpperCase().replaceAll(" ", "_");

      notificationChannelConfigs.add(
        PushNotificationChannelConfig.fromEnv(prefix, dotenv.env),
      );
    }
  }

  Future<void> init() async {
    await dotenv.load(fileName: envFilePath);

    _createChannelConfigs();

    await AwesomeNotifications().initialize(iconPath, _notificationChannels);

    notificationListeners.set();
  }

  void pushLocal(
    ICustomRemoteMessage message, {
    PushNotificationChannelConfig? channelConfig,
  }) {
    throw UnimplementedError();
  }

  void pushRemote(
    ICustomRemoteMessage message, {
    PushNotificationChannelConfig? channelConfig,
  }) {
    throw UnimplementedError();
  }
}
