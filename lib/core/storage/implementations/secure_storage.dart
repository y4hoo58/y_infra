import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../i_local_storage.dart';

/// [ILocalStorage] implementation backed by [FlutterSecureStorage] for
/// encrypted key-value persistence.
class SecureStorage implements ILocalStorage {
  final FlutterSecureStorage _storage;

  const SecureStorage(this._storage);

  @override
  Future<bool> save<T>(String key, T value) async {
    try {
      String raw;
      if (value is String) {
        raw = value;
      } else if (value is int) {
        raw = value.toString();
      } else if (value is double) {
        raw = value.toString();
      } else if (value is bool) {
        raw = value ? '1' : '0';
      } else if (value is Map || value is List) {
        raw = jsonEncode(value);
      } else {
        raw = value.toString();
      }
      await _storage.write(key: key, value: raw);
      return true;
    } catch (e) {
      if (kDebugMode) print('SecureStorage.save error: $e');
      return false;
    }
  }

  @override
  Future<T?> get<T>(String key) async {
    try {
      final value = await _storage.read(key: key);
      if (value == null) return null;
      if (T == String) return value as T;
      if (T == int) return int.tryParse(value) as T?;
      if (T == double) return double.tryParse(value) as T?;
      if (T == bool) return (value == '1') as T;
      if (T == Map) return jsonDecode(value) as T;
      if (T == List) return jsonDecode(value) as T;
      return value as T;
    } catch (e) {
      if (kDebugMode) print('SecureStorage.get error: $e');
      return null;
    }
  }

  @override
  Future<bool> remove(String key) async {
    try {
      await _storage.delete(key: key);
      return true;
    } catch (e) {
      if (kDebugMode) print('SecureStorage.remove error: $e');
      return false;
    }
  }

  @override
  Future<bool> clear() async {
    try {
      await _storage.deleteAll();
      return true;
    } catch (e) {
      if (kDebugMode) print('SecureStorage.clear error: $e');
      return false;
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    final value = await _storage.read(key: key);
    return value != null;
  }
}
