import '../app_error.dart';
import '../error_category.dart';

class UnexpectedError extends AppError {
  const UnexpectedError({
    String message = 'An unexpected error occurred. Please try again.',
    Object? originalError,
    StackTrace? stackTrace,
  }) : super(
          code: 'unexpected',
          message: message,
          category: ErrorCategory.unknown,
          originalError: originalError,
          stackTrace: stackTrace,
        );
}
