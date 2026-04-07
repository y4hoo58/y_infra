import 'separator_input_formatter.dart';

class CreditCardNumberInputFormatter extends SeparatorInputFormatter {
  const CreditCardNumberInputFormatter({
    super.separatorIndexes = const [4, 8, 12],
    super.separator = ' ',
  });
}
