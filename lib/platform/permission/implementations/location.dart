import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import '../i_permission_handler.dart';

/// Platform-aware handler for requesting and checking location permission.
class LocationPermissionHandler extends IPermissionHandler {
  const LocationPermissionHandler();

  @override
  Future<bool> get g2g {
    return Platform.isAndroid
        ? const AndroidLocationPermissionHandler().g2g
        : const IosLocationPermissionHandler().g2g;
  }

  @override
  Future<void> askPermIfNeeded() {
    return Platform.isAndroid
        ? const AndroidLocationPermissionHandler().askPermIfNeeded()
        : const IosLocationPermissionHandler().askPermIfNeeded();
  }
}

/// iOS-specific location permission handler.
class IosLocationPermissionHandler extends IPermissionHandler {
  const IosLocationPermissionHandler();

  @override
  Future<bool> get g2g async {
    final status = await Permission.locationWhenInUse.status;

    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        return true;
      case PermissionStatus.restricted:
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
        return false;
    }
  }

  @override
  Future<void> askPermIfNeeded() async {
    final status = await Permission.location.status;

    switch (status) {
      case PermissionStatus.denied:
        await Permission.location.request();
        break;
      case PermissionStatus.permanentlyDenied:
        await openAppSettings();
        break;
      default:
        break;
    }
  }
}

/// Android-specific location permission handler.
class AndroidLocationPermissionHandler extends IPermissionHandler {
  const AndroidLocationPermissionHandler();

  @override
  Future<bool> get g2g async {
    final status = await Permission.location.status;

    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        return true;
      case PermissionStatus.restricted:
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
        return false;
    }
  }

  @override
  Future<void> askPermIfNeeded() async {
    final status = await Permission.location.status;

    switch (status) {
      case PermissionStatus.denied:
        await Permission.location.request();
        break;
      case PermissionStatus.permanentlyDenied:
        await openAppSettings();
        break;
      default:
        break;
    }
  }
}
