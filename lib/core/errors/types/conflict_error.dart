import '../app_error.dart';
import '../error_category.dart';

class ConflictError extends AppError {
  const ConflictError({
    String message = 'This resource already exists.',
    Object? originalError,
  }) : super(
          code: 'conflict',
          message: message,
          category: ErrorCategory.conflict,
          originalError: originalError,
        );
}
