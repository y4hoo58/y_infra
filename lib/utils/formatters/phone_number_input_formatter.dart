import 'separator_input_formatter.dart';

class PhoneNumberInputFormatter extends SeparatorInputFormatter {
  const PhoneNumberInputFormatter({
    super.separatorIndexes = const [3, 6, 8],
    super.separator = ' ',
  });
}
