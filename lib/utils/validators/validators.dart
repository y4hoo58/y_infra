import 'package:string_validator/string_validator.dart' as sv;

import 'validator_messages.dart';

/// Collection of reusable form field validators (email, password, phone, etc.).
class Validators {
  final ValidatorMessages messages;

  const Validators({this.messages = const ValidatorMessages()});

  String? Function(String?) email({String? requiredMsg, String? invalidMsg}) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return requiredMsg ?? messages.required;
      }
      if (!sv.isEmail(value.trim())) {
        return invalidMsg ?? messages.invalidEmail;
      }
      return null;
    };
  }

  String? Function(String?) password({
    int minLength = 6,
    String? requiredMsg,
    String? shortMsg,
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return requiredMsg ?? messages.required;
      }
      if (value.length < minLength) {
        return shortMsg ?? messages.passwordMinLength(minLength);
      }
      return null;
    };
  }

  String? Function(String?) phone({String? requiredMsg, String? invalidMsg}) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return requiredMsg ?? messages.required;
      }
      final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length < 7 || digitsOnly.length > 15) {
        return invalidMsg ?? messages.invalidPhone;
      }
      return null;
    };
  }

  String? Function(String?) required({String? msg}) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return msg ?? messages.required;
      }
      return null;
    };
  }

  String? Function(String?) minLength(
    int min, {
    String? requiredMsg,
    String? shortMsg,
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return requiredMsg ?? messages.required;
      }
      if (value.trim().length < min) {
        return shortMsg ?? messages.minLength(min);
      }
      return null;
    };
  }

  String? Function(String?) numeric({String? requiredMsg, String? invalidMsg}) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return requiredMsg ?? messages.required;
      }
      if (!sv.isNumeric(value.trim())) {
        return invalidMsg ?? messages.invalidNumber;
      }
      return null;
    };
  }

  String? Function(String?) mustMatch(
    String Function() other, {
    String? requiredMsg,
    String? mismatchMsg,
  }) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return requiredMsg ?? messages.required;
      }
      if (value.trim() != other().trim()) {
        return mismatchMsg ?? messages.mismatch;
      }
      return null;
    };
  }

  String? Function(String?) requiredWhen(
    bool Function() condition, {
    String? msg,
  }) {
    return (value) {
      if (condition() && (value == null || value.trim().isEmpty)) {
        return msg ?? messages.required;
      }
      return null;
    };
  }
}
