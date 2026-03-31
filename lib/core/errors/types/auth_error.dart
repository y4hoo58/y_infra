import '../app_error.dart';
import '../error_category.dart';

class UnauthorisedError extends AppError {
  const UnauthorisedError({
    String message = 'You are not authorised to perform this action.',
    Object? originalError,
  }) : super(
          code: 'unauthorised',
          message: message,
          category: ErrorCategory.authentication,
          originalError: originalError,
        );
}
