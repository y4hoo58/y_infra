import '../app_error.dart';
import '../error_category.dart';
import '../error_messages.dart';

/// Error indicating the user is not authenticated or lacks permission.
class UnauthorisedError extends AppError {
  UnauthorisedError({
    String? message,
    Object? originalError,
  }) : super(
          code: 'unauthorised',
          message: message ?? ErrorMessages.instance.unauthorised,
          category: ErrorCategory.authentication,
          originalError: originalError,
        );
}
