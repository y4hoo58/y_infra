import 'separator_input_formatter.dart';

/// Text input formatter that inserts spaces every 4 digits for credit card numbers.
class CreditCardNumberInputFormatter extends SeparatorInputFormatter {
  const CreditCardNumberInputFormatter({
    super.separatorIndexes = const [4, 8, 12],
    super.separator = ' ',
  });
}
