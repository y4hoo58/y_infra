import 'separator_input_formatter.dart';

/// Text input formatter that inserts a `/` separator for card expiry (MM/YY).
class CardExpiryInputFormatter extends SeparatorInputFormatter {
  const CardExpiryInputFormatter({
    super.separatorIndexes = const [2],
    super.separator = '/',
  });
}
