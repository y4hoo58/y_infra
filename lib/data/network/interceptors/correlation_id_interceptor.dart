import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

class CorrelationIdInterceptor extends Interceptor {
  static const _uuid = Uuid();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['x-correlation-id'] = _uuid.v4();
    handler.next(options);
  }
}
