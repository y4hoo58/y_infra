import 'package:permission_handler/permission_handler.dart';

import '../i_permission_handler.dart';

/// Handler for requesting and checking external storage (manage) permission.
class ExternalStoragePermissionHandler extends IPermissionHandler {
  const ExternalStoragePermissionHandler();

  @override
  Future<bool> get g2g => Permission.manageExternalStorage.isGranted;

  @override
  Future<void> askPermIfNeeded() async {
    final status = await Permission.manageExternalStorage.status;

    if (!status.isGranted) await Permission.manageExternalStorage.request();
  }
}
