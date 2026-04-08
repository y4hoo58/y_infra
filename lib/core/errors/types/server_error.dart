import '../app_error.dart';
import '../error_category.dart';
import '../error_messages.dart';

/// Error indicating a server-side failure (HTTP 5xx).
class ServerError extends AppError {
  ServerError({
    String? message,
    Object? originalError,
  }) : super(
          code: 'server',
          message: message ?? ErrorMessages.instance.serverError,
          category: ErrorCategory.server,
          originalError: originalError,
        );
}
