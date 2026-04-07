import 'package:permission_handler/permission_handler.dart';

import '../i_permission_handler.dart';

/// Handler for requesting and checking general storage permission.
class StoragePermissionHandler extends IPermissionHandler {
  const StoragePermissionHandler();

  @override
  Future<bool> get g2g => Permission.storage.isGranted;

  @override
  Future<void> askPermIfNeeded() async {
    final status = await Permission.storage.status;

    if (!status.isGranted) await Permission.storage.request();
  }
}
