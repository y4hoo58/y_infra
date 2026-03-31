import 'package:permission_handler/permission_handler.dart';

import '../i_permission_handler.dart';

class ExternalStoragePermissionHandler extends IPermissionHandler {
  const ExternalStoragePermissionHandler();

  @override
  Future<bool> get g2g => Permission.storage.isGranted;

  @override
  Future<void> askPermIfNeeded() async {
    final status = await Permission.manageExternalStorage.status;

    if (!status.isGranted) await Permission.manageExternalStorage.request();
  }
}
