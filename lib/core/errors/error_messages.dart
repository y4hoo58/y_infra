/// Centralised, overridable error messages for the entire error system.
///
/// Override [instance] at app startup to provide localised messages:
///
/// ```dart
/// ErrorMessages.instance = ErrorMessages(
///   networkError: 'errors.network'.tr(),
///   serverError: 'errors.server'.tr(),
///   // ...
/// );
/// ```
class ErrorMessages {
  static ErrorMessages instance = const ErrorMessages();

  final String networkError;
  final String timeout;
  final String rateLimit;
  final String unauthorised;
  final String sessionExpired;
  final String serverError;
  final String conflict;
  final String notFound;
  final String unexpectedError;
  final String validationError;
  final String badRequest;
  final String badCertificate;
  final String requestCancelled;
  final String genericError;

  const ErrorMessages({
    this.networkError = 'Network error. Please check your connection.',
    this.timeout = 'Connection timed out.',
    this.rateLimit = 'Too many requests. Please wait a moment.',
    this.unauthorised = 'You are not authorised to perform this action.',
    this.sessionExpired = 'Session expired. Please log in again.',
    this.serverError = 'Server error. Please try again later.',
    this.conflict = 'This resource already exists.',
    this.notFound = 'The requested resource was not found.',
    this.unexpectedError = 'An unexpected error occurred. Please try again.',
    this.validationError = 'Validation error.',
    this.badRequest = 'Bad request.',
    this.badCertificate = 'Security certificate error.',
    this.requestCancelled = 'Request cancelled.',
    this.genericError = 'An error occurred.',
  });
}
