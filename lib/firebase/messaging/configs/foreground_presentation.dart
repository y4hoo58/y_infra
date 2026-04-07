/// Configuration for how foreground notifications are presented (alert, badge, sound).
abstract class IFirebaseForegroundNotificationPresentationConfig {
  final bool alert;
  final bool badge;
  final bool sound;

  const IFirebaseForegroundNotificationPresentationConfig({
    required this.alert,
    required this.badge,
    required this.sound,
  });
}
