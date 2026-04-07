import '../app_error.dart';
import '../error_category.dart';

/// Error representing input validation failures, optionally carrying a list
/// of individual field-level [errors].
class ValidationError extends AppError {
  final List<String>? errors;

  const ValidationError({
    String message = 'Validation error.',
    this.errors,
    Object? originalError,
  }) : super(
          code: 'validation',
          message: message,
          category: ErrorCategory.validation,
          originalError: originalError,
        );

  String get allErrors {
    if (errors == null || errors!.isEmpty) return message;
    return errors!.join('\n');
  }
}
