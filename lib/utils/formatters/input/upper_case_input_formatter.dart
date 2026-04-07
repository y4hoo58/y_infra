import 'package:flutter/services.dart';

/// Text input formatter that converts all input to uppercase.
class UpperCaseInputFormatter extends TextInputFormatter {
  const UpperCaseInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
