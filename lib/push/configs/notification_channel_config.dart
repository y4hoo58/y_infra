import 'package:awesome_notifications/awesome_notifications.dart';

import '../utility/environment_interpreter.dart';

/// Configuration for an Awesome Notifications channel, constructable from environment variables.
class PushNotificationChannelConfig {
  final String channelKey;
  final String channelName;
  final String channelDescription;
  final bool criticalAlerts;
  final bool onlyAlertOnce;
  final bool playSound;
  final bool enableVibration;
  final bool locked;
  final NotificationImportance importance;

  const PushNotificationChannelConfig({
    required this.channelKey,
    required this.channelName,
    required this.channelDescription,
    this.criticalAlerts = true,
    this.onlyAlertOnce = true,
    this.playSound = true,
    this.enableVibration = true,
    this.locked = true,
    this.importance = NotificationImportance.Max,
  });

  NotificationChannel get channel => NotificationChannel(
        channelKey: channelKey,
        channelName: channelName,
        channelDescription: channelDescription,
        criticalAlerts: criticalAlerts,
        onlyAlertOnce: onlyAlertOnce,
        playSound: playSound,
        enableVibration: enableVibration,
        locked: locked,
        importance: importance,
      );

  factory PushNotificationChannelConfig.fromEnv(
    String prefix,
    Map<String, String> env,
  ) {
    final interpreter = const EnvironmentInterpreter();

    return PushNotificationChannelConfig(
      channelKey: env['${prefix}_CHANNEL_KEY']!,
      channelName: env['${prefix}_CHANNEL_NAME']!,
      channelDescription: env['${prefix}_CHANNEL_DESCRIPTION']!,
      criticalAlerts: interpreter.isTrue(env['${prefix}_CRITICAL_ALERTS']),
      onlyAlertOnce: interpreter.isTrue(env['${prefix}_ONLY_ALERT_ONCE']),
      playSound: interpreter.isTrue(env['${prefix}_PLAY_SOUND']),
      enableVibration: interpreter.isTrue(env['${prefix}_ENABLE_VIBRATION']),
      locked: interpreter.isTrue(env['${prefix}_LOCKED']),
      importance: interpreter.mapImportanceToEnum(env['${prefix}_IMPORTANCE']),
    );
  }
}
