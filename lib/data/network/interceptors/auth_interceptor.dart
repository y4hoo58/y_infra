import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../auth/implementations/auth_token_storage.dart';
import '../../../auth/objects/token_pair.dart';

typedef TokenRefreshCallback = Future<TokenPair?> Function(String refreshToken);
typedef AuthFailureCallback = void Function();

/// Attaches JWT access tokens to outgoing requests and handles token refresh.
///
/// - Proactively refreshes tokens that are about to expire (within [_refreshThreshold]).
/// - On 401 responses, attempts a single token refresh and retries the request via [_retryDio].
/// - Concurrent requests during a refresh are queued and resolved with the new token.
/// - Paths listed in [_skipAuthPaths] bypass authentication entirely.
///
/// Compatible with [InterceptorPipeline] — can be used standalone or as part of a pipeline.
class AuthInterceptor extends Interceptor {
  final AuthTokenStorage _authTokenStorage;
  final TokenRefreshCallback _onTokenRefresh;
  final AuthFailureCallback _onAuthFailure;
  final Dio _retryDio;
  final List<String> _skipAuthPaths;

  static const _refreshThreshold = Duration(minutes: 1);

  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  AuthInterceptor({
    required AuthTokenStorage authTokenStorage,
    required TokenRefreshCallback onTokenRefresh,
    required AuthFailureCallback onAuthFailure,
    required Dio retryDio,
    List<String> skipAuthPaths = const [],
  })  : _authTokenStorage = authTokenStorage,
        _onTokenRefresh = onTokenRefresh,
        _onAuthFailure = onAuthFailure,
        _retryDio = retryDio,
        _skipAuthPaths = skipAuthPaths;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    for (final path in _skipAuthPaths) {
      if (options.path.contains(path)) {
        return handler.next(options);
      }
    }

    final tokenPair = await _authTokenStorage.getTokenPair();
    if (tokenPair == null) {
      return handler.next(options);
    }

    var accessToken = tokenPair.accessToken;
    final exp = _getTokenExpiry(accessToken);
    final isExpiring =
        exp != null && exp.difference(DateTime.now()) < _refreshThreshold;

    if (isExpiring) {
      final newToken = await _ensureValidToken();
      if (newToken != null) accessToken = newToken;
    }

    options.headers['Authorization'] = 'Bearer $accessToken';
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    for (final path in _skipAuthPaths) {
      if (err.requestOptions.path.contains(path)) {
        return handler.next(err);
      }
    }

    final newToken = await _ensureValidToken();
    if (newToken == null) {
      return handler.next(err);
    }

    try {
      err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
      final response = await _retryDio.fetch(err.requestOptions);
      return handler.resolve(response);
    } catch (_) {
      return handler.next(err);
    }
  }

  Future<String?> _ensureValidToken() async {
    if (_isRefreshing && _refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      final currentPair = await _authTokenStorage.getTokenPair();
      if (currentPair == null) {
        await _handleAuthFailure();
        _refreshCompleter!.complete(null);
        return null;
      }

      final newPair = await _onTokenRefresh(currentPair.refreshToken);
      if (newPair == null) {
        await _handleAuthFailure();
        _refreshCompleter!.complete(null);
        return null;
      }

      await _authTokenStorage.saveTokenPair(newPair);

      _refreshCompleter!.complete(newPair.accessToken);
      return newPair.accessToken;
    } catch (e) {
      if (kDebugMode) debugPrint('Token refresh failed: $e');
      await _handleAuthFailure();
      _refreshCompleter!.complete(null);
      return null;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  static DateTime? _getTokenExpiry(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload =
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final json = jsonDecode(payload) as Map<String, dynamic>;
      final exp = json['exp'] as int?;
      if (exp == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } catch (_) {
      return null;
    }
  }

  Future<void> _handleAuthFailure() async {
    await _authTokenStorage.clearTokens();
    _isRefreshing = false;
    _onAuthFailure();
  }
}
