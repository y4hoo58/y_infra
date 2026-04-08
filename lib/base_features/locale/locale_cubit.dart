import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale?> {
  final Set<String> _supportedCodes;

  LocaleCubit({required Set<String> supportedCodes})
      : _supportedCodes = supportedCodes,
        super(null);

  bool isSupported(String languageCode) =>
      _supportedCodes.contains(languageCode);

  /// Changes locale if supported, returns false if not.
  /// Calls [context.setLocale] to sync with easy_localization.
  bool changeLocale(BuildContext context, String languageCode) {
    if (!isSupported(languageCode)) return false;
    final locale = Locale(languageCode);
    context.setLocale(locale);
    emit(locale);
    return true;
  }
}
