import 'package:dio/dio.dart';

import 'app_error.dart';
import 'error_messages.dart';
import 'types/auth_error.dart';
import 'types/conflict_error.dart';
import 'types/network_error.dart';
import 'types/not_found_error.dart';
import 'types/server_error.dart';
import 'types/unexpected_error.dart';
import 'types/validation_error.dart';

/// Maps raw exceptions (including [DioException]) to typed [AppError]
/// subclasses based on status codes and error types.
class ErrorMapper {
  ErrorMapper._();

  static AppError map(Object error, [StackTrace? stackTrace]) {
    if (error is AppError) return error;

    if (error is DioException) return _mapDioException(error, stackTrace);

    return UnexpectedError(
      message: error.toString(),
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  static AppError _mapDioException(DioException e, [StackTrace? stackTrace]) {
    final m = ErrorMessages.instance;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutError(originalError: e);

      case DioExceptionType.connectionError:
        return NetworkError(message: m.networkError);

      case DioExceptionType.badCertificate:
        return NetworkError(message: m.badCertificate);

      case DioExceptionType.badResponse:
        return _mapResponseError(e.response, e);

      case DioExceptionType.cancel:
        return UnexpectedError(
          message: m.requestCancelled,
          originalError: e,
        );

      case DioExceptionType.unknown:
        return NetworkError(originalError: e);
    }
  }

  static AppError _mapResponseError(Response? response, DioException original) {
    if (response == null) {
      return UnexpectedError(originalError: original);
    }

    final statusCode = response.statusCode;
    final data = response.data;
    final message = _extractMessage(data);
    final validationErrors = _extractValidationErrors(data);
    final m = ErrorMessages.instance;

    switch (statusCode) {
      case 400:
        return ValidationError(
          message: message ?? m.badRequest,
          errors: validationErrors,
          originalError: original,
        );

      case 401:
        return UnauthorisedError(
          message: message ?? m.sessionExpired,
          originalError: original,
        );

      case 403:
        return UnauthorisedError(
          message: message ?? m.unauthorised,
          originalError: original,
        );

      case 404:
        return NotFoundError(
          message: message ?? m.notFound,
          originalError: original,
        );

      case 409:
        return ConflictError(
          message: message ?? m.conflict,
          originalError: original,
        );

      case 422:
        return ValidationError(
          message: message ?? m.validationError,
          errors: validationErrors,
          originalError: original,
        );

      case 429:
        return RateLimitError(originalError: original);

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerError(
          message: message ?? m.serverError,
          originalError: original,
        );

      default:
        return UnexpectedError(
          message: message ?? m.genericError,
          originalError: original,
        );
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String?;
    }

    if (data is String) return data;

    return null;
  }

  static List<String>? _extractValidationErrors(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      final errors = data['errors'];

      if (errors is List) {
        return errors.map((e) => e.toString()).toList();
      }

      if (errors is Map<String, dynamic>) {
        final List<String> result = [];
        for (final entry in errors.entries) {
          if (entry.value is List) {
            for (final msg in entry.value) {
              result.add('${entry.key}: $msg');
            }
          } else {
            result.add('${entry.key}: ${entry.value}');
          }
        }
        return result.isNotEmpty ? result : null;
      }
    }

    return null;
  }
}
