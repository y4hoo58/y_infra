import 'package:intl/intl.dart';

/// Utility for formatting prices, discounts, and price ranges with locale support.
class PriceFormatter {
  PriceFormatter._();

  static String? _locale;
  static String? _symbol;
  static bool _symbolAfter = true;
  static int _decimalDigits = 2;

  static void configure({
    String? locale,
    String? symbol,
    bool? symbolAfter,
    int? decimalDigits,
  }) {
    _locale = locale;
    _symbol = symbol;
    if (symbolAfter != null) _symbolAfter = symbolAfter;
    if (decimalDigits != null) _decimalDigits = decimalDigits;
  }

  static String format(
    double price, {
    String? symbol,
    bool? symbolAfter,
    int? decimalDigits,
    String? locale,
  }) {
    final effectiveLocale = locale ?? _locale;
    final effectiveSymbol = symbol ?? _symbol;
    final effectiveSymbolAfter = symbolAfter ?? _symbolAfter;
    final effectiveDecimalDigits = decimalDigits ?? _decimalDigits;
    final formatter = NumberFormat.decimalPatternDigits(
      locale: effectiveLocale,
      decimalDigits: effectiveDecimalDigits,
    );
    final formattedPrice = formatter.format(price);

    if (effectiveSymbol == null || effectiveSymbol.isEmpty) {
      return formattedPrice;
    }

    if (effectiveSymbolAfter) {
      return '$formattedPrice $effectiveSymbol';
    }

    return '$effectiveSymbol$formattedPrice';
  }

  static String formatCompact(
    double price, {
    String? symbol,
    bool? symbolAfter,
    String? locale,
  }) {
    final effectiveLocale = locale ?? _locale;
    final effectiveSymbol = symbol ?? _symbol;
    final effectiveSymbolAfter = symbolAfter ?? _symbolAfter;
    final formatter = NumberFormat.compact(locale: effectiveLocale);
    final formattedPrice = formatter.format(price);

    if (effectiveSymbol == null || effectiveSymbol.isEmpty) {
      return formattedPrice;
    }

    if (effectiveSymbolAfter) {
      return '$formattedPrice $effectiveSymbol';
    }

    return '$effectiveSymbol$formattedPrice';
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
    bool? symbolAfter,
    int? decimalDigits,
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
