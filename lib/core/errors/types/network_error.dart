import '../app_error.dart';
import '../error_category.dart';

/// Error indicating a network connectivity failure.
class NetworkError extends AppError {
  const NetworkError({
    String message = 'Network error. Please check your connection.',
    Object? originalError,
  }) : super(
          code: 'network',
          message: message,
          category: ErrorCategory.network,
          originalError: originalError,
        );
}

/// Error indicating a connection or request timeout.
class TimeoutError extends AppError {
  const TimeoutError({
    String message = 'Connection timed out.',
    Object? originalError,
  }) : super(
          code: 'timeout',
          message: message,
          category: ErrorCategory.network,
          originalError: originalError,
        );
}

/// Error indicating the client has exceeded the server's rate limit.
class RateLimitError extends AppError {
  const RateLimitError({
    String message = 'Too many requests. Please wait a moment.',
    Object? originalError,
  }) : super(
          code: 'rate_limit',
          message: message,
          category: ErrorCategory.network,
          originalError: originalError,
        );

  @override
  bool get isRetryable => false;
}
