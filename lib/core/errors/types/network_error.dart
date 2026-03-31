import '../app_error.dart';
import '../error_category.dart';

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
