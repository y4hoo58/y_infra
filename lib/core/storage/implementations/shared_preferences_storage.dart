import 'package:shared_preferences/shared_preferences.dart';

import '../i_local_storage.dart';

/// [ILocalStorage] implementation backed by [SharedPreferences] for simple
/// key-value persistence.
class SharedPreferencesStorage implements ILocalStorage {
  final SharedPreferences _prefs;

  const SharedPreferencesStorage(this._prefs);

  @override
  Future<bool> save<T>(String key, T value) async {
    if (value is String) return _prefs.setString(key, value);
    if (value is int) return _prefs.setInt(key, value);
    if (value is double) return _prefs.setDouble(key, value);
    if (value is bool) return _prefs.setBool(key, value);
    if (value is List<String>) return _prefs.setStringList(key, value);
    return false;
  }

  @override
  Future<T?> get<T>(String key) async {
    final value = _prefs.get(key);
    if (value is T) return value;
    return null;
  }

  @override
  Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }

  @override
  Future<bool> clear() async {
    return _prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }
}
