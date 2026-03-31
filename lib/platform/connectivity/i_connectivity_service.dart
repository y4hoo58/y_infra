import 'package:connectivity_plus/connectivity_plus.dart';

abstract class IConnectivityService {
  Stream<bool> get onStatusChange;
  Future<bool> get isConnected;
  List<ConnectivityResult> get lastResults;
  void dispose();
}
