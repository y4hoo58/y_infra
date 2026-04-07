import 'package:dio/dio.dart';

class BaseNetworkConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;

  const BaseNetworkConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
  });

  Dio createDio() => Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: connectTimeout,
          receiveTimeout: receiveTimeout,
          sendTimeout: sendTimeout,
        ),
      );
}
