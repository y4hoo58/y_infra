import '../i_cache.dart';
import '../objects/cache_data.dart';
import '../objects/cache_type.dart';

class DefaultCache implements ICache {
  static final DefaultCache _instance = DefaultCache._();
  factory DefaultCache() => _instance;
  DefaultCache._();

  final Map<String, CacheData> _cache = {};

  @override
  void set<T>(String key, T data, {CacheType type = CacheType.global, Duration? ttl}) {
    _cache[key] = CacheData<T>(type, data, ttl: ttl);
  }

  @override
  T? get<T>(String key) {
    final data = _cache[key];
    if (data == null) return null;
    if (data.isExpired) {
      _cache.remove(key);
      return null;
    }
    if (data is! CacheData<T>) return null;
    return data.data;
  }

  @override
  void remove(String key) {
    _cache.remove(key);
  }

  @override
  void removeByPrefix(String prefix) {
    _cache.removeWhere((key, _) => key.startsWith(prefix));
  }

  @override
  void removeAllType(CacheType type) {
    _cache.removeWhere((_, value) => value.type == type);
  }

  @override
  void clear() {
    _cache.clear();
  }
}
