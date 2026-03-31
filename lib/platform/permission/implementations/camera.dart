import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import '../i_permission_handler.dart';

class CameraPermissionHandler extends IPermissionHandler {
  const CameraPermissionHandler();

  @override
  Future<bool> get g2g {
    if (Platform.isAndroid) {
      return const AndroidCameraPermissionHandler().g2g;
    } else if (Platform.isIOS) {
      return const IosCameraPermissionHandler().g2g;
    }

    throw Exception('Platform not supported');
  }

  @override
  Future<void> askPermIfNeeded() async {
    if (Platform.isAndroid) {
      return const AndroidCameraPermissionHandler().askPermIfNeeded();
    } else if (Platform.isIOS) {
      return const IosCameraPermissionHandler().askPermIfNeeded();
    }

    throw Exception('Platform not supported');
  }
}

class AndroidCameraPermissionHandler extends CameraPermissionHandler {
  const AndroidCameraPermissionHandler();

  @override
  Future<bool> get g2g async {
    final status = await Permission.camera.status;

    return status.isGranted ||
        status.isLimited ||
        status.isProvisional ||
        status.isRestricted;
  }

  @override
  Future<void> askPermIfNeeded() async {
    final status = await Permission.camera.status;

    if (status.isGranted) return;

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }

    await Permission.camera.request();
  }
}

class IosCameraPermissionHandler extends CameraPermissionHandler {
  const IosCameraPermissionHandler();

  @override
  Future<bool> get g2g async {
    final status = await Permission.camera.status;

    return status.isGranted ||
        status.isLimited ||
        status.isProvisional ||
        status.isRestricted;
  }

  @override
  Future<void> askPermIfNeeded() async {
    final status = await Permission.camera.status;

    if (status.isGranted) return;

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }

    await Permission.camera.request();
  }
}
