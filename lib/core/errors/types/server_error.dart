import '../app_error.dart';
import '../error_category.dart';

class ServerError extends AppError {
  const ServerError({
    String message = 'Server error. Please try again later.',
    Object? originalError,
  }) : super(
          code: 'server',
          message: message,
          category: ErrorCategory.server,
          originalError: originalError,
        );
}
