import 'error_category.dart';

class AppError implements Exception {
  final String code;
  final String message;
  final ErrorCategory category;
  final Object? originalError;
  final StackTrace? stackTrace;

  const AppError({
    required this.code,
    required this.message,
    this.category = ErrorCategory.unknown,
    this.originalError,
    this.stackTrace,
  });

  bool get isRetryable =>
      category == ErrorCategory.network || category == ErrorCategory.server;

  bool get shouldShowToUser => category != ErrorCategory.unknown;

  @override
  String toString() => 'AppError($code): $message';
}
