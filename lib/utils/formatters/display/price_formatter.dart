import 'package:intl/intl.dart';

class PriceFormatter {
  PriceFormatter._();

  static String? _locale;

  static void configure({String? locale}) {
    _locale = locale;
  }

  static String format(
    double price, {
    String? symbol,
    bool symbolAfter = true,
    int decimalDigits = 2,
    String? locale,
  }) {
    final effectiveLocale = locale ?? _locale;
    final formatter = NumberFormat.decimalPatternDigits(
      locale: effectiveLocale,
      decimalDigits: decimalDigits,
    );
    final formattedPrice = formatter.format(price);

    if (symbol == null || symbol.isEmpty) {
      return formattedPrice;
    }

    if (symbolAfter) {
      return '$formattedPrice $symbol';
    }

    return '$symbol$formattedPrice';
  }

  static String formatCompact(
    double price, {
    String? symbol,
    bool symbolAfter = true,
    String? locale,
  }) {
    final effectiveLocale = locale ?? _locale;
    final formatter = NumberFormat.compact(locale: effectiveLocale);
    final formattedPrice = formatter.format(price);

    if (symbol == null || symbol.isEmpty) {
      return formattedPrice;
    }

    if (symbolAfter) {
      return '$formattedPrice $symbol';
    }

    return '$symbol$formattedPrice';
  }

  static int discountPercentage(double originalPrice, double discountedPrice) {
    if (originalPrice <= 0) return 0;
    return ((1 - discountedPrice / originalPrice) * 100).round();
  }

  static String formatDiscount(
    double originalPrice,
    double discountedPrice, {
    String prefix = '-',
    String suffix = '%',
  }) {
    final percentage = discountPercentage(originalPrice, discountedPrice);
    return '$prefix$percentage$suffix';
  }

  static String formatRange(
    double minPrice,
    double maxPrice, {
    String? symbol,
    bool symbolAfter = true,
    int decimalDigits = 2,
    String separator = ' - ',
    String? locale,
  }) {
    final formattedMin = format(
      minPrice,
      symbol: symbol,
      symbolAfter: symbolAfter,
      decimalDigits: decimalDigits,
      locale: locale,
    );
    final formattedMax = format(
      maxPrice,
      symbol: symbol,
      symbolAfter: symbolAfter,
      decimalDigits: decimalDigits,
      locale: locale,
    );

    return '$formattedMin$separator$formattedMax';
  }

  static bool isFree(double price) => price <= 0;

  static bool hasDiscount(double? originalPrice, double currentPrice) {
    if (originalPrice == null) return false;
    return originalPrice > currentPrice;
  }

  static bool hasValidDiscount(double price, double? discountedPrice) {
    if (discountedPrice == null) return false;
    return discountedPrice < price;
  }

  static double calculateSavings(double originalPrice, double currentPrice) {
    if (originalPrice <= currentPrice) return 0;
    return originalPrice - currentPrice;
  }
}
