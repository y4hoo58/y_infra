import 'package:permission_handler/permission_handler.dart';

import '../i_permission_handler.dart';

/// Handler for requesting and checking notification permission.
class NotificationPermissionHandler extends IPermissionHandler {
  const NotificationPermissionHandler();

  @override
  Future<bool> get g2g => Permission.notification.isGranted;

  @override
  Future<void> askPermIfNeeded() async {
    final status = await Permission.notification.status;

    if (!status.isGranted) await Permission.notification.request();
  }
}
