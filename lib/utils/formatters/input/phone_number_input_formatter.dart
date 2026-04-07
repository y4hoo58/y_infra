import 'separator_input_formatter.dart';

/// Text input formatter that inserts spaces to group phone number digits.
class PhoneNumberInputFormatter extends SeparatorInputFormatter {
  const PhoneNumberInputFormatter({
    super.separatorIndexes = const [3, 6, 8],
    super.separator = ' ',
  });
}
