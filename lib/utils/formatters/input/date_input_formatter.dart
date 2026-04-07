import 'dart:math';

import 'package:flutter/services.dart';

/// Text input formatter that auto-inserts `/` separators for date input (DD/MM/YYYY).
class DateInputFormatter extends TextInputFormatter {
  const DateInputFormatter();

  static const _maxChars = 8;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = _format(newValue.text, '/');
    return newValue.copyWith(text: text, selection: _updateCursor(text));
  }

  String _format(String value, String separator) {
    value = value.replaceAll(separator, '');
    var newString = '';

    for (int i = 0; i < min(value.length, _maxChars); i++) {
      newString += value[i];
      if ((i == 1 || i == 3) && i != value.length - 1) {
        newString += separator;
      }
    }

    return newString;
  }

  TextSelection _updateCursor(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }
}
