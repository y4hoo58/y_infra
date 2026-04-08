import '../app_error.dart';
import '../error_category.dart';
import '../error_messages.dart';

/// Error indicating a requested resource was not found (HTTP 404).
class NotFoundError extends AppError {
  NotFoundError({
    String? message,
    Object? originalError,
  }) : super(
          code: 'not_found',
          message: message ?? ErrorMessages.instance.notFound,
          category: ErrorCategory.notFound,
          originalError: originalError,
        );
}
