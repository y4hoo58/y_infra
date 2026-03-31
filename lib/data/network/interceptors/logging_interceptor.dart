import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌─────────────────────────────────────────────────────────────');
      print('│ REQUEST');
      print('├─────────────────────────────────────────────────────────────');
      print('│ ${options.method} ${options.uri}');
      print('│ Headers:');
      options.headers.forEach((key, value) {
        if (key.toLowerCase() == 'authorization') {
          final token = value.toString();
          final masked =
              token.length > 20 ? '${token.substring(0, 20)}...' : token;
          print('│   $key: $masked');
        } else {
          print('│   $key: $value');
        }
      });
      if (options.queryParameters.isNotEmpty) {
        print('│ Query Parameters:');
        options.queryParameters.forEach((key, value) {
          print('│   $key: $value');
        });
      }
      if (options.data != null) {
        print('│ Body:');
        print('│   ${options.data}');
      }
      print('└─────────────────────────────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌─────────────────────────────────────────────────────────────');
      print('│ RESPONSE');
      print('├─────────────────────────────────────────────────────────────');
      print(
        '│ ${response.requestOptions.method} ${response.requestOptions.uri}',
      );
      print('│ Status: ${response.statusCode} ${response.statusMessage}');
      if (response.data != null) {
        print('│ Body:');
        final data = response.data.toString();
        if (data.length > 500) {
          print('│   ${data.substring(0, 500)}... [truncated]');
        } else {
          print('│   $data');
        }
      }
      print('└─────────────────────────────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('┌─────────────────────────────────────────────────────────────');
      print('│ ERROR');
      print('├─────────────────────────────────────────────────────────────');
      print('│ ${err.requestOptions.method} ${err.requestOptions.uri}');
      print('│ Type: ${err.type}');
      print('│ Message: ${err.message}');
      if (err.response != null) {
        print(
          '│ Status: ${err.response?.statusCode} ${err.response?.statusMessage}',
        );
        final data = err.response?.data.toString() ?? 'null';
        if (data.length > 500) {
          print('│ Body: ${data.substring(0, 500)}... [truncated]');
        } else {
          print('│ Body: $data');
        }
      }
      print('└─────────────────────────────────────────────────────────────');
    }
    handler.next(err);
  }
}
