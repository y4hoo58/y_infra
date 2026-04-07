import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface for monitoring network connectivity status changes.
abstract class IConnectivityService {
  Stream<bool> get onStatusChange;
  Future<bool> get isConnected;
  List<ConnectivityResult> get lastResults;
  void dispose();
}
