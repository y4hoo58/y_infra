import 'dart:async';

import 'package:dio/dio.dart';

/// A composable interceptor that delegates to an ordered list of interceptors.
///
/// Each interceptor runs in sequence. If any interceptor resolves or rejects,
/// the remaining interceptors are skipped.
///
/// ```dart
/// final dio = Dio();
/// dio.interceptors.add(
///   InterceptorPipeline([
///     ConnectivityInterceptor(connectivityService),
///     HeaderInterceptor(appVersion: '1.0.0'),
///     AuthInterceptor(...),
///     RetryInterceptor(dio: dio),
///   ]),
/// );
/// ```
class InterceptorPipeline extends Interceptor {
  final List<Interceptor> interceptors;

  InterceptorPipeline(this.interceptors);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    var current = options;

    for (final interceptor in interceptors) {
      final proxy = _RequestProxy(current);
      await _run(() => interceptor.onRequest(current, proxy), proxy);

      switch (proxy.action) {
        case _Action.resolve:
          return handler.resolve(proxy.response!);
        case _Action.reject:
          return handler.reject(proxy.error!);
        default:
          current = proxy.modifiedOptions ?? current;
      }
    }

    handler.next(current);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    var current = response;

    for (final interceptor in interceptors) {
      final proxy = _ResponseProxy(current);
      await _run(() => interceptor.onResponse(current, proxy), proxy);

      switch (proxy.action) {
        case _Action.reject:
          return handler.reject(proxy.error!);
        default:
          current = proxy.modifiedResponse ?? current;
      }
    }

    handler.next(current);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    var current = err;

    for (final interceptor in interceptors) {
      final proxy = _ErrorProxy(current);
      await _run(() => interceptor.onError(current, proxy), proxy);

      switch (proxy.action) {
        case _Action.resolve:
          return handler.resolve(proxy.response!);
        default:
          current = proxy.modifiedError ?? current;
      }
    }

    handler.next(current);
  }

  Future<void> _run(Function() fn, _BaseProxy proxy) async {
    try {
      final result = fn();
      if (result is Future) await result;
    } catch (e) {
      if (!proxy.isHandled) {
        proxy.handleException(e);
      }
    }
  }
}

// -- Internal pipeline machinery --

enum _Action { next, resolve, reject }

abstract class _BaseProxy {
  bool get isHandled;
  void handleException(Object error);
}

class _RequestProxy extends RequestInterceptorHandler implements _BaseProxy {
  final RequestOptions _original;
  _Action? action;
  RequestOptions? modifiedOptions;
  Response? response;
  DioException? error;

  _RequestProxy(this._original);

  @override
  bool get isHandled => action != null;

  @override
  void next(RequestOptions requestOptions) {
    action = _Action.next;
    modifiedOptions = requestOptions;
  }

  @override
  void resolve(Response response, [bool callFollowingResponseInterceptor = false]) {
    action = _Action.resolve;
    this.response = response;
  }

  @override
  void reject(DioException error,
      [bool callFollowingErrorInterceptor = false]) {
    action = _Action.reject;
    this.error = error;
  }

  @override
  void handleException(Object error) {
    action = _Action.reject;
    this.error = DioException(requestOptions: _original, error: error);
  }
}

class _ResponseProxy extends ResponseInterceptorHandler implements _BaseProxy {
  final Response _original;
  _Action? action;
  Response? modifiedResponse;
  DioException? error;

  _ResponseProxy(this._original);

  @override
  bool get isHandled => action != null;

  @override
  void next(Response response) {
    action = _Action.next;
    modifiedResponse = response;
  }

  @override
  void reject(DioException error,
      [bool callFollowingErrorInterceptor = false]) {
    action = _Action.reject;
    this.error = error;
  }

  @override
  void handleException(Object error) {
    action = _Action.reject;
    this.error = DioException(
      requestOptions: _original.requestOptions,
      error: error,
    );
  }
}

class _ErrorProxy extends ErrorInterceptorHandler implements _BaseProxy {
  final DioException _original;
  _Action? action;
  Response? response;
  DioException? modifiedError;

  _ErrorProxy(this._original);

  @override
  bool get isHandled => action != null;

  @override
  void next(DioException error) {
    action = _Action.next;
    modifiedError = error;
  }

  @override
  void resolve(Response response) {
    action = _Action.resolve;
    this.response = response;
  }

  @override
  void handleException(Object error) {
    action = _Action.next;
    modifiedError = DioException(
      requestOptions: _original.requestOptions,
      error: error,
    );
  }
}
