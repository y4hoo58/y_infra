/// Interface for checking and requesting a specific platform permission.
abstract class IPermissionHandler {
  const IPermissionHandler();

  Future<void> askPermIfNeeded();

  Future<bool> get g2g;
}
