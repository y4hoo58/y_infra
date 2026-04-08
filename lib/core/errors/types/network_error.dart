import '../app_error.dart';
import '../error_category.dart';
import '../error_messages.dart';

/// Error indicating a network connectivity failure.
class NetworkError extends AppError {
  NetworkError({
    String? message,
    Object? originalError,
  }) : super(
          code: 'network',
          message: message ?? ErrorMessages.instance.networkError,
          category: ErrorCategory.network,
          originalError: originalError,
        );
}

/// Error indicating a connection or request timeout.
class TimeoutError extends AppError {
  TimeoutError({
    String? message,
    Object? originalError,
  }) : super(
          code: 'timeout',
          message: message ?? ErrorMessages.instance.timeout,
          category: ErrorCategory.network,
          originalError: originalError,
        );
}

/// Error indicating the client has exceeded the server's rate limit.
class RateLimitError extends AppError {
  RateLimitError({
    String? message,
    Object? originalError,
  }) : super(
          code: 'rate_limit',
          message: message ?? ErrorMessages.instance.rateLimit,
          category: ErrorCategory.network,
          originalError: originalError,
        );

  @override
  bool get isRetryable => false;
}
