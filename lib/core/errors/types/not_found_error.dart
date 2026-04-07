import '../app_error.dart';
import '../error_category.dart';

/// Error indicating a requested resource was not found (HTTP 404).
class NotFoundError extends AppError {
  const NotFoundError({
    String message = 'The requested resource was not found.',
    Object? originalError,
  }) : super(
          code: 'not_found',
          message: message,
          category: ErrorCategory.notFound,
          originalError: originalError,
        );
}
