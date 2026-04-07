import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../i_connectivity_service.dart';

/// Concrete connectivity service using the connectivity_plus package.
class ConnectivityService implements IConnectivityService {
  final Connectivity _connectivity;
  final _statusController = StreamController<bool>.broadcast();
  List<ConnectivityResult> _lastResults = [];

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity() {
    _init();
  }

  void _init() {
    _connectivity.onConnectivityChanged.listen((results) {
      _lastResults = results;
      _statusController.add(_isOnline(results));
    });
  }

  @override
  Stream<bool> get onStatusChange => _statusController.stream;

  @override
  Future<bool> get isConnected async {
    _lastResults = await _connectivity.checkConnectivity();
    return _isOnline(_lastResults);
  }

  @override
  List<ConnectivityResult> get lastResults => _lastResults;

  bool _isOnline(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }

  @override
  void dispose() {
    _statusController.close();
  }
}
