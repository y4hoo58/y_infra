import '../app_error.dart';
import '../error_category.dart';
import '../error_messages.dart';

/// Catch-all error for unclassified or unexpected failures.
class UnexpectedError extends AppError {
  UnexpectedError({
    String? message,
    Object? originalError,
    StackTrace? stackTrace,
  }) : super(
          code: 'unexpected',
          message: message ?? ErrorMessages.instance.unexpectedError,
          category: ErrorCategory.unknown,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}
