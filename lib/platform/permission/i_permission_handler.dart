abstract class IPermissionHandler {
  const IPermissionHandler();

  Future<void> askPermIfNeeded();

  Future<bool> get g2g;
}
