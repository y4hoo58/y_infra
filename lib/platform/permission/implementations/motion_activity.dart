import 'package:permission_handler/permission_handler.dart';

import '../i_permission_handler.dart';

class MotionActivityPermissionHandler extends IPermissionHandler {
  const MotionActivityPermissionHandler();

  @override
  Future<bool> get g2g => Permission.activityRecognition.isGranted;

  @override
  Future<void> askPermIfNeeded() async {
    final status = await Permission.activityRecognition.status;

    if (!status.isGranted) await Permission.activityRecognition.request();
  }
}
