import 'package:flutter/services.dart';

/// Generic text input formatter that inserts a separator character at specified indexes.
class SeparatorInputFormatter extends TextInputFormatter {
  final List<int> separatorIndexes;
  final String separator;

  const SeparatorInputFormatter({
    required this.separatorIndexes,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var newCursorPosition = newValue.selection.baseOffset;
    final input = newValue.text;
    final buffer = StringBuffer();

    for (var i = 0; i < input.length; i++) {
      if (separatorIndexes.contains(i)) {
        buffer.write(separator);
        if (i < newCursorPosition) {
          newCursorPosition++;
        }
      }
      buffer.write(input[i]);
    }

    if (newCursorPosition > buffer.length) {
      newCursorPosition = buffer.length;
    }

    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.fromPosition(
        TextPosition(offset: newCursorPosition),
      ),
    );
  }
}
