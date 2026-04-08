import '../app_error.dart';
import '../error_category.dart';
import '../error_messages.dart';

/// Error indicating a resource conflict, typically from HTTP 409 responses.
class ConflictError extends AppError {
  ConflictError({
    String? message,
    Object? originalError,
  }) : super(
          code: 'conflict',
          message: message ?? ErrorMessages.instance.conflict,
          category: ErrorCategory.conflict,
          originalError: originalError,
        );
}
